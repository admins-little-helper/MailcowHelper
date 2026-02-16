function Remove-DomainAntiSpamPolicy {
    <#
    .SYNOPSIS
        Remove one ore more blacklist or whitelist policies.

    .DESCRIPTION
        Remove one ore more blacklist or whitelist policies.

    .PARAMETER Id
        The id of the policy to remove.

    .EXAMPLE
        Remove-MHDomainAntiSpamPolicy -Id 17

        Removes policy with id 17.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-DomainAntiSpamPolicy.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The id of the policy to remove.")]
        [System.Int32[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/domain-policy/"
    }

    process {
        # Prepare the request body.
        $Body = $Id

        if ($PSCmdlet.ShouldProcess("AntiSpam policy [$($Id -join ", ")]", "Delete")) {
            Write-MailcowHelperLog -Message "Deleting AntiSpam policy [$($Id -join ", ")]." -Level Warning
            # Execute the API call.
            $InvokeMailcowHelperRequestParams = @{
                UriPath = $UriPath
                Method  = "Post"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowHelperRequestParams

            # Return the result.
            $Result
        }
    }
}
