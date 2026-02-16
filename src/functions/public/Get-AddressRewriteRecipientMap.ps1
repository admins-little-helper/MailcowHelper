function Get-AddressRewriteRecipientMap {
    <#
    .SYNOPSIS
        Get one or more recipient map definitions.

    .DESCRIPTION
        Get one or more recipient map definitions.
        Recipient maps are used to replace the destination address on a message before it is delivered.

    .PARAMETER Id
        Id number of recipient map to get information for.
        If omitted, all recipient map definitions are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHAddressRewriteRecipientMap

        Returns all recipient maps.

    .EXAMPLE
        Get-MHAddressRewriteRecipientMap -Identity 15

        Returns recipient map with id 15.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AddressRewriteRecipientMap.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "Id number of recipient map to get information for.")]
        [System.String[]]
        $Id = "All",

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/recipient_map/"
    }

    process {
        foreach ($IdItem in $Id) {
            # Build full Uri.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdItem.ToLower())

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        ID              = $Item.id
                        RecipientMapOld = $Item.recipient_map_old
                        RecipientMapNew = $Item.recipient_map_new
                        Active          = [System.Boolean][System.Int32]$Item.active
                        WhenCreated     = if ($Item.created) { (Get-Date -Date $Item.created) }
                        WhenModified    = if ($Item.modified) { (Get-Date -Date $Item.modified) }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHAddressRewriteRecipientMap")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}
