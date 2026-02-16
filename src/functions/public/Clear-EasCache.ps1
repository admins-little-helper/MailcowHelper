function Clear-EasCache {
    <#
    .SYNOPSIS
        Clear the EAS (Exchange Active Sync) cache for one or more mailboxes.

    .DESCRIPTION
        Clear the EAS (Exchange Active Sync) cache for one or more mailboxes.

    .PARAMETER Identity
        The mail address of the mailbox for which to clear the EAS cache.

    .EXAMPLE
        Clear-MHEasCache -Identity "user1@example.com"

        Clears the EAS cache for "user1@example.com".

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Clear-EasCache.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to clear the EAS cache.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/eas_cache"
    }

    process {
        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = $IdentityItem.Address

            if ($PSCmdlet.ShouldProcess("mailcow EAS cache for [$($IdentityItem.Address)]", "Clear")) {
                Write-MailcowHelperLog -Message "[$($IdentityItem.Address)] Clearing EAS cache for mailbox" -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $RequestUriPath
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