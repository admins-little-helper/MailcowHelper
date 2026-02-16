function New-RoutingTransport {
    <#
    .SYNOPSIS
        Create a transport map configuration.

    .DESCRIPTION
        Create a transport map configuration.
        A transport map entry overrules a sender-dependent transport map (RoutingRelayHost).
s
    .PARAMETER Destination
        The destination domain. Accepts regex.

    .PARAMETER Hostname
        The hostname for the next hop to the destination.

    .PARAMETER Port
        The port to use. Defaults to port 25.

    .PARAMETER Username
        The username for the login on the routing server.

    .PARAMETER Password
        The password for the destination server.

    .PARAMETER IsMxBased
        Enable or disable MX lookup for the transport rule.

    .PARAMETER Enable
        Enable or disable the transport rule.

    .EXAMPLE
        New-MHRoutingTransport -Domain "example.com" -Hostname "next.hop.to.example.mail" -Username "user123"

        Creates a transport rule for domain "example.com" using "next.hop.to.example.mail" as next hop. The password for the specified user will be requested interactivly on execution.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-RoutingTransport.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The destination domain. Accepts regex.")]
        [System.String[]]
        $Destination,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The hostname for the next hop to the destination.")]
        [System.String]
        $Hostname,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The port to use. Defaults to port 25.")]
        [ValidateRange(1, 65535)]
        [System.Int32]
        $Port = 25,

        [Parameter(Position = 3, Mandatory = $true, HelpMessage = "The username for the login on the routing server.")]
        [System.String]
        $Username,

        [Parameter(Position = 4, Mandatory = $true, HelpMessage = "The password for the login on the destination server.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "Enable or disable MX lookup for the transport rule.")]
        [System.Management.Automation.SwitchParameter]
        $IsMxBased,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "Enable or disable the transport rule.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/transport"
    }

    process {
        foreach ($DestinationItem in $Destination) {
            # Prepare the request body.
            $Body = @{
                destination = $DestinationItem.Trim().ToLower()
                nexthop     = $Hostname.Trim().ToLower() + ":" + $Port.ToString()
                username    = $Username.Trim()
                password    = $Password | ConvertFrom-SecureString -AsPlainText
                # By default enable the new item.
                active      = "1"
                # By default disable mx lookup.
                is_mx_based = "0"
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("IsMxBased")) {
                $Body.is_mx_based = if ($IsMxBased.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("mail transport", "add item")) {
                Write-MailcowHelperLog -Message "Adding mail transport for destination [$($DestinationItem.Trim())] with next hop [$($Hostname.Trim())]." -Level Information

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