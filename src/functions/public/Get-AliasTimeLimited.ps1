function Get-AliasTimeLimited {
    <#
    .SYNOPSIS
        Get information about all time-limited aliases (spam-alias) defined for a mailbox.

    .DESCRIPTION
        Get information about all time-limited aliases (spam-alias) defined for a mailbox.

    .PARAMETER Identity
        The mail address of the mailbox for which to get the time-limited alias(es).
        If omitted, all time-limited aliases for all mailboxes are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHAliasTimeLimited

        Returns time-limited aliases for all mailboxes.

    .EXAMPLE
        Get-MHAliasTimeLimited -Identity user@example.com

        Returns time-limited alias(es) for the mailbox user@example.com.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AliasTimeLimited.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to get the time-limited alias(es).")]
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
        $UriPath = "get/time_limited_aliases/"
    }

    process {
        if ([System.String]::IsNullOrEmpty($Identity)) {
            # Get all mailboxes.
            $Identity = (Get-Mailbox).username
        }

        # Loop through each specified mailbox.
        foreach ($IdentityItem in $Identity) {
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
                    if ($Item.Address) {
                        $ConvertedItem = [PSCustomObject]@{
                            Mailbox      = $IdentityItem.Address
                            Address      = $Item.address
                            Goto         = $Item.goto
                            Description  = $Item.description
                            Permanent    = [System.Boolean][System.Int32]$Item.permanent
                            Validity     = if ($Item.validity -ne 0) {
                                # The value for Validity is returned as Unix time (number of second since 1970).
                                # Convert it to DateTime value and add any offset to the local time zone.
                                $DateTimeUTC = $((Get-Date -Date "1970-01-01T00:00:00") + ([System.TimeSpan]::FromSeconds($Item.validity)))
                                $DateTimeUTC.ToLocalTime()
                            }
                            WhenCreated  = if ($Item.created) { (Get-Date -Date $Item.created) }
                            WhenModified = if ($Item.modified) { (Get-Date -Date $Item.modified) }
                        }
                        $ConvertedItem.PSObject.TypeNames.Insert(0, "MHAliasTimeLimited")
                        $ConvertedItem
                    }
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}