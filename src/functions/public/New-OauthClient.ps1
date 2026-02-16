function New-OauthClient {
    <#
    .SYNOPSIS
        Add an OAuth client to the mailcow server.

    .DESCRIPTION
        Add an OAuth client to the mailcow server.

    .PARAMETER RedirectUri
        The redirect URI for the new OAuth client.

    .EXAMPLE
        New-MHOauthClient -RedirectUri "https://localhost:12345"

        Creates a new OAuth client with the specified redirect URI.

    .INPUTS
        System.Uri[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-OauthClient.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, Helpmessage = "The redirect URI for the new OAuth client.")]
        [System.Uri[]]
        $RedirectUri
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/oauth2-client"
    }

    process {
        foreach ($RedirectUriItem in $RedirectUri) {
            # Prepare the request body.
            $Body = @{
                redirect_uri = $RedirectUriItem.AbsoluteUri
            }

            if ($PSCmdlet.ShouldProcess("Oauth client [$($RedirectUriItem.AbsoluteUri)].", "Add")) {
                Write-MailcowHelperLog -Message "Adding Oauth client [$($RedirectUriItem.AbsoluteUri)]." -Level Information

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