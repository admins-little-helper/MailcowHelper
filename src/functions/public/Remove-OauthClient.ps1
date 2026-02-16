function Remove-OauthClient {
    <#
    .SYNOPSIS
        Remove one or more OAuth client configurations.

    .DESCRIPTION
        Remove one or more OAuth client configurations.

    .PARAMETER Id
        The id value of a specific OAuth client.

    .EXAMPLE
        Remove-MHOauthClient -Id 12

        Removes OAuth client configuration with id 12.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-OauthClient.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The id value of a specific OAuth client.")]
        [System.Int32[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/oauth2-client"
    }

    process {
        foreach ($IdItem in $Id) {
            # Prepare the request body.
            $Body = $IdItem

            if ($PSCmdlet.ShouldProcess("Oauth client [$IdItem].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting Oauth client [$IdItem]." -Level Warning

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
