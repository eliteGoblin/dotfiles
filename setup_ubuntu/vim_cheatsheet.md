# Vim/Neovim Cheatsheet

## Navigation Basics

### Cursor Movement
| Key | Action |
|-----|--------|
| `h` `j` `k` `l` | Left, Down, Up, Right |
| `w` | Next word start |
| `b` | Previous word start |
| `e` | Next word end |
| `0` | Start of line |
| `^` | First non-whitespace character |
| `$` | End of line |
| `gg` | First line of file |
| `G` | Last line of file |
| `{line}G` | Go to line number (e.g., `42G`) |
| `%` | Jump to matching bracket/paren |

### Screen Movement
| Key | Action |
|-----|--------|
| `Ctrl+d` | Scroll down half page |
| `Ctrl+u` | Scroll up half page |
| `Ctrl+f` | Scroll down full page |
| `Ctrl+b` | Scroll up full page |
| `zz` | Center cursor on screen |
| `zt` | Move cursor line to top |
| `zb` | Move cursor line to bottom |

### Search & Find
| Key | Action |
|-----|--------|
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` | Next search result |
| `N` | Previous search result |
| `*` | Search word under cursor (forward) |
| `#` | Search word under cursor (backward) |
| `f{char}` | Find next char on line |
| `F{char}` | Find previous char on line |
| `t{char}` | Till (before) next char on line |
| `T{char}` | Till (before) previous char on line |
| `;` | Repeat last f/F/t/T |
| `,` | Repeat last f/F/t/T (reverse) |

## Editing

### Insert Mode
| Key | Action |
|-----|--------|
| `i` | Insert before cursor |
| `a` | Insert after cursor |
| `I` | Insert at start of line |
| `A` | Insert at end of line |
| `o` | Open new line below |
| `O` | Open new line above |
| `Esc` | Return to normal mode |

### Delete/Cut
| Key | Action |
|-----|--------|
| `x` | Delete character |
| `dd` | Delete line |
| `dw` | Delete word |
| `d$` or `D` | Delete to end of line |
| `d0` | Delete to start of line |
| `dG` | Delete to end of file |
| `dgg` | Delete to start of file |
| `di(` | Delete inside parentheses |
| `di{` or `diB` | Delete inside braces |
| `di[` | Delete inside brackets |
| `di"` | Delete inside quotes |
| `daw` | Delete a word (with whitespace) |
| `das` | Delete a sentence |
| `dap` | Delete a paragraph |

### Change (Delete + Insert)
| Key | Action |
|-----|--------|
| `cc` | Change entire line |
| `cw` | Change word |
| `c$` or `C` | Change to end of line |
| `ci(` | Change inside parentheses |
| `ci{` or `ciB` | Change inside braces |
| `ci"` | Change inside quotes |
| `ciw` | Change inner word |
| `caw` | Change a word (with whitespace) |

### Copy (Yank)
| Key | Action |
|-----|--------|
| `yy` | Copy line |
| `yw` | Copy word |
| `y$` | Copy to end of line |
| `yG` | Copy to end of file |
| `yi(` | Copy inside parentheses |
| `yi{` or `yiB` | Copy inside braces |
| `yaw` | Copy a word |

### Paste
| Key | Action |
|-----|--------|
| `p` | Paste after cursor/line |
| `P` | Paste before cursor/line |

### Undo/Redo
| Key | Action |
|-----|--------|
| `u` | Undo |
| `Ctrl+r` | Redo |
| `.` | Repeat last change |

## Visual Mode

| Key | Action |
|-----|--------|
| `v` | Visual mode (character) |
| `V` | Visual line mode |
| `Ctrl+v` | Visual block mode |
| `gv` | Reselect last visual selection |
| `o` | Move to other end of selection |
| `>` | Indent selection |
| `<` | Unindent selection |
| `=` | Auto-indent selection |

## File Operations

| Key | Action |
|-----|--------|
| `:w` | Save file |
| `:wq` or `ZZ` | Save and quit |
| `:q` | Quit |
| `:q!` or `ZQ` | Quit without saving |
| `:e {file}` | Open file |
| `:bn` | Next buffer |
| `:bp` | Previous buffer |
| `:bd` | Close buffer |

## Window/Split Management

| Key | Action |
|-----|--------|
| `:vs` or `:vsplit` | Vertical split |
| `:sp` or `:split` | Horizontal split |
| `Ctrl+w h` | Move to left window |
| `Ctrl+w j` | Move to down window |
| `Ctrl+w k` | Move to up window |
| `Ctrl+w l` | Move to right window |
| `Ctrl+w w` | Cycle through windows |
| `Ctrl+w q` | Close current window |
| `Ctrl+w =` | Equal window sizes |
| `Ctrl+w _` | Maximize height |
| `Ctrl+w |` | Maximize width |

## Tab Management

| Key | Action |
|-----|--------|
| `:tabnew` | New tab |
| `:tabnew {file}` | Open file in new tab |
| `gt` | Next tab |
| `gT` | Previous tab |
| `{n}gt` | Go to tab n |
| `:tabclose` | Close current tab |
| `:tabonly` | Close all other tabs |

## Text Objects (powerful!)

### Inside vs Around
- `i` = inside (excludes delimiters)
- `a` = around (includes delimiters)

| Object | Description |
|--------|-------------|
| `iw` / `aw` | Word |
| `is` / `as` | Sentence |
| `ip` / `ap` | Paragraph |
| `i(` / `a(` or `ib` / `ab` | Parentheses |
| `i{` / `a{` or `iB` / `aB` | Braces |
| `i[` / `a[` | Brackets |
| `i"` / `a"` | Double quotes |
| `i'` / `a'` | Single quotes |
| `i\`` / `a\`` | Backticks |
| `it` / `at` | HTML/XML tags |

**Examples:**
- `ciw` - Change inner word
- `di(` - Delete inside parentheses
- `ya{` - Yank around braces (including `{}`)
- `vit` - Visually select inner tag (HTML/JSX)

## JavaScript/TypeScript Specific

### Bracket Navigation
| Key | Action |
|-----|--------|
| `%` | Jump to matching bracket |
| `di{` | Delete inside function body |
| `ci(` | Change function arguments |
| `va{` | Select entire block with braces |
| `dit` | Delete inner JSX tag |
| `cit` | Change inner JSX tag content |

### Common Workflows
```javascript
const obj = { name: 'test', value: 42 };
//          ↑ cursor here, press %        ↑ jumps here
//          ↑ cursor here, press ci{       ↑ deletes content, enters insert
//          ↑ cursor here, press ya{       ↑ yanks entire object including {}
```

## Search & Replace

| Command | Action |
|---------|--------|
| `:%s/old/new/g` | Replace all in file |
| `:%s/old/new/gc` | Replace all with confirmation |
| `:s/old/new/g` | Replace in current line |
| `:'<,'>s/old/new/g` | Replace in visual selection |

## Macros

| Key | Action |
|-----|--------|
| `q{letter}` | Start recording macro to register |
| `q` | Stop recording |
| `@{letter}` | Play macro |
| `@@` | Replay last macro |

## Marks & Jumps

| Key | Action |
|-----|--------|
| `m{letter}` | Set mark (a-z local, A-Z global) |
| `'{letter}` | Jump to mark (line start) |
| `\`{letter}\`` | Jump to mark (exact position) |
| `''` | Jump to last position |
| `Ctrl+o` | Jump to previous location |
| `Ctrl+i` | Jump to next location |

## LSP Commands (with nvim-lspconfig)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `K` | Hover documentation |
| `gi` | Go to implementation |
| `gr` | Show references |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `:LspInfo` | Show LSP status |
| `:Mason` | Open Mason package manager |

## Custom Keybindings (from your init.lua)

### File Tree (nvim-tree)
| Key | Action |
|-----|--------|
| `Ctrl+n` | Toggle file tree |
| `Space+e` | Reveal current file in tree |
| `a` (in tree) | Create new file |
| `A` (in tree) | Create new directory |
| `d` (in tree) | Delete file/directory |
| `r` (in tree) | Rename file/directory |

### Telescope (Fuzzy Finder)
| Key | Action |
|-----|--------|
| `Space+ff` | Find files |
| `Space+fa` | Find all files (including hidden) |
| `Space+fg` | Live grep (search in files) |
| `Space+fb` | Find buffers |
| `Space+fh` | Help tags |

### Terminal (toggleterm)
| Key | Action |
|-----|--------|
| `Ctrl+t` | Toggle terminal |
| `Esc` (in term) | Exit terminal mode to normal |
| `Ctrl+h/j/k/l` (in term) | Navigate to other windows |

### General
| Key | Action |
|-----|--------|
| `Space+w` | Save file |
| `Space+qq` | Quit all (prompts if unsaved) |
| `Space+qQ` | Force quit all |
| `Space+cpf` | Copy full file path |
| `Space+cpr` | Copy relative file path |
| `Space+cpn` | Copy file name only |

### Commenting (Comment.nvim)
| Key | Action |
|-----|--------|
| `gcc` | Toggle line comment |
| `gbc` | Toggle block comment |
| `gc` (visual) | Comment selection |

## Mason Package Manager

### Navigation
| Key | Action |
|-----|--------|
| `1` | All packages tab |
| `2` | LSP servers tab |
| `3` | DAP servers tab |
| `4` | Linters tab |
| `5` | Formatters tab |
| `g?` | Show help |
| `q` | Quit Mason |

### Actions
| Key | Action |
|-----|--------|
| `i` | Install package under cursor |
| `u` | Update package |
| `X` | Uninstall package |
| `/` | Search packages |

## Tips & Tricks

### Repeat Actions
- `.` - Repeat last change (extremely powerful!)
- `@:` - Repeat last command
- `@@` - Repeat last macro

### Quick Edits
- `>>` - Indent line
- `<<` - Unindent line
- `==` - Auto-indent line
- `J` - Join line below to current

### Case Conversion
- `~` - Toggle case of character
- `gU{motion}` - Uppercase (e.g., `gUiw` uppercase word)
- `gu{motion}` - Lowercase (e.g., `guiw` lowercase word)

### Multi-line Insert
1. `Ctrl+v` - Enter visual block mode
2. Select lines with `j/k`
3. `I` - Insert at start of block
4. Type text
5. `Esc` - Apply to all lines

### Surround Tricks (with text objects)
- `ci"` - Change inside quotes, then type new content
- `di(` - Delete function arguments
- `ysiw"` - Wrap word in quotes (requires vim-surround plugin)

## Common Workflows

### Refactoring a variable name
1. `*` - Search for word under cursor
2. `cgn` - Change next occurrence
3. `.` - Repeat for each occurrence (or `n.n.n.`)

### Delete empty lines
- `:g/^$/d` - Delete all empty lines

### Format JSON
- `:%!jq .` - Format entire file as JSON (requires jq)

### Sort lines
- `:sort` - Sort selected lines
- `:%sort` - Sort entire file
