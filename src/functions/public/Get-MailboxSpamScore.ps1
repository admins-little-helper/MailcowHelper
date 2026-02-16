function Get-MailboxSpamScore {
    <#
    .SYNOPSIS
        Get the spam score for one ore more mailboxes.

    .DESCRIPTION
        Get the spam score for one ore more mailboxes.

    .PARAMETER Identity
        The mail address for which to get information.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHMailboxSpamScore

        Return spam score information for all mailboxes.

    .EXAMPLE
        Get-MHMailboxSpamScore -Identity "user1@example.com"

        Return spam score information for "user1@example.com".

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailboxSpamScore.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = "Identity")]
    param(
        [Parameter(ParameterSetName = "Identity", Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The mail address for which to get information.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/spam-score/"

        if ([System.String]::IsNullOrEmpty($Identity)) {
            # If no identity was specified, get the mail address of all mailboxes.
            $Identity = (Get-Mailbox -Raw).username
        }
    }

    process {
        foreach ($IdentityItem in $Identity) {
            Write-MailcowHelperLog -Message "[$($IdentityItem.Address)] Getting spam-score for mailbox."
            # Build full Uri.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdentityItem.Address.ToLower())

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
                        Identity      = $IdentityItem.Address
                        SpamScoreLow  = if ($Item.Score) { ($Item.score -split ",")[0] }
                        SpamScoreHigh = if ($Item.Score) { ($Item.score -split ",")[1] }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHMailboxSpamScore")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}
