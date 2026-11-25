# GCP Cloud Devbox Configuration

Ubuntu desktop VM on Google Compute Engine with no public IP. All access goes through Identity-Aware Proxy (IAP). Replace `<PROJECT_ID>` and `<GOOGLE_ACCOUNT>` with your own values.

## VM Specifications
- Machine type: e2-standard-8 (8 vCPU, 32GB) # Resize later: stop, set-machine-type, start
- Boot disk: 200GB pd-balanced # Can grow later, cannot shrink
- OS: Ubuntu 24.04 LTS amd64 (image family `ubuntu-2404-lts-amd64`)
- Region/zone: australia-southeast1 / australia-southeast1-a
- External IP: none
- Linux user: local user `fsun` (zsh, passwordless sudo) # OS Login users have no local password, so RDP needs a local user

## Infrastructure (run on the laptop)
```bash
P=<PROJECT_ID>; R=australia-southeast1; Z=australia-southeast1-a

gcloud services enable iap.googleapis.com --project=$P

# Network: private subnet, outbound internet through Cloud NAT
gcloud compute networks create devbox-vpc --subnet-mode=custom --project=$P
gcloud compute networks subnets create devbox-subnet --network=devbox-vpc --range=10.10.0.0/24 --region=$R --enable-private-ip-google-access --project=$P
gcloud compute routers create devbox-router --network=devbox-vpc --region=$R --project=$P
gcloud compute routers nats create devbox-nat --router=devbox-router --region=$R --auto-allocate-nat-external-ips --nat-all-subnet-ip-ranges --project=$P

# Firewall: only the IAP range may reach SSH and RDP
gcloud compute firewall-rules create devbox-allow-iap --network=devbox-vpc --direction=INGRESS --source-ranges=35.235.240.0/20 --allow=tcp:22,tcp:3389 --target-tags=devbox --project=$P

# VM
gcloud compute instances create devbox-zsun --zone=$Z --machine-type=e2-standard-8 --image-family=ubuntu-2404-lts-amd64 --image-project=ubuntu-os-cloud --boot-disk-size=200GB --boot-disk-type=pd-balanced --subnet=devbox-subnet --no-address --no-service-account --no-scopes --shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --tags=devbox --metadata=enable-oslogin=TRUE --project=$P

# Access: IAP tunnel role for your account only
gcloud projects add-iam-policy-binding $P --member=user:<GOOGLE_ACCOUNT> --role=roles/iap.tunnelResourceAccessor --condition=None

# Schedule: stop 18:00 every day; no automatic start (start on demand with `myvm start`)
gcloud compute resource-policies create instance-schedule devbox-stop-1800 --vm-stop-schedule="0 18 * * *" --timezone="Australia/Sydney" --region=$R --project=$P
gcloud compute instances add-resource-policies devbox-zsun --resource-policies=devbox-stop-1800 --zone=$Z --project=$P
```

## Desktop: XFCE + xrdp + Chrome (run on the VM)
```bash
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y xfce4 xfce4-goodies xrdp dbus-x11
sudo adduser xrdp ssl-cert
echo xfce4-session | sudo tee /etc/skel/.xsession
curl -fsSLo /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && sudo apt-get install -y /tmp/chrome.deb
sudo systemctl enable --now xrdp

# Local user for the RDP login
sudo adduser --disabled-password --gecos '' fsun && sudo usermod -aG sudo fsun
sudo passwd fsun
echo 'fsun ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/90-fsun && sudo chmod 440 /etc/sudoers.d/90-fsun
```

## Time (run on the VM)
- `sudo timedatectl set-timezone Australia/Sydney` # Time sync needs no setup: the GCP image runs chrony against `metadata.google.internal`; check with `timedatectl`

## SSH from the laptop
Add the laptop public key to `/home/fsun/.ssh/authorized_keys` on the VM, then add to `~/.ssh/config` on the laptop:
```
Host devbox myubuntu
  User fsun
  IdentityFile ~/.ssh/google_compute_engine
  IdentitiesOnly yes
  HostKeyAlias devbox-zsun
  ProxyCommand gcloud compute start-iap-tunnel devbox-zsun %p --listen-on-stdin --zone=australia-southeast1-a --project=<PROJECT_ID>
```
- `ssh myubuntu` # Shell
- `ssh -N -L 13389:localhost:3389 myubuntu` # RDP tunnel; then connect Remote Desktop to `localhost:13389` as `fsun`

## Then apply the standard setup
1. `requirements/core_dev.md`, `requirements/shell.md`, `requirements/editors_ide.md`, `requirements/ai.md`
2. `gh auth login` (personal account), then `gh auth setup-git`
3. Resume build (career repo): `sudo apt-get install -y texlive-latex-base texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended texlive-fonts-extra lmodern latexmk poppler-utils`

## Daily commands
```bash
gcloud compute instances start devbox-zsun --zone=australia-southeast1-a --project=<PROJECT_ID>
gcloud compute instances stop devbox-zsun --zone=australia-southeast1-a --project=<PROJECT_ID>
```

## Troubleshooting
- RDP tunnel prints `channel N: open failed: connect failed: Connection refused`: xrdp is not running on the VM. A package install can restart services and xrdp can fail to start again. Fix: `sudo systemctl reset-failed xrdp xrdp-sesman && sudo systemctl start xrdp-sesman xrdp`.
- Prevent it during installs: `sudo NEEDRESTART_SUSPEND=1 apt-get install ...`
- First IAP SSH after the IAM binding fails with `4033 not authorized`: wait about one minute for IAM propagation and retry.

## myvm CLI (laptop)
`util/myvm` wraps the commands above. Install: `ln -sf ~/devel/dotfiles/util/myvm ~/.local/bin/myvm`, then put `MYVM_PROJECT=<PROJECT_ID>` in `~/.config/myvm/config`.
- `myvm status` # VM, tunnel, xrdp state
- `myvm start` / `myvm stop`
- `myvm ssh`
- `myvm tunnel start|stop` # RDP tunnel on localhost:13389, reconnects automatically
- `myvm rdp` # start VM and tunnel if needed, open Remote Desktop
- `myvm fix-rdp` # restart xrdp on the VM
- `myvm suspend` / `myvm resume` # hibernate: memory is kept, VM charge stops
- `myvm idle [MIN]` # show each activity signal (terminal output, Claude conversation files, desktop input, CPU load) and whether the VM would be suspended now
- `myvm autosuspend start [MIN]` / `stop` # laptop-side watcher: suspend after MIN idle minutes (default 15); needs `sudo apt install xprintidle` on the VM for desktop input
- The watcher starts by default with `myvm start`, `resume`, `ssh`, `rdp` and `tunnel start`; set `MYVM_AUTOSUSPEND=0` in the config to turn it off

## Chrome MCP (VM)
- `ln -sfn ~/devel/dotfiles/util/run_chrome_mcp_linux ~/.local/bin/run_chrome_mcp_linux`
- `claude mcp add -s user chrome-devtools -- ~/.local/bin/run_chrome_mcp_linux mcp` # One shared Chrome for all Claude sessions; starts it if it is not running
- Log in to sites once in that Chrome window on the desktop; logins stay in `~/.chrome-mcp-profile`

## Usage history (sizing)
- `sudo apt install sysstat`, set `ENABLED="true"` in `/etc/default/sysstat`, `sudo systemctl enable --now sysstat sysstat-collect.timer` # Records CPU, memory and load every 10 minutes
- `sar -u` (CPU), `sar -r` (memory), `sar -q` (load) # Read the history; add `-f /var/log/sysstat/saDD` for another day
