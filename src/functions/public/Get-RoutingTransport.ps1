function Get-RoutingTransport {
    <#
    .SYNOPSIS
        Return transport map configuration.

    .DESCRIPTION
        Return transport map configuration.
        A transport map entry overrules a sender-dependent transport map (RoutingRelayHost).

    .PARAMETER Id
        The ID number of a specific transport map record.
        If ommited, all configured transport map records are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHRoutingTransport

        Returns all transport map configurations.

    .EXAMPLE
        Get-MHRoutingTransport -Identity 7

        Returns transport map configuration for transport map with ID 7.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-RoutingTransport.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The ID number of a specific transport map record.")]
        [System.Int32[]]
        $Id,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/transport/"

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
                        ID          = $Item.id
                        Destination = $Item.destination
                        Active      = [System.Boolean][System.Int32]$Item.active
                        IsMxBased   = [System.Boolean][System.Int32]$Item.is_mx_based
                        Nexthop     = $Item.nexthop
                        Username    = $Item.username
                        Password    = if ($Item.password) { $Item.password | ConvertTo-SecureString -AsPlainText }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHRoutingTransport")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}
