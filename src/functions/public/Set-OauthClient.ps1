function Set-OauthClient {
    <#
    .SYNOPSIS
        Updates an OAuth client configuration on the mailcow server.

    .DESCRIPTION
        Updates an OAuth client configuration on the mailcow server.

    .PARAMETER Id
        The id value of a specific OAuth client.

    .PARAMETER RedirectUri
        The redirect URI for the OAuth client.

    .PARAMETER RenewSecret
        Renew client secret.

    .EXAMPLE
        Set-MHOauthClient -Id 12 RenewSecret

        Renews the client secret for OAuth client configuration with id 12.

    .INPUTS
        System.Int32

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-OauthClient.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The id value of a specific OAuth client.")]
        [System.Int32]
        $Id,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The redirect URI for new OAuth client.")]
        [System.Uri]
        $RedirectUri,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Renew client secret.")]
        [System.Management.Automation.SwitchParameter]
        $RenewSecret
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/oauth2-client"
    }

    process {
        # Prepare the request body.
        $Body = @{
            # Assign all mail addresses to the "items" attribute.
            items = $Id
            attr  = @{
                redirect_uri = $RedirectUri.AbsoluteUri
            }
        }
        if ($PSBoundParameters.ContainsKey("RenewSecret")) {
            if ($RenewSecret.IsPresent) {
                $Body.attr.renew_secret = $true
            }
        }

        if ($PSCmdlet.ShouldProcess("mailcow mail Oauth client [$Id].", "Update")) {
            Write-MailcowHelperLog -Message "Updating Oauth client with id [$Id]." -Level Information

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
