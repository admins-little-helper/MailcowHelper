function Remove-ForwardingHost {
    <#
    .SYNOPSIS
        Delete one or more forwarding host from the mailcow configuration.

    .DESCRIPTION
        Delete one or more forwarding host from the mailcow configuration.

    .PARAMETER Hostname
        The hostname of the forwarding host to delete.

    .PARAMETER IpAddress
        IP address of a forwarding host to delete.

    .EXAMPLE
        Remove-MHForwardingHost -Hostname mail.example.com

        This will delete all entries found for the forwarding host mail.example.com.

    .EXAMPLE
        Remove-MHForwardingHost IpAddress 1.2.3.4

        This will delete the forwarding host with ip address 1.2.3.4.

    .INPUTS
        System.String[]
        System.Net.IPNetwork[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-ForwardingHost.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = "Hostname", SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(ParameterSetName = "Hostname", Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The Hostname of the forwarding host to delete.")]
        [System.String[]]
        $Hostname,

        [Parameter(ParameterSetName = "IpAddress", Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "IP address of a forwarding host to delete.")]
        [System.Net.IPNetwork[]]
        $IpAddress
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/fwdhost"
    }

    process {
        if ($PSBoundParameters.ContainsKey("Hostname")) {
            # Get the ip addresses associated with the specified hostname(s).
            $ForwardingHosts = Get-ForwardingHost | Where-Object { $Hostname -contains $_.source }
            $IpOrHostname = $ForwardingHosts.host
        }
        elseif ($PSBoundParameters.ContainsKey("IpAddress")) {
            # Get the IP address(es) as string value.
            $IpOrHostname = foreach ($Item in $IpAddress) { $Item.ToString() }
        }
        else {
            # Should never reach this point.
            Write-MailcowHelperLog -Message "Invalid option!" -Level Error
        }

        # Prepare the request body.
        $Body = $IpOrHostname

        if ($PSCmdlet.ShouldProcess("forwarding host [$($IpOrHostname -join ",")].", "Delete")) {
            Write-MailcowHelperLog -Message "Deleting forwarding host [$($IpOrHostname -join ",")]." -Level Warning

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
