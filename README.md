# RD-one-click-configuration

R&D environment one-click configuration script for Linux servers.

### Usage

```bash
./install.sh
```

### Supported OS

- CentOS
- Ubuntu
- Debian

### What it does

1. **Mirrors source** — configure yum / apt mirror (disabled, pending test)
2. **zsh & oh-my-zsh** — install zsh, oh-my-zsh with `bira` theme, `zsh-autosuggestions` and `zsh-syntax-highlighting` plugins, set zsh as default shell
3. **Config files** — deploy `.vimrc`, `.gitconfig`, `.ssh/config`, and custom aliases to both `.bashrc` and `.zshrc`
4. **tmux** — install via package manager
5. **ccat** — install colorized `cat` replacement

### Software List

| Software | Description |
|----------|-------------|
| zsh | Z shell |
| oh-my-zsh | zsh framework with theme & plugins |
| zsh-autosuggestions | fish-like autosuggestions for zsh |
| zsh-syntax-highlighting | syntax highlighting for zsh |
| tmux | terminal multiplexer |
| ccat | colorized cat |
| vim | text editor |
