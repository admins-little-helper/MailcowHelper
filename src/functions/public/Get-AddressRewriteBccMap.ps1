function Get-AddressRewriteBccMap {
    <#
    .SYNOPSIS
        Get one or more BCC map definitions.

    .DESCRIPTION
        Get one or more BCC map definitions.
        BCC maps are used to silently forward copies of all messages to another address.
        A recipient map type entry is used, when the local destination acts as recipient of a mail. Sender maps conform to the same principle.
        The local destination will not be informed about a failed delivery.

    .PARAMETER Id
        Id number of BCC map to get information for.
        If omitted, all BCC map definitions are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHAddressRewriteBccMap

        Return all BCC maps.

    .EXAMPLE
        Get-MHAddressRewriteBccMap -Identity 15

        Returns BCC map with id 15.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AddressRewriteBccMap.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "Id number of BCC map to get information for.")]
        [System.String[]]
        $Id = "All",

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/bcc/"
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
                        ID               = $Item.id
                        LocalDestination = $Item.local_dest
                        BccDestination   = $Item.bcc_dest
                        Active           = [System.Boolean][System.Int32]$Item.active
                        Type             = if ($Item.Type) { (Get-Culture).TextInfo.ToTitleCase($Item.type) }
                        Domain           = $Item.domain
                        WhenCreated      = if ($Item.created) { (Get-Date -Date $Item.created) }
                        WhenModified     = if ($Item.modified) { (Get-Date -Date $Item.modified) }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHAddressRewriteBccMap")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}
