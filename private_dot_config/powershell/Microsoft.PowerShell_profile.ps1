# TODO: Add ls aliases (using eza)
New-Alias which Get-Command

if (Get-Command fnm -ErrorAction SilentlyContinue) {
    fnm env --use-on-cd | Out-String | Invoke-Expression
}

if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Remove-Alias cd
    New-Alias cd z
    Invoke-Expression (& { (zoxide init powershell --hook prompt | Out-String) })
}
