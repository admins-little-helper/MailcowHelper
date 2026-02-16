function Remove-AddressRewriteBccMap {
    <#
    .SYNOPSIS
        Removes a BCC map.

    .DESCRIPTION
        Removes a BCC map.
        BCC maps are used to silently forward copies of all messages to another address.
        A recipient map type entry is used, when the local destination acts as recipient of a mail. Sender maps conform to the same principle.
        The local destination will not be informed about a failed delivery.

    .PARAMETER Id
        Id number of BCC map to remove.

    .EXAMPLE
        Remove-MHAddressRewriteBccMap -Id 1

        Removes BCC map with ID 1.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-AddressRewriteBccMap.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Id number of BCC map to remove.")]
        [Alias("BccMapId")]
        [System.Int32[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/bcc"
    }

    process {
        foreach ($IdItem in $Id) {
            # Prepare the request body.
            $Body = $IdItem.ToString()

            # Get BCC map information for logging.
            $CurrentBccMapConfig = Get-AddressRewriteBccMap -Id $IdItem

            if ($PSCmdlet.ShouldProcess("BCC map [$($CurrentBccMapConfig.id)]", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting rule ID [$($CurrentBccMapConfig.id)], Address: [$($CurrentBccMapConfig.local_dest)], BCC destionation to [$($CurrentBccMapConfig.bcc_dest)], map type [$($CurrentBccMapConfig.type)]." -Level Warning

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
