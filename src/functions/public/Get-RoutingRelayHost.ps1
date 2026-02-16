function Get-RoutingRelayHost {
    <#
    .SYNOPSIS
        Returns information about the relay hosts configured in a mailcow.

    .DESCRIPTION
        Returns information about the relay hosts configured in a mailcow.

    .PARAMETER Identity
        The ID number of a specific relay host record, or the keyword "All".
        If ommited, all configured relay hosts are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHRoutingRelayHost

        Returns information for all relay hosts configured on a mailcow server.

    .EXAMPLE
        Get-MHRoutingRelayHost -Identity 1

        Returns information for relay host with ID 1.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-RoutingRelayHost.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The ID number of a specific relay host record.")]
        [System.Int32[]]
        $Id,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/relayhost/"

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
                        ID              = $Item.id
                        Hostname        = $Item.hostname
                        Active          = [System.Boolean][System.Int32]$Item.active
                        Username        = $Item.username
                        Password        = if ($Item.password) { $Item.password | ConvertTo-SecureString -AsPlainText }
                        UsedByDomains   = $Item.used_by_domains
                        UsedByMailboxes = $Item.used_by_mailboxes
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHRoutingRelayHost")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}
