function Get-SieveFilter {
    <#
    .SYNOPSIS
        Returns admin defined Sieve filters for one or more user mailboxes.

    .DESCRIPTION
        Returns admin defined Sieve filters for user mailboxes.
        Note that this will NOT return sieve filter scripts that a user has created on his/her own in SOGo,
        like out-of-office/vacation auto-reply or for example filter scripts to move incoming mails to folders.

    .PARAMETER Identity
        The mail address of the mailbox for which to return the Sieve script(s).
        If ommited, Sieve scripts for all mailboxes are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHSieveFilter -Identity "user1@example.com"

        Returns Sieve scripts for the mailbox of "user1@example.com"

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-SieveFilter.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "Mail address of mailbox to get information for.")]
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
        $UriPath = "get/filters/all"
    }

    process {
        # Execute the API call.
        $ResultAll = Invoke-MailcowApiRequest -UriPath $UriPath

        if ([System.String]::IsNullOrEmpty($Identity)) {
            # Return all results.
            $Result = $ResultAll
        }
        else {
            # Filter the result by the specied mail address(es).
            $MailAddresses = foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
            $Result = $ResultAll | Where-Object { $MailAddresses -eq $_.username }
        }

        # Return result.
        if ($Raw.IsPresent) {
            # Return the result in raw format.
            $Result
        }
        else {
            # Prepare the result in a custom format.
            $ConvertedResult = foreach ($Item in $Result) {
                $ConvertedItem = [PSCustomObject]@{
                    ID         = $Item.id
                    Username   = $Item.username
                    Active     = [System.Boolean][System.Int32]$Item.active
                    FilterType = $Item.filter_type
                    ScriptDesc = $Item.script_desc
                    ScriptData = $Item.script_data
                }
                $ConvertedItem.PSObject.TypeNames.Insert(0, "MHSieveFilter")
                $ConvertedItem
            }
            # Return the result in custom format.
            $ConvertedResult
        }
    }
}
