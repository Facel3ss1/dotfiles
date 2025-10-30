# Peter's Dotfiles

These are my dotfiles, managed with [chezmoi](https://chezmoi.io).

I currently use these on Linux and Windows (WSL and natively). The dotfiles are mostly for command-line dev tools, and they are intended to be indifferent towards how you install your software, so you can use whatever package manager or distro you want.

## Software

Below is a non-exhaustive list of software that these dotfiles have configs for. As mentioned above, you can install this software however you want, but on Linux it may be worth considering a distro-agnostic package manager like [`brew`](https://docs.brew.sh/Homebrew-on-Linux). On Windows, I recommend using [`scoop`](https://scoop.sh/).

- [Neovim](https://neovim.io) (See the [config's README](./private_dot_config/nvim/README.md) for software requirements)
- [WezTerm](https://wezfurlong.org/wezterm/index.html)
- [`fish` Shell](https://fishshell.com) (on Linux)
- [PowerShell](https://github.com/PowerShell/PowerShell) (on Windows)
- [`starship` Prompt](https://starship.rs)
- [Atuin](https://atuin.sh/) (Linux only)
- [Jujutsu VCS](https://jj-vcs.github.io/jj/latest/)
- [Difftastic](https://difftastic.wilfred.me.uk/)
- [`eza`](https://eza.rocks)
- [`zoxide`](https://github.com/ajeetdsouza/zoxide)

## Installation

First, you need to [install `chezmoi`](https://chezmoi.io/install/). You can use a package manager or the one-line install script. You should install Git and [set up an SSH key along with `ssh-agent`](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) (consider using the [`AddKeysToAgent`](https://man.openbsd.org/ssh_config#AddKeysToAgent) option) if you haven't already. On Windows, you should also [enable Developer Mode](https://learn.microsoft.com/en-us/windows/apps/get-started/enable-your-device-for-development), which allows `chezmoi` to create symbolic links without needing to elevate to administrator.

Next, we need to `git clone` the dotfiles into chezmoi's source directory (`~/.local/share/chezmoi/`), generate chezmoi's config file (`~/.config/chezmoi/chezmoi.toml`), and then apply the dotfiles. To do this, run the commands below. When you run [`chezmoi init`](https://www.chezmoi.io/reference/commands/init/), it will ask for information that is used to populate the dotfiles (e.g. git name/email, code editor) - some of these options will indicate a default which you can press <kbd>Enter</kbd> to use.

```bash
chezmoi init github.com/petermused/dotfiles --ssh # The --ssh option performs the git clone using an SSH URL instead of a HTTPS URL
chezmoi apply
```

You have now installed the dotfiles! To change them, edit the files in chezmoi's source directory, and run [`chezmoi apply`](https://www.chezmoi.io/reference/commands/apply/) to apply the changes to your home directory. If your changes affect chezmoi's config file, you may need to run `chezmoi init` first. See [chezmoi's documentation](https://www.chezmoi.io/user-guide/command-overview/) for more.

If you have installed Neovim, read the [Neovim README](./private_dot_config/nvim/README.md) for information on how to manage the Neovim plugins, and what software is required to use them.
