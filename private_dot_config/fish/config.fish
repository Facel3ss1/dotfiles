# TODO: ctrl+y to autocomplete

# Make sure everything is in the PATH before setting environment variables
# This means the `if type -q` queries below will work properly
fish_add_path -g ~/.local/bin
fish_add_path -g ~/.cargo/bin
# elan is a fork of rustup but for installations of the Lean theorem prover
fish_add_path -g ~/.elan/bin
# ghcup-env
set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
set -gx PATH $HOME/.cabal/bin $HOME/.ghcup/bin $PATH

# pnpm
set -gx PNPM_HOME $HOME/.local/share/pnpm
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end

# Disable the fish greeting (https://fishshell.com/docs/current/faq.html#how-do-i-change-the-greeting-message)
set -g fish_greeting

# Vi mode
set -g fish_key_bindings fish_vi_key_bindings
set -g fish_cursor_default block
set -g fish_cursor_insert line
set -g fish_cursor_replace_one underscore

if type -q nvim
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    set -gx MANPAGER 'nvim +Man!'
    set -gx MANWIDTH 80
    # Let Neovim handle the text wrapping
    # set -gx MANWIDTH 999
end

# Make less support colors and scrolling with the mouse
set -gx LESS '-R --mouse --wheel-lines=3'
set -gx PAGER less

if status is-interactive
    # TODO: Move to abbreviations file

    if type -q nvim
        abbr --add --global vim nvim
        abbr --add --global vi nvim
    end

    if type -q eza
        abbr --add --global ls 'eza --icons'
        abbr --add --global la 'eza -la --git --icons'
        abbr --add --global ll 'eza -l --git --icons'
        abbr --add --global lat 'eza -la --git --tree --icons'
        abbr --add --global llt 'eza -l --git --tree --icons'
    else
        abbr --add --global ls 'ls --color=auto'
        abbr --add --global la 'ls -lA --color=auto'
        abbr --add --global ll 'ls -l --color=auto'
    end

    if type -q lazygit
        abbr --add --global lg lazygit
    end
end

if type -q starship
    starship init fish | source
end

if type -q zoxide
    zoxide init fish --hook prompt | source
end

if type -q jj
    jj util completion fish | source
end
