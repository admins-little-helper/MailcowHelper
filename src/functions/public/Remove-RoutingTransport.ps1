function Remove-RoutingTransport {
    <#
    .SYNOPSIS
        Removes one or more transport map configurations.

    .DESCRIPTION
        Removes one or more transport map configurations.

    .PARAMETER Id
        The ID number of a specific transport map record.

    .EXAMPLE
        Remove-MHRoutingTransport -Id 7

        Removes transport rule with id 7.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-RoutingTransport.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The ID number of a specific transport map record.")]
        [System.Int32[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/transport"
    }

    process {
        foreach ($IdItem in $Id) {
            # Prepare the request body.
            $Body = $IdItem

            # Get current configuration for specified ID.
            $CurrentTransportConfig = Get-RoutingTransport -Identity $IdItem

            if ($PSCmdlet.ShouldProcess("mail transport [$($CurrentTransportConfig.hostname)].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting mailcow mail transport [$($CurrentTransportConfig.hostname)], ID [$($CurrentTransportConfig.id)]." -Level Warning

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
