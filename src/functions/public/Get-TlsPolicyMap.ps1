function Get-TlsPolicyMap {
    <#
    .SYNOPSIS
        Return TLS policy map override map.

    .DESCRIPTION
        Return TLS policy map override map.

    .PARAMETER Identity
        The ID of a specific policy map.
        If ommited, all tls policy maps are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHTlsPolicyMap

        Returns all TLS policy map override maps.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-TlsPolicyMap.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The ID of a specific policy map.")]
        [System.Int32[]]
        $Id,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/tls-policy-map/"

        # If no specific id was given, use the keyword "all" to return all.
        if ($null -eq $Id) {
            $Identity = "all"
        }
        else {
            $Identity = $Id
        }
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Build full Uri.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdentityItem.ToLower())

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
                        ID           = $Item.id
                        Destination  = $Item.dest
                        Policy       = $Item.policy
                        Parameters   = $Item.parameters
                        Active       = [System.Boolean][System.Int32]$Item.active
                        WhenCreated  = if ($Item.created) { (Get-Date -Date $Item.created) }
                        WhenModified = if ($Item.modified) { (Get-Date -Date $Item.modified) }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHTlsPolicyMap")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}
