function Get-MailboxTemplate {
    <#
    .SYNOPSIS
        Get information about mailbox templates.

    .DESCRIPTION
        Get information about mailbox templates.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHMailboxTemplate

        Return all mailbox templates.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailboxTemplate.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    # Build full Uri.
    $UriPath = "get/mailbox/template"

    # Execute the API call.
    $Result = Invoke-MailcowApiRequest -UriPath $UriPath

    # Return result.
    if ($Raw.IsPresent) {
        # Return the result in raw format.
        $Result
    }
    else {
        # Prepare the result in a custom format.
        $ConvertedResult = foreach ($Item in $Result) {
            # Get the rate limit and show it in a nicer way.
            if ($Item.rl.value) {
                $RateLimit = "$($Item.attributes.rl.value) msgs/$($Item.attributes.rl.frame)"
            }
            else {
                $RateLimit = "Unlimited"
            }

            $ConvertedItem = [PSCustomObject]@{
                Id                       = $Item.id
                Name                     = $Item.template
                Type                     = $Item.type
                # Attributes   = $Item.attributes
                ForcePasswordUpdate      = [System.Boolean][System.Int32]$Item.attributes.force_pw_update
                EnforceTlsIn             = [System.Boolean][System.Int32]$Item.attributes.tls_enforce_in
                EnforceTlsOut            = [System.Boolean][System.Int32]$Item.attributes.tls_enforce_out
                SOGoAccess               = [System.Boolean][System.Int32]$Item.attributes.sogo_access
                ImapAccess               = [System.Boolean][System.Int32]$Item.attributes.imap_access
                Pop3Access               = [System.Boolean][System.Int32]$Item.attributes.pop3_access
                SmtpAccess               = [System.Boolean][System.Int32]$Item.attributes.smtp_access
                SieveAccess              = [System.Boolean][System.Int32]$Item.attributes.sieve_access
                EasAccess                = [System.Boolean][System.Int32]$Item.attributes.eas_access
                DavAccess                = [System.Boolean][System.Int32]$Item.attributes.dav_access
                QuarantineNotification   = $Item.attributes.quarantine_notification
                QuarantineCategory       = $Item.attributes.quarantine_category
                MailboxQuota             = $Item.attributes.quota
                Tags                     = $Item.attributes.tags
                TaggedMailHandler        = $Item.attributes.tagged_mail_handler
                RateLimit                = $RateLimit
                Active                   = $Item.attributes.active
                AclSpamAlias             = $Item.attributes.acl_spam_alias
                AclTlsPolicy             = $Item.attributes.acl_tls_policy
                AclSpamScore             = $Item.attributes.acl_spam_score
                AclSpamPolicy            = $Item.attributes.acl_spam_policy
                AclDelimiterAction       = $Item.attributes.acl_delimiter_action
                AclSyncJobs              = $Item.attributes.acl_syncjobs
                AclEasReset              = $Item.attributes.acl_eas_reset
                AclSogoProfileReset      = $Item.attributes.acl_sogo_profile_reset
                AclPushover              = $Item.attributes.acl_pushover
                AclQuarantine            = $Item.attributes.acl_quarantine
                AclQuarantineAttachments = $Item.attributes.acl_quarantine_attachments
                AclQuarantineNotfication = $Item.attributes.acl_quarantine_notification
                AclQuarantineCategory    = $Item.attributes.acl_quarantine_category
                AclAppPasswords          = $Item.attributes.acl_app_passwds
                AclPasswordReset         = $Item.attributes.acl_pw_reset
                WhenCreated              = if ($Item.created) { (Get-Date -Date $Item.created) }
                WhenModified             = if ($Item.modified) { (Get-Date -Date $Item.modified) }
            }
            $ConvertedItem.PSObject.TypeNames.Insert(0, "MHMailboxTemplate")
            $ConvertedItem
        }
        # Return the result in custom format.
        $ConvertedResult
    }
}