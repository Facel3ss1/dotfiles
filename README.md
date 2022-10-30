# My Dotfiles

These are my dotfiles, managed with [chezmoi](https://chezmoi.io).

Feel free to look around for inspiration, but given that this is for my personal
use don't try to install this yourself!

## Installation

<!-- TODO: Document windows instalation and nvim setup -->

First, install [chezmoi](https://chezmoi.io) and the [Bitwarden
CLI](https://bitwarden.com/help/cli/) into `~/.local/bin`.

Chezmoi has a one line installer:

```bash
sh -c "$(curl -fsLS https://chezmoi.io/get)" -- -b ~/.local/bin
```

For Bitwarden, you need to unzip the binary and move it yourself:

```bash
unzip bw-linux-x.x.x.zip
chmod +x bw
mv bw ~/.local/bin
```

Then, log in to Bitwarden:

```bash
bw login
```

Now we can apply the dotfiles:

```bash
chezmoi init --apply Facel3ss1
```

Don't forget to lock your Bitwarden vault once you're done:

```bash
bw lock
```

## Software

- [nvim](https://neovim.io) ([Config README](private_dot_config/nvim/README.md))
- [fish](https://fishshell.com)
- [starship](https://starship.rs)
- [exa](https://the.exa.website/)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
