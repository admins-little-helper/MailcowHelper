function Get-OauthClient {
    <#
    .SYNOPSIS
        Return OAuth client configuration.

    .DESCRIPTION
        Return OAuth client configuration.

    .PARAMETER Id
        The id value of a specific OAuth client.
        If omitted, all OAuth client configurations are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHOauthClient

        Returns all OAuth client configurations.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-OauthClient.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The id value of a specific OAuth client.")]
        [System.Int32[]]
        $Id,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/oauth2-client/"

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
                        ID           = $Item.id
                        ClientId     = $Item.client_id
                        ClientSecret = $Item.client_secret
                        GrantTypes   = $Item.grant_types
                        RedirectUri  = $Item.redirect_uri
                        Scope        = $Item.scope
                        UserId       = $Item.user_id
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHOauthClient")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}
