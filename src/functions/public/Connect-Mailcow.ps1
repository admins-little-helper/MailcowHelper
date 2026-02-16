function Connect-Mailcow {
    <#
    .SYNOPSIS
        Connects to the specified mailcow server using the specified API key, or loads previously saved settings.

    .DESCRIPTION
        Connects to the specified mailcow server using the specified API key, or loads previously saved settings.

        This ensures that the specified API key is valid and stored in memory for sub-sequent function calls.
        To clear the connection settings from memory, run "Disconnect-Mailcow".

    .PARAMETER LoadConfig
        Loads the config from a file.

    .PARAMETER Path
        The path to the config file to load.

    .PARAMETER Computername
        The mailcow server name to connect to.

    .PARAMETER ApiKey
        The API key to use for authentication.

    .PARAMETER ApiVersion
        The API version to use.

    .PARAMETER DisableArgumentCompleter
        Disable the MailcowHelper custom ArgumentCompleter completly.

    .PARAMETER Insecure
        Use http instead of https.

    .PARAMETER SkipCertificateCheck
        Skips certificate validation checks. This includes all validations such as expiration, revocation, trusted root authority, etc.

    .EXAMPLE
        Connect-MHMailcow -Computername mymailcow.example.com -ApiKey 12345-67890-ABCDE-FGHIJ-KLMNO

        Connect to server mymailcow.example.com using the specified API key. If the connection is successful, the mailcow server version is returned.

    .EXAMPLE
        Connect-MHMailcow -LoadConfig

        Loads the config from the default config file ($env:USERPROFILE\.MailcowHelper.json on Windows,
        env:HOME\.MailcowHelper.json on Unix) and uses the connection settings loaded.
        If the connection is successful, the mailcow server version is returned.

    .INPUTS
        Nothing

    .OUTPUTS
        Nothing

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Connect-Mailcow.md
    #>

    [CmdletBinding(DefaultParameterSetName = "ManualConfig")]
    param(
        [Parameter(ParameterSetName = "AutoConfig", Position = 0, Mandatory = $false, HelpMessage = "Loads the config from a file.")]
        [System.Management.Automation.SwitchParameter]
        $LoadConfig,

        [Parameter(ParameterSetName = "AutoConfig", Position = 1, Mandatory = $false, HelpMessage = "The path to the config file to load.")]
        [Alias("FilePath")]
        [System.IO.FileInfo]
        $Path,

        [Parameter(ParameterSetName = "ManualConfig", Position = 0, Mandatory = $true, HelpMessage = "The mailcow server name to connect to.")]
        [Alias("Server", "Hostname")]
        [System.String]
        $Computername,

        [Parameter(ParameterSetName = "ManualConfig", Position = 1, Mandatory = $true, HelpMessage = "The API key to use for authentication.")]
        [System.String]
        $ApiKey,

        [Parameter(ParameterSetName = "ManualConfig", Position = 2, Mandatory = $false, HelpMessage = "The API version to use.")]
        [ValidateSet("v1")]
        [System.String]
        $ApiVersion = "v1",

        [Parameter(ParameterSetName = "ManualConfig", Position = 3, Mandatory = $false, HelpMessage = "Disable the MailcowHelper custom ArgumentCompleter completly.")]
        [Parameter(ParameterSetName = "AutoConfig", Position = 2, Mandatory = $false, HelpMessage = "Disable the MailcowHelper custom ArgumentCompleter completly.")]
        [System.Management.Automation.SwitchParameter]
        $DisableArgumentCompleter,

        [Parameter(ParameterSetName = "ManualConfig", Position = 4, Mandatory = $false, HelpMessage = "Use http instead of https.")]
        [System.Management.Automation.SwitchParameter]
        $Insecure,

        [Parameter(ParameterSetName = "ManualConfig", Position = 5, Mandatory = $false, HelpMessage = "Skips certificate validation checks.")]
        [System.Management.Automation.SwitchParameter]
        $SkipCertificateCheck
    )

    if ($LoadConfig.IsPresent) {
        if ($Path -and (Test-Path -Path $Path)) {
            # Try to load previously saved config from the specified path.
            Get-MailcowHelperConfig -Path $Path
        }
        else {
            # Load config from default config file.
            Get-MailcowHelperConfig
        }

        # If connection parameters are there, try to use it.
        if ($Script:MailcowHelperSession.ConnectParams) {
            if ($Script:MailcowHelperSession.ConnectParams.Computername) {
                $Computername = $Script:MailcowHelperSession.ConnectParams.Computername
            }
            if ($Script:MailcowHelperSession.ConnectParams.ApiVersion) {
                $ApiVersion = $Script:MailcowHelperSession.ConnectParams.ApiVersion
            }
            if ($Script:MailcowHelperSession.ConnectParams.ApiKey) {
                $ApiKey = $Script:MailcowHelperSession.ConnectParams.Insecure
            }
            if ($Script:MailcowHelperSession.ConnectParams.Insecure) {
                # Use http and show a warning about the insecure connection.
                Write-MailcowHelperLog -Message "Insecure connection type enabled!" -Level Warning
                $Insecure = $Script:MailcowHelperSession.ConnectParams.ApiKey
            }
            if ($Script:MailcowHelperSession.ConnectParams.SkipCertificateCheck) {
                # Skip certificate checks and show a warning about it.
                Write-MailcowHelperLog -Message "SkipCertificateCheck set!" -Level Warning
                $SkipCertificateCheck = $Script:MailcowHelperSession.ConnectParams.SkipCertificateCheck
            }
        }
    }
    else {
        # In case a computername was specified.
        if (-not [System.String]::IsNullOrEmpty($Computername)) {
            # Set the session variable to remember connection settings.
            $Script:MailcowHelperSession.ConnectParams.Computername = $Computername
            $Script:MailcowHelperSession.ConnectParams.ApiVersion = $ApiVersion
            $Script:MailcowHelperSession.ConnectParams.ApiKey = $ApiKey
            $Script:MailcowHelperSession.ConnectParams.Insecure = $Insecure.IsPresent
            $Script:MailcowHelperSession.ConnectParams.SkipCertificateCheck = $SkipCertificateCheck.IsPresent
        }
    }

    # Prepare the URI path used to check the status and therefore a successful connection/authentication.
    $UriPath = "get/status/version"

    # Prepare the parameters for the API call.
    $InvokeMailcowHelperRequestParams = @{
        UriPath              = $UriPath
        Method               = "GET"
        Insecure             = $Script:MailcowHelperSession.ConnectParams.Insecure
        SkipCertificateCheck = $Script:MailcowHelperSession.ConnectParams.SkipCertificateCheck
    }

    # Execute the API call.
    $Result = Invoke-MailcowApiRequest @InvokeMailcowHelperRequestParams

    # Check the status code returned.
    if ($Result.PSObject.Properties.Name -contains "version") {
        # Initialize the session and set the autocomplete option.
        Initialize-MailcowHelperSession -DisableArgumentCompleter:$DisableArgumentCompleter.IsPresent

        # Return the result.
        $Result
    }
}
