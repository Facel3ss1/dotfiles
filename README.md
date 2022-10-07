# My Dotfiles

These are my dotfiles, managed with [chezmoi](https://chezmoi.io).

Feel free to look around for inspiration, but given that this is for my personal
use don't try to install this yourself!

## Installation

First, install chezmoi into `~/.local/bin`:

```bash
sh -c "$(curl -fsLS https://chezmoi.io/get)" -- -b $HOME/.local/bin
```

Then, apply the dotfiles:

```bash
chezmoi init --apply Facel3ss1
```

## Software

- [nvim](https://neovim.io) ([Config README](private_dot_config/nvim/README.md))
- [fish](https://fishshell.com)
- [starship](https://starship.rs)
- [exa](https://the.exa.website/)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
