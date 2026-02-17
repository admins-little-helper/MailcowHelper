# Adding Module variable, aka Pseudo-Namespace
# More information can be found here: https://thedavecarroll.com/powershell/how-i-implement-module-variables/
$MailcowHelper = [ordered]@{
    ConnectParams           = @{}
    ArgumentCompleterConfig = @{
        EnableFor = @(
            "Alias",
            "AliasDomain",
            "Domain",
            "DomainTemplate",
            "DomainAdmin",
            "Mailbox",
            "MailboxTemplate",
            "Resource"
        )
    }
    ArgumentCompleter       = @{}
}
New-Variable -Name MailcowHelperSession -Value $MailcowHelper -Scope Script -Force

# Get public and private function definition files.
$PublicScripts = @( Get-ChildItem -Path $PSScriptRoot\functions\public\*.ps1 -ErrorAction SilentlyContinue )
$PrivateScripts = @( Get-ChildItem -Path $PSScriptRoot\functions\private\*.ps1 -ErrorAction SilentlyContinue )

# Dot source the files
foreach ($ScriptToImport in @($PublicScripts + $PrivateScripts)) {
    try {
        Write-Verbose -Message "Importing script [$($ScriptToImport.FullName)]."
        . $ScriptToImport.FullName
    }
    catch {
        Write-Error -Message "Failed to import function [$($ScriptToImport.FullName)]: $_"
    }
}

Export-ModuleMember -Function $PublicScripts.Basename -Alias *
