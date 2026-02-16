function New-RoutingRelayHost {
    <#
    .SYNOPSIS
        Creates a relay host (sender-dependent transport) configuration on the mailcow server.

    .DESCRIPTION
        Creates a relay host (sender-dependent transport) configuration on the mailcow server.

        Define sender-dependent transports which can be set in a domains configuration.
        The transport service is always "smtp:" and will therefore try TLS when offered. Wrapped TLS (SMTPS) is not supported.
        A users individual outbound TLS policy setting is taken into account.
        Affects selected domains including alias domains.

    .PARAMETER Hostname
        The hostname of the relay host

    .PARAMETER Port
        The port to use. Defaults to port 25.

    .PARAMETER Username
        The username for the login on the relay host.

    .PARAMETER Password
        The password for the login on the relay host.

    .PARAMETER Enable
        Enable or disable the relay host.

    .EXAMPLE
        New-MHRoutingRelayHost -Hostname "mail.example.com" -Username "user123@example.com"

        Add relay host "mail.example.com" with username "User123". The password will be requested interactivly.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-RoutingRelayHost.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The hostname of the relay host")]
        [System.String[]]
        $Hostname,

        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "The port to use. Defaults to port 25.")]
        [ValidateRange(1, 65535)]
        [System.Int32]
        $Port = 25,

        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The username for the login on the relay host.")]
        [System.String]
        $Username,

        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The password for the login on the relay host.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "Enable or disable the relay host.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/relayhost"
    }

    process {
        foreach ($HostnameItem in $Hostname) {
            # Prepare the request body.
            $Body = @{
                hostname = $HostnameItem.Trim().ToLower() + ":" + $Port.ToString()
                username = $Username.Trim()
                password = $Password | ConvertFrom-SecureString -AsPlainText
                # By default enable the new item.
                active   = "1"
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("relay host [$($HostnameItem.Trim())].", "Add")) {
                Write-MailcowHelperLog -Message "Adding relay host [$($HostnameItem.Trim())]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}