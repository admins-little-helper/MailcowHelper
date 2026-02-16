function Remove-RoutingRelayHost {
    <#
    .SYNOPSIS
        Removes one or more relay hosts configured on a mailcow server.

    .DESCRIPTION
        Removes one or more relay hosts configured on a mailcow server.

    .PARAMETER Id
        The id of a relay host entry to update.

    .EXAMPLE
        Remove-MHRoutingRelayHost -id 12

        Remove relay host entry with id 12.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-RoutingRelayHost.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Int32[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/relayhost"
    }

    process {
        foreach ($IdItem in $Id) {
            # Prepare the request body.
            $Body = $IdItem

            # Get current configuration for specified ID.
            $CurrentRelayHostConfig = Get-RoutingRelayHost -Id $IdItem

            if ($PSCmdlet.ShouldProcess("mailcow relay host [$($CurrentRelayHostConfig.hostname)].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting relay host [$($CurrentRelayHostConfig.hostname)], ID [$($CurrentRelayHostConfig.id)]." -Level Warning

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
