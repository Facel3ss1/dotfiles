# justfile for managing nvim config

set windows-shell := ["pwsh.exe", "-NoLogo", "-NoProfile", "-Command"]
remove-dir := if os_family() == "windows" { "Remove-Item -Recurse -Force" } else { "rm -rf" }
nvim-target-dir := home_directory() / ".config" / "nvim"

[private]
default:
    @just --list

# The exact_ attribute in chezmoi isn't good enough for this because it doesn't recursively apply to subdirectories.
# This means that I would need exact_ attributes on all the subdirectories of nvim/, which would mess with my LSPs and tooling.
[doc("Runs `chezmoi apply ~/.config/nvim`, ensuring that unmanaged files are removed")]
apply:
    {{remove-dir}} {{nvim-target-dir}}
    chezmoi apply --force {{nvim-target-dir}}

[doc("Restores nvim's plugins to the state in lazy-lock.json")]
restore:
    nvim --headless -c "Lazy! restore" -c "qa"

[doc("Remove nvim plugins that are no longer in the configuration")]
clean:
    nvim --headless -c "Lazy! clean" -c "qa"
