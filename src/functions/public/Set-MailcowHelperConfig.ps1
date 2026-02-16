function Set-MailcowHelperConfig {
    <#
    .SYNOPSIS
        Saves settings to a MailcowHelper config file.

    .DESCRIPTION
        Saves settings to a MailcowHelper config file.
        This allows to re-use previously saved settings like mailcow servername, API key or argument completer configuration.

    .PARAMETER Path
        The full path to a MailcowHelper settings file (a JSON file).

    .EXAMPLE
        Set-MHMailcowHelperConfig

        Saves settings to the default MailcowHelper config file in $env:USERPROFILE\.MailcowHelper.json

    .INPUTS
        Nothing

    .OUTPUTS
        Nothing

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailcowHelperConfig.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "The full path to a MailcowHelper settings file (a JSON file).")]
        [Alias("FilePath")]
        [System.IO.FileInfo]
        $Path
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

    # Save current date/time.
    $CurrentDateTime = Get-Date

    # Prepare a default config.
    $DefaultConfig = @{
        MetaData    = @{
            WhenCreated                = $CurrentDateTime
            WhenUpdated                = $CurrentDateTime
            MailcowHelperModuleVersion = $((Get-Module -Name MailcowHelper).Version.ToString())
        }
        SessionData = @{
            ConnectParams           = @{
                Computername         = ""
                ApiVersion           = "v1"
                ApiKey               = ""
                Insecure             = $false
                SkipCertificateCheck = $false
            }
            ArgumentCompleterConfig = @{
                EnableFor = @("Alias", "AliasDomain", "Domain", "DomainAdmin", "Mailbox", "Resource")
            }
        }
    }

    # Check if the path exists.
    if (Test-Path -Path $Path) {
        # The file exists, therefore read current config from $Path and just update it.
        $CurrentConfig = Get-MailcowHelperConfig -Path $Path -Passthru
        # Update the modified timestamp.
        if ($CurrentConfig.MetaData) {
            $CurrentConfig.MetaData.WhenUpdated = $CurrentDateTime
        }
    }
    else {
        # Build data from scratch by using the default config.
        $CurrentConfig = $DefaultConfig
    }

    # Update ConnectParams SessionData.
    if ($Script:MailcowHelperSession.ConnectParams) {
        # Save the connection parameters from the session variable.
        $CurrentConfig.SessionData.ConnectParams = $Script:MailcowHelperSession.ConnectParams
        # Convert the ApiKey value to a secure string.
        $CurrentConfig.SessionData.ConnectParams.ApiKey = $Script:MailcowHelperSession.ConnectParams.ApiKey | ConvertTo-SecureString -AsPlainText | ConvertFrom-SecureString
    }

    # Update ArgumentCompleter SessionData.
    if ($Script:MailcowHelperSession.ArgumentCompleterConfig) {
        # Save the connection paramets from the session variable.
        $CurrentConfig.SessionData.ArgumentCompleterConfig = $Script:MailcowHelperSession.ArgumentCompleterConfig
    }

    if ($PSCmdlet.ShouldProcess("MailcowHelper config to file [$($Path.Fullname)].", "Save")) {
        Write-MailcowHelperLog -Message "Saving MailcowHelper config to file [$($Path.Fullname)]." -Level Information

        # Save the config in the file.
        Write-MailcowHelperLog -Message "[$($Path.FullName)] Save config to file." -Level Information
        $CurrentConfig | ConvertTo-Json -Depth 3 | Set-Content -Path $Path
    }
}