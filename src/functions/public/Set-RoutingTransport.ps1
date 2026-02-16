function Set-RoutingTransport {
    <#
    .SYNOPSIS
        Updates one or more transport map configurations.

    .DESCRIPTION
        Updates one or more transport map configurations.
        A transport map entry overrules a sender-dependent transport map (RoutingRelayHost).

    .PARAMETER Id
        The ID number of a specific transport map record.

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
        Set-MHRoutingTransport -Domain "example.com" -Hostname "next.hop.to.example.mail" -Username "user123"

        Creates a transport rule for domain "example.com" using "next.hop.to.example.mail" as next hop. The password for the specified user will be requested interactivly on execution.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-RoutingTransport.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The ID number of a specific transport map record.")]
        [System.Int32[]]
        $Id,

        [Parameter(Position = 1, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The destination domain. Accepts regex.")]
        [System.String]
        $Destination,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The hostname for the next hop to the destination.")]
        [System.String]
        $Hostname,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The port to use. Defaults to port 25.")]
        [ValidateRange(1, 65535)]
        [System.Int32]
        $Port = 25,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "The username for the login on the routing server.")]
        [System.String]
        $Username,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "The password the login on the destination server.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "Enable or disable MX lookup for the transport rule.")]
        [System.Management.Automation.SwitchParameter]
        $IsMxBased,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "Enable or disable the transport rule.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/transport"
    }

    process {
        foreach ($IdItem in $Id) {
            # Prepare the request body.
            $Body = @{
                items = $IdItem
                attr  = @{}
            }
            if ($PSBoundParameters.ContainsKey("Destination")) {
                $Body.attr.destination = $Destination.Trim().ToLower()
            }
            if ($PSBoundParameters.ContainsKey("Hostname")) {
                $Body.attr.nexthop = $Hostname.Trim().ToLower() + ":" + $Port.ToString()
            }
            if ($PSBoundParameters.ContainsKey("Username")) {
                $Body.attr.username = $Username.Trim()
            }
            if ($PSBoundParameters.ContainsKey("Password")) {
                $Body.attr.password = $Password | ConvertFrom-SecureString -AsPlainText
            }
            if ($PSBoundParameters.ContainsKey("IsMxBased")) {
                $Body.attr.is_mx_based = if ($IsMxBased.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("mail transport id [$IdItem].", "Update")) {
                Write-MailcowHelperLog -Message "Updating mail transport id [$IdItem]." -Level Information

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