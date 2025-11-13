
* create a script(shell or python) to meet below requirement
* Only for mac, create into folder of util/ , and link it in ~/.local/bin
* add help subcmd for quick cheatsheet
* Verify in mac terminal so see if working. start, stop. and verify curl if working using mac's IP to able to get version from json

# Requirements: `run_chrome_mcp` helper script (macOS, Chrome DevTools + socat)

## 1. Goal

Create a macOS shell script named `run_chrome_mcp` that:

- Starts a dedicated Chrome instance with DevTools remote debugging on port `9222`, bound only to `127.0.0.1`.
- Starts a `socat` proxy that exposes `LAN_IP:9223` -> `127.0.0.1:9222`, so that an Ubuntu VM can reach Chrome DevTools at `http://LAN_IP:9223`.
- Provides `start`, `stop`, `status`, and `restart` subcommands.
- Performs health checks using `/json/version` on both ports.
- Is idempotent (safe to rerun `start` and `stop` repeatedly).

The Ubuntu side (Claude + Chrome DevTools MCP server configured with `--browserUrl=http://LAN_IP:9223`) is already set up and out of scope.

#
2. Environment & assumptions

- OS: macOS.
- Chrome binary path (standard install):

  - `/Applications/Google Chrome.app/Contents/MacOS/Google Chrome`

- `socat` is installed and in `PATH` (e.g. via `brew install socat`).
- `curl` is available (default on macOS).
- Script is run as the logged-in user (no `sudo` needed under normal conditions).
- The DevTools Chrome instance uses its own profile directory so it does not affect the main Chrome profile:

  - `--user-data-dir="$HOME/.chrome-mcp-profile"`

- Other normal Chrome windows might be running; the script must not kill them when stopping.

## 3. Ports, networking, and IP

- Chrome DevTools instance:

  - Listen address: `127.0.0.1`
  - Port: `9222`
  - Flags:
    - `--remote-debugging-port=9222`
    - `--user-data-dir="$HOME/.chrome-mcp-profile"`
    - `--no-first-run`
    - `--no-default-browser-check`

- `socat` proxy:

  - Listen address: `LAN_IP` (Mac’s LAN IP on the home/office network).
  - Port: `9223`
  - Target: `127.0.0.1:9222`.

- `LAN_IP` detection:

  - If environment variable `LAN_IP` is set, use it.
  - Otherwise detect via `ipconfig getifaddr en0`.
  - If detection fails and `LAN_IP` is not set, the script must print a clear error and exit non‑zero.

## 4. Script interface / CLI

Script file (for example `~/bin/run_chrome_mcp`) with shebang `#!/usr/bin/env bash`.

Supported subcommands:

- `run_chrome_mcp start`
- `run_chrome_mcp stop`
- `run_chrome_mcp status`
- `run_chrome_mcp restart`

If called with no or unknown arguments, print:

Usage: run_chrome_mcp {start|stop|status|restart}

and exit non‑zero.

## 5. State, PIDs, and logs

Use a dedicated state directory:

- `STATE_DIR="$HOME/.chrome-mcp"`
- `LOG_DIR="$STATE_DIR/logs"`

Ensure these exist on each run.

PID files:

- Chrome: `"$STATE_DIR/chrome.pid"`
- `socat`: `"$STATE_DIR/socat.pid"`

Log files (append‑only):

- Chrome: `"$LOG_DIR/chrome-mcp.log"`
- `socat`: `"$LOG_DIR/socat-mcp.log"`

No log rotation is required.

## 6. Behavior: `start`

When running `run_chrome_mcp start`:

1. Ensure `STATE_DIR` and `LOG_DIR` exist.
2. Check port `9222`:

   - Use `lsof -i TCP:9222`.
   - If `9222` is in use by a process whose PID matches `chrome.pid`, treat Chrome as already running.
   - If `9222` is in use by some other process, print a warning (e.g. `Port 9222 already in use by PID <pid> (<command>). Not starting Chrome MCP instance.`) and exit non‑zero.

3. If Chrome is not already running, start it in the background:

   - Use the Chrome binary with the flags from section 3.
   - Redirect stdout/stderr to `chrome-mcp.log` and run in background.
   - Capture `$!` and save to `chrome.pid`.

4. Wait for Chrome DevTools to be ready:

   - Poll `http://127.0.0.1:9222/json/version` with `curl --silent --max-time 1`.
   - Retry every 0.5–1 second up to ~10–15 seconds.
   - If it never responds, print an error and exit non‑zero.

5. Determine `LAN_IP`:

   - Use `$LAN_IP` if already exported, otherwise run `ipconfig getifaddr en0`.
   - If still empty, print `Could not determine LAN IP on interface en0. Set LAN_IP and try again.` and exit non‑zero.

6. Check port `9223`:

   - Use `lsof -i TCP:9223`.
   - If `9223` is in use by a process whose PID matches `socat.pid`, treat socat as already running.
   - If `9223` is in use by some other process, print a warning and exit non‑zero.

7. If socat is not already running, start it in the background:

   - Command pattern: `socat TCP-LISTEN:9223,bind="$LAN_IP",reuseaddr,fork TCP:127.0.0.1:9222` (stdout/stderr → `socat-mcp.log`, background).
   - Capture `$!` and save to `socat.pid`.

8. Health check the proxy:

   - Use `curl --silent --max-time 3 "http://$LAN_IP:9223/json/version"`.
   - Require HTTP 200 and output that looks like Chrome DevTools JSON (contains `"Browser"`).
   - If it fails, print `Proxy health check failed for http://$LAN_IP:9223/json/version` and exit non‑zero.

9. On success, print a short summary, for example:

   - `Chrome MCP DevTools instance: running (PID <chrome_pid>, 127.0.0.1:9222, profile ~/.chrome-mcp-profile)`  
   - `socat proxy: running (PID <socat_pid>, $LAN_IP:9223 -> 127.0.0.1:9222)`  
   - `Health check: OK (http://$LAN_IP:9223/json/version)`

Return exit code 0.

## 7. Behavior: `status`

When running `run_chrome_mcp status`:

1. Read `chrome.pid` and `socat.pid` if they exist.
2. For each PID file:

   - If present, read PID.
   - Use `ps -p <PID>` or `kill -0 <PID>` to check if process is running.
   - Optionally confirm the command name (Chrome vs `socat`).
   - If PID file exists but process is not running, mark as “STALE PID”.

3. Check ports:

   - Use `lsof -i TCP:9222` and `lsof -i TCP:9223` to see what is actually bound.

4. Run HTTP checks:

   - Chrome: `curl --silent --max-time 2 http://127.0.0.1:9222/json/version`.
   - Proxy: determine `LAN_IP` as in `start`, then `curl --silent --max-time 2 http://$LAN_IP:9223/json/version`.

5. Print a human‑readable summary that includes:

   - For Chrome: PID status, port 9222, and HTTP result.
   - For socat: PID status, port 9223, and HTTP result.
   - Overall health (e.g. `Overall: HEALTHY` or `Overall: UNHEALTHY`).

Exit code:

- 0 if both Chrome and socat are running and both HTTP checks succeed.
- Non‑zero if any component is down or failing health checks.

## 8. Behavior: `stop`

When running `run_chrome_mcp stop`:

1. Stop socat first:

   - If `socat.pid` exists:
     - Read PID.
     - Check if process is running and is `socat`.
     - Send `kill PID` (SIGTERM), wait a few seconds, then `kill -9 PID` if still running.
     - Remove `socat.pid`.
   - If no PID file or no such process, print `socat already stopped` and continue.

2. Stop Chrome DevTools instance:

   - If `chrome.pid` exists:
     - Read PID.
     - Check if process is running and looks like `Google Chrome`.
     - Send `kill PID` (SIGTERM), wait a few seconds, then `kill -9 PID` if still running.
     - Remove `chrome.pid`.
   - If no PID file or no such process, print `Chrome MCP instance already stopped`.

3. Optionally, verify that ports `9222` and `9223` are no longer bound by these processes.

4. Print a summary, for example:

   - `Stopped socat proxy (if it was running).`
   - `Stopped Chrome MCP DevTools instance (if it was running).`
   - `Ports 9222 and 9223 should now be free.`

Return exit code 0 unless there was a serious error (e.g. failed to kill a process).

## 9. Behavior: `restart`

When running `run_chrome_mcp restart`:

- Equivalent to running `stop` then `start` in sequence.
- Should print combined output.
- Exit code should reflect the outcome of `start` (i.e. non‑zero if `start` fails).

## 10. Error handling and robustness

- If Chrome binary does not exist at `/Applications/Google Chrome.app/Contents/MacOS/Google Chrome`, print a clear error and exit non‑zero.
- If `socat` is not found in `PATH`, print `socat not found. Please install it (e.g. brew install socat).` and exit non‑zero.
- If `curl` is missing, print an error and exit non‑zero.
- `start` and `stop` must be idempotent:
  - Running `start` when everything is already up must not create duplicate processes; it should detect and confirm.
  - Running `stop` when everything is already down must not be treated as an error; just report “already stopped”.
- All error paths should print clear, human‑readable messages.

## 11. Optional: watch / auto‑heal mode

(Optional, only if not too complex.)

- Add subcommand `run_chrome_mcp watch` that:
  - Periodically (e.g. every 15–30 seconds) runs the equivalent of `status`.
  - If either Chrome or socat is down, or health checks fail:
    - Append a line with timestamp and summary to a watch log (e.g. `$LOG_DIR/watch.log`).
    - Attempt to call `start` (or restart just the missing parts).
- Console output in watch mode can be minimal by default, with an optional `DEBUG=1` env flag for more verbose logs.

