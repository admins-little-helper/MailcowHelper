function Remove-AddressRewriteRecipientMap {
    <#
    .SYNOPSIS
        Remove a recipient map.

    .DESCRIPTION
        Remove a recipient map.
        Recipient maps are used to replace the destination address on a message before it is delivered.

    .PARAMETER Id
        Id number of recipient map to remove.

    .EXAMPLE
        Remove-MHAddressRewriteRecipientMap -Id 15

        Removes recipient map with id 15.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-AddressRewriteRecipientMap.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Id number of recipient map to remove.")]
        [System.Int32[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/recipient_map"
    }

    process {
        foreach ($IdItem in $Id) {
            # Prepare the request body.
            $Body = $IdItem.ToString()

            # Get BCC map configuration for logging.
            $CurrentBccMapConfig = Get-AddressRewriteRecipientMap -Identity $IdItem

            if ($PSCmdlet.ShouldProcess("BCC map [$($CurrentBccMapConfig.id)]", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting rule ID [$($CurrentBccMapConfig.id)], TargetAddress: [$($CurrentBccMapConfig.recipient_map_old)], redirected to [$($CurrentBccMapConfig.recipient_map_new)]." -Level Warning

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