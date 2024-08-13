# TODO: Add ls aliases (using eza)
New-Alias which Get-Command

if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Remove-Alias cd
    New-Alias cd z
    Invoke-Expression (& { (zoxide init powershell --hook prompt | Out-String) })
}

if (Get-Command lazygit -ErrorAction SilentlyContinue) {
    New-Alias lg lazygit
}
