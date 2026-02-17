function Get-MailcowHelperConfig {
    <#
    .SYNOPSIS
        Reads settings form a MailcowHelper config file.

    .DESCRIPTION
        Reads settings form a MailcowHelper config file.
        This allows to re-use previously saved settings like mailcow servername, API key or argument completer configuration.
        If the specified file or the default config file does not exist, default settings are returned.

    .PARAMETER Path
        The full path to a MailcowHelper settings file (a JSON file).

    .PARAMETER Passthru
        If specified, returns the settings read from the file.
        Otherwise the settings are only stored in the module session variable and are therefore only accessable by functions in the module.

    .EXAMPLE
        Get-MHMailcowHelperConfig

        Tries to read settings from the default MailcowHelper config file in $env:USERPROFILE\.MailcowHelper.json

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailcowHelperConfig.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "The full path to a MailcowHelper settings file (a JSON file).")]
        [Alias("FilePath")]
        [System.IO.FileInfo]
        $Path,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "If specified, returns the settings read from the file.")]
        [System.Management.Automation.SwitchParameter]
        $Passthru
    )

    # Define a default path if none was specified, depending on the OS.
    if ($null -eq $Path) {
        switch ($PSVersionTable.Platform) {
            "Win32NT" {
                $Path = "$env:USERPROFILE\.MailcowHelper.json"
                break
            }
            "Unix" {
                $Path = "$env:HOME\.MailcowHelper.json"
                break
            }
            default {
                Write-MailcowHelperLog -Message "Operating system not detected." -Level Warning
            }
        }
    }

    # Validate if the path exists.
    if (Test-Path -Path $Path) {
        # Read config from Path.
        Write-MailcowHelperLog -Message "Reading config from [$($Path.FullName)]."
        $Config = Get-Content -Path $Path | ConvertFrom-Json

        if ($Passthru.IsPresent) {
            $Config
        }
        else {
            if ($Config.SessionData) {
                $Script:MailcowHelperSession.ConnectParams = $Config.SessionData.ConnectParams
                if ($null -ne $Config.SessionData.ArgumentCompleterConfig) {
                    $Script:MailcowHelperSession.ArgumentCompleterConfig = $Config.SessionData.ArgumentCompleterConfig
                }

                # Convert ApiKey stored as secure string back to plain text.
                if (-not [System.String]::IsNullOrEmpty($Script:MailcowHelperSession.ConnectParams.ApiKey)) {
                    $Script:MailcowHelperSession.ConnectParams.ApiKey = $Script:MailcowHelperSession.ConnectParams.ApiKey | ConvertTo-SecureString | ConvertFrom-SecureString -AsPlainText
                }
            }
        }
    }
    else {
        Write-MailcowHelperLog -Message "The specified path is not valid [$($Path.FullName)]." -Level Warning
        Write-MailcowHelperLog -Message "Either specify the path to a valid MailcowHelper config file, or connect manually and save the config to a new file using "Set-MailcowHelperConfig"." -Level Warning

        # Use some default settings.
        $Script:MailcowHelperSession.ConnectParams = @{}
        $Script:MailcowHelperSession.ArgumentCompleterConfig = @{
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
    }
}