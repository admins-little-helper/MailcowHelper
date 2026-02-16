function Get-RspamdSetting {
    <#
    .SYNOPSIS
        Returns one or more Rspamd rules.

    .DESCRIPTION
        Returns one or more Rspamd rules.

    .PARAMETER Identity
        The ID number of a specific Rspamd rule.
        If ommited, all Rspamd rules are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHRspamdSetting -Id 1

        Returns rule with id 1.

    .EXAMPLE
        Get-MHRspamdSetting

        Returns all Rsapmd rules.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-RspamdSetting.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The ID number of a specific Rspamd rule.")]
        [System.Int32[]]
        $Id,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/rsetting/"

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
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdentityItem)

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
                        Id          = $Item.id
                        Description = $Item.desc
                        Active      = [System.Boolean][System.Int32]$Item.active
                        Content     = $Item.content
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHRspamdSetting")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}