function Get-AppPassword {
    <#
    .SYNOPSIS
        Get application-specific password settings for a mailbox.

    .DESCRIPTION
        Get application-specific password settings for a mailbox.
        Passwords can not be returned in plain text.

    .PARAMETER Identity
        The mail address of the mailbox for which to get the app password setting for.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHAppPassword -Identity user@example.com

        Returns all app passwords for mailbox user@example.com.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AppPassword.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to get the app password for.")]
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
        $UriPath = "get/app-passwd/all/"
    }

    process {
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
                    $ConvertedItem = [PSCustomObject]@{
                        ID           = $Item.id
                        Name         = $Item.name
                        Mailbox      = $Item.mailbox
                        Domain       = $Item.domain
                        Password     = "***"
                        IMAP         = [System.Boolean][System.Int32]$Item.imap_access
                        SMTP         = [System.Boolean][System.Int32]$Item.smtp_access
                        DAV          = [System.Boolean][System.Int32]$Item.dav_access
                        EAS          = [System.Boolean][System.Int32]$Item.eas_access
                        POP3         = [System.Boolean][System.Int32]$Item.pop3_access
                        Sieve        = [System.Boolean][System.Int32]$Item.sieve_access
                        Active       = [System.Boolean][System.Int32]$Item.active
                        WhenCreated  = if ($Item.created) { (Get-Date -Date $Item.created) }
                        WhenModified = if ($Item.modified) { (Get-Date -Date $Item.modified) }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHAppPassword")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}
