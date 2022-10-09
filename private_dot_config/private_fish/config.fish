set fish_greeting

# Vi mode
set -g fish_key_bindings fish_vi_key_bindings
set -g fish_cursor_default block
set -g fish_cursor_insert line
set -g fish_cursor_replace_one underscore

# Set LS_COLORS to ~/.dircolors
# fish has a shim for csh setenv commands
# eval (dircolors -c ~/.dircolors)

if type -q nvim
    set -gx EDITOR 'nvim'
    set -gx VISUAL 'nvim'
    set -gx MANPAGER 'nvim +Man!'
end

# Make less support colors and scrolling w/ the mouse
set -gx LESS '-R --mouse --wheel-lines=3'
set -gx PAGER 'less'

fish_add_path -g ~/.local/bin
fish_add_path -g ~/.cargo/bin
# elan is a fork of rustup but for installations of the Lean theorem prover
fish_add_path -g ~/.elan/bin
set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin $HOME/.ghcup/bin $PATH # ghcup-env

if status is-interactive
    # TODO: Move to abbreviations file
    # TODO: Add git abbreviations

    if type -q nvim
        abbr --add --global vim 'nvim'
        abbr --add --global vi 'nvim'
    end

    if type -q exa
        abbr --add --global ls 'exa'
        abbr --add --global la 'exa -la --git'
        abbr --add --global ll 'exa -l --git'
        abbr --add --global lat 'exa -la --git --tree'
        abbr --add --global llt 'exa -l --git --tree'
    else
        abbr --add --global ls 'ls --color=auto'
        abbr --add --global la 'ls -lA --color=auto'
        abbr --add --global ll 'ls -l --color=auto'
    end
end

if type -q starship
    starship init fish | source
end

if type -q zoxide
    zoxide init fish | source
end
