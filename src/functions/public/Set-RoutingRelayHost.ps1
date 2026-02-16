function Set-RoutingRelayHost {
    <#
    .SYNOPSIS
        Updates one or more relay host configurations.

    .DESCRIPTION
        Updates one or more relay host configurations.

    .PARAMETER Id
        The id of a relay host entry to update.

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
        Set-MHRoutingRelayHost -Hostname "mail.example.com" -Username "user123@example.com"

        Update relay host with id 7 with hostname "mail.example.com" and username "User123".

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-RoutingRelayHost.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The id of a relay host entry to update.")]
        [System.Int32[]]
        $Id,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The hostname of the relay host")]
        [System.String[]]
        $Hostname,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The port to use. Defaults to port 25.")]
        [ValidateRange(1, 65535)]
        [System.Int32]
        $Port = 25,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The username for the login on the relay host.")]
        [System.String]
        $Username,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "The password for the login on the relay host.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "Enable or disable the relay host.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/relayhost"
    }

    process {
        # Prepare the request body.
        $Body = @{
            items = $Id
            attr  = @{}
        }
        if ($PSBoundParameters.ContainsKey("Hostname")) {
            $Body.attr.hostname = $Hostname.Trim().ToLower()
        }
        if ($PSBoundParameters.ContainsKey("Port")) {
            $Body.attr.port = $Port.ToString()
        }
        if ($PSBoundParameters.ContainsKey("Username")) {
            $Body.attr.username = $Username.Trim()
        }
        if ($PSBoundParameters.ContainsKey("Password")) {
            $Body.attr.password = $Password | ConvertFrom-SecureString -AsPlainText
        }
        if ($PSBoundParameters.ContainsKey("Enable")) {
            $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("relay host id [$($Id -join ",")].", "Update")) {
            Write-MailcowHelperLog -Message "Updating relay host id [$($Id -join ",")]." -Level Information

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