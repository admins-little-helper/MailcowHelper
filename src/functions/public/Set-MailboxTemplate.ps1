function Set-MailboxTemplate {
    <#
    .SYNOPSIS
        Updates one or more mailbox templates.

    .DESCRIPTION
        Updates one or more mailbox templates.
        A mailbox template can either be specified as a default template for a domain.
        Or you can select a template when creating a new mailbox to inherit some properties.

    .PARAMETER Name
        The name of the mailbox template.

    .PARAMETER MailboxQuota
        The mailbox quota limit in MiB.

    .PARAMETER Tag
        One or more tags to will be assigned to a mailbox.

    .PARAMETER TaggedMailHandler
        The action to execute for tagged mail.

    .PARAMETER QuaranantineNotification
        The notification interval.

    .PARAMETER QuaranantineCategory
        The notification category. 'Rejected' includes mail that was rejected, while 'Junk folder' will notify a user about mails that were put into the junk folder.

    .PARAMETER RateLimitValue
        The rate limit value.

    .PARAMETER RateLimitFrame
        The rate limit unit.

    .PARAMETER ActiveState
        The mailbox state. Valid values are 'Active', 'Inactive', 'DisallowLogin'.

    .PARAMETER ForcePasswordUpdate
        Force a password change for the user on the next logon.

    .PARAMETER EnforceTlsIn
        Enforce TLS for incoming connections for this mailbox.

    .PARAMETER EnforceTlsOut
        Enforce TLS for outgoing connections from this mailbox.

    .PARAMETER SogoAccess
        Enable or disable access to SOGo for the user.

    .PARAMETER ImapAccess
        Enable or disable IMAP for the user.

    .PARAMETER Pop3Access
        Enable or disable POP3 for the user.

    .PARAMETER SmtpAccess
        Enable or disable SMTP for the user.

    .PARAMETER SieveAccess
        Enable or disable Sieve for the user.

    .PARAMETER EasAccess
        Enable or disable Exchange Active Sync for the user.

    .PARAMETER DavAccess
        Enable or disable CalDAV/CardDav for the user.

    .PARAMETER AclManageAppPassword
        Allow to manage app passwords.

    .PARAMETER AclDelimiterAction
        Allow Delimiter Action.

    .PARAMETER AclResetEasDevice
        Allow to reset EAS device.

    .PARAMETER AclPushover
        Allow Pushover.

    .PARAMETER AclQuarantineAction
        Allow quarantine action.

    .PARAMETER AclQuarantineAttachment
        Allow quarantine attachement.

    .PARAMETER AclQuarantineNotification
        Allow to change quarantine notification.

    .PARAMETER AclQuarantineNotificationCategory
        Allow to change quarantine notification category.

    .PARAMETER AclSOGoProfileReset
        Allow to reset the SOGo profile.

    .PARAMETER AclTemporaryAlias
        Allow to manage temporary alias.

    .PARAMETER AclSpamPolicy
        Allow to manage SPAM policy.

    .PARAMETER AclSpamScore
        Allow to manage SPAM score.

    .PARAMETER AclSyncJob
        Allow to manage sync job.

    .PARAMETER AclTlsPolicy
        Allow to manage TLS policy.

    .PARAMETER AclPasswordReset
        Allow to reset the user password.

    .EXAMPLE
        Set-MHMailboxTemplate -Name "ExampleTemplate"

        This creates a new mailbox template using default values for all parameters.

    .EXAMPLE
        Set-MHMailboxTemplate -Name "ExampleTemplate" -MailboxQuota 10240 -RateLimitValue 5 -RateLimitFrame Minute

        This creates a new mailbox template allowing a maximum of 10 GByte per mailbox and allowing maximum of 5 mails per minute.

    .INPUTS
        System.Int64[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxTemplate.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The ID value of the mailbox template to update.")]
        [System.Int64[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The new name of the mailbox template.")]
        [System.Int64]
        $Name,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The mailbox quota limit in MiB.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MailboxQuota,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "One or more tags to will be assigned to a mailbox.")]
        [System.String[]]
        $Tag,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The action to execute for tagged mail.")]
        [ValidateSet("Subject", "Subfolder", "Nothing")]
        [System.String]
        $TaggedMailHandler,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "The notification interval.")]
        [ValidateSet("Never", "Hourly", "Daily", "Weekly")]
        [System.String]
        $QuaranantineNotification,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "The notification category. 'Rejected' includes mail that was rejected, while 'Junk folder' will notify a user about mails that were put into the junk folder.")]
        [ValidateSet("Rejected", "Junk folder", "All categories")]
        [System.String]
        $QuaranantineCategory,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "The rate limit value.")]
        # 0 = disable rate limit
        [ValidateRange(0, 9223372036854775807)]
        [System.Int32]
        $RateLimitValue,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "The rate limit unit.")]
        [ValidateSet("Second", "Minute", "Hour", "Day")]
        [System.String]
        $RateLimitFrame,

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "The mailbox state. Valid values are 'Active', 'Inactive', 'DisallowLogin'.")]
        [MailcowHelperMailboxActiveState]
        $ActiveState,

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "Force a password change for the user on the next logon.")]
        [System.Management.Automation.SwitchParameter]
        $ForcePasswordUpdate,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "Enforce TLS for incoming connections for this mailbox.")]
        [System.Management.Automation.SwitchParameter]
        $EnforceTlsIn,

        [Parameter(Position = 11, Mandatory = $false, HelpMessage = "Enforce TLS for outgoing connections from this mailbox.")]
        [System.Management.Automation.SwitchParameter]
        $EnforceTlsOut,

        [Parameter(Position = 12, Mandatory = $false, HelpMessage = "Enable or disable access to SOGo for the user.")]
        [System.Management.Automation.SwitchParameter]
        $SogoAccess,

        [Parameter(Position = 13, Mandatory = $false, HelpMessage = "Enable or disable IMAP for the user.")]
        [System.Management.Automation.SwitchParameter]
        $ImapAccess,

        [Parameter(Position = 14, Mandatory = $false, HelpMessage = "Enable or disable POP3 for the user.")]
        [System.Management.Automation.SwitchParameter]
        $Pop3Access,

        [Parameter(Position = 15, Mandatory = $false, HelpMessage = "Enable or disable SMTP for the user.")]
        [System.Management.Automation.SwitchParameter]
        $SmtpAccess,

        [Parameter(Position = 16, Mandatory = $false, HelpMessage = "Enable or disable Sieve for the user.")]
        [System.Management.Automation.SwitchParameter]
        $SieveAccess,

        [Parameter(Position = 17, Mandatory = $false, HelpMessage = "Enable or disable Exchange Active Sync.")]
        [System.Management.Automation.SwitchParameter]
        $EasAccess,

        [Parameter(Position = 18, Mandatory = $false, HelpMessage = "Enable or disable Exchange Active Sync.")]
        [System.Management.Automation.SwitchParameter]
        $DavAccess,

        [Parameter(Position = 19, Mandatory = $false, HelpMessage = "Allow to manage app passwords.")]
        [System.Management.Automation.SwitchParameter]
        $AclManageAppPassword,

        [Parameter(Position = 20, Mandatory = $false, HelpMessage = "Allow Delimiter Action.")]
        [System.Management.Automation.SwitchParameter]
        $AclDelimiterAction,

        [Parameter(Position = 21, Mandatory = $false, HelpMessage = "Allow to reset EAS device.")]
        [System.Management.Automation.SwitchParameter]
        $AclResetEasDevice,

        [Parameter(Position = 22, Mandatory = $false, HelpMessage = "Allow Pushover.")]
        [System.Management.Automation.SwitchParameter]
        $AclPushover,

        [Parameter(Position = 23, Mandatory = $false, HelpMessage = "Allow quarantine action.")]
        [System.Management.Automation.SwitchParameter]
        $AclQuarantineAction,

        [Parameter(Position = 24, Mandatory = $false, HelpMessage = "Allow quarantine attachement.")]
        [System.Management.Automation.SwitchParameter]
        $AclQuarantineAttachment,

        [Parameter(Position = 25, Mandatory = $false, HelpMessage = "Allow to change quarantine notification.")]
        [System.Management.Automation.SwitchParameter]
        $AclQuarantineNotification,

        [Parameter(Position = 26, Mandatory = $false, HelpMessage = "Allow to change quarantine notification category.")]
        [System.Management.Automation.SwitchParameter]
        $AclQuarantineNotificationCategory,

        [Parameter(Position = 27, Mandatory = $false, HelpMessage = "Allow to reset the SOGo profile.")]
        [System.Management.Automation.SwitchParameter]
        $AclSOGoProfileReset,

        [Parameter(Position = 28, Mandatory = $false, HelpMessage = "Allow to manage temporary alias.")]
        [System.Management.Automation.SwitchParameter]
        $AclTemporaryAlias,

        [Parameter(Position = 29, Mandatory = $false, HelpMessage = "Allow to manage SPAM policy.")]
        [System.Management.Automation.SwitchParameter]
        $AclSpamPolicy,

        [Parameter(Position = 30, Mandatory = $false, HelpMessage = "Allow to manage SPAM score.")]
        [System.Management.Automation.SwitchParameter]
        $AclSpamScore,

        [Parameter(Position = 31, Mandatory = $false, HelpMessage = "Allow to manage sync job.")]
        [System.Management.Automation.SwitchParameter]
        $AclSyncJob,

        [Parameter(Position = 32, Mandatory = $false, HelpMessage = "Allow to manage TLS policy.")]
        [System.Management.Automation.SwitchParameter]
        $AclTlsPolicy,

        [Parameter(Position = 33, Mandatory = $false, HelpMessage = "Allow to reset the user password.")]
        [System.Management.Automation.SwitchParameter]
        $AclPasswordReset
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/mailbox/template"
    }

    process {
        # Make an API call for each ID.
        foreach ($IdentityItem in $Identity) {
            # First get the current mailbox template settings to use as base.
            # This is needed because otherwise any option not explicitly specified, will be set to be disabled by the API.
            $CurrentConfig = Get-MailboxTemplate -Raw | Where-Object { $_.id -eq $IdentityItem }

            # Prepare the request body.
            $Body = @{
                items = $IdentityItem.ToSTring()
                attr  = @{
                    # Set current template settings as base values for the update.
                    template                = $CurrentConfig.template
                    quota                   = $CurrentConfig.attributes.quota / 1048576 # to convert bytes into MiB.
                    tags                    = $CurrentConfig.attributes.tags
                    tagged_mail_handler     = $CurrentConfig.attributes.tagged_mail_handler
                    quarantine_notification = $CurrentConfig.attributes.quarantine_notification
                    quarantine_category     = $CurrentConfig.attributes.quarantine_category
                    rl_value                = $CurrentConfig.attributes.rl_value
                    rl_frame                = $CurrentConfig.attributes.rl_frame
                    active                  = $CurrentConfig.attributes.active
                    tls_enforce_in          = $CurrentConfig.attributes.tls_enforce_in
                    tls_enforce_out         = $CurrentConfig.attributes.tls_enforce_out
                    force_pw_update         = $CurrentConfig.attributes.force_pw_update
                    sogo_access             = $CurrentConfig.attributes.sogo_access
                    protocol_access         = [System.Collections.ArrayList]@()
                    acl                     = [System.Collections.ArrayList]@()
                }
            }

            # Prepare arraylists in case needed later.
            $ProtocolAccess = [System.Collections.ArrayList]@()
            $Acl = [System.Collections.ArrayList]@()

            if ($PSBoundParameters.ContainsKey("Name")) {
                $Body.attr.template = $Name.Trim()
            }
            if ($PSBoundParameters.ContainsKey("MailboxQuota")) {
                $Body.attr.quota = $MailboxQuota.ToString()
            }
            if ($PSBoundParameters.ContainsKey("Tag")) {
                $Body.attr.tags = $Tag
            }
            if ($PSBoundParameters.ContainsKey("TaggedMailHandler")) {
                $Body.attr.tagged_mail_handler = $TaggedMailHandler.ToLower()
            }
            if ($PSBoundParameters.ContainsKey("QuaranantineNotification")) {
                $Body.attr.quarantine_notification = $QuaranantineNotification.ToLower()
            }
            if ($PSBoundParameters.ContainsKey("QuaranantineCategory")) {
                $Body.attr.quarantine_category = switch ($QuaranantineCategory) {
                    "Rejected" {
                        "reject"
                        break
                    }
                    "Junk folder" {
                        "add_header"
                        break
                    }
                    default {
                        # "All categories"
                        "all"
                    }
                }
            }
            if ($PSBoundParameters.ContainsKey("RateLimitValue")) {
                $Body.attr.rl_value = $RateLimitValue.ToString()
            }
            if ($PSBoundParameters.ContainsKey("RateLimitFrame")) {
                $Body.attr.rl_frame = $RateLimitFrame.Substring(0, 1).ToLower()
            }
            if ($PSBoundParameters.ContainsKey("ActiveState")) {
                $Body.attr.active = "$($ActiveState.value__)"
            }

            if ($PSBoundParameters.ContainsKey("EnforceTlsIn")) {
                $Body.attr.tls_enforce_in = if ($EnforceTlsIn.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("EnforceTlsOut")) {
                $Body.attr.tls_enforce_out = if ($EnforceTlsOut.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("ForcePasswordUpdate")) {
                $Body.attr.force_pw_update = if ($ForcePasswordUpdate.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("SogoAccess")) {
                $Body.attr.sogo_access = if ($SogoAccess.IsPresent) { "1" } else { "0" }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("ImapAccess")) {
                # Parameter was specified.
                if ($ImapAccess.IsPresent) {
                    $null = $ProtocolAccess.Add("imap")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.imap_access) {
                    $null = $ProtocolAccess.Add("imap")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("Pop3Access")) {
                # Parameter was specified.
                if ($Pop3Access.IsPresent) {
                    $null = $ProtocolAccess.Add("pop3")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.pop3_access) {
                    $null = $ProtocolAccess.Add("pop3")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("SmtpAccess")) {
                # Parameter was specified.
                if ($SmtpAccess.IsPresent) {
                    $null = $ProtocolAccess.Add("smtp")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.smtp_access) {
                    $null = $ProtocolAccess.Add("smtp")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("SieveAccess")) {
                # Parameter was specified.
                if ($SieveAccess.IsPresent) {
                    $null = $ProtocolAccess.Add("sieve")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.sieve_access) {
                    $null = $ProtocolAccess.Add("sieve")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("EasAccess")) {
                # Parameter was specified.
                if ($EasAccess.IsPresent) {
                    $null = $ProtocolAccess.Add("eas")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.eas_access) {
                    $null = $ProtocolAccess.Add("eas")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("DavAccess")) {
                # Parameter was specified.
                if ($DavAccess.IsPresent) {
                    $null = $ProtocolAccess.Add("dav")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.dav_access) {
                    $null = $ProtocolAccess.Add("dav")
                }
            }

            # ACL options.

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclManageAppPassword")) {
                # Parameter was specified.
                if ($AclManageAppPassword.IsPresent) {
                    $null = $Acl.Add("app_passwds")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_app_passwds) {
                    $null = $Acl.Add("app_passwds")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclDelimiterAction")) {
                # Parameter was specified.
                if ($AclDelimiterAction.IsPresent) {
                    $null = $Acl.Add("delimiter_action")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_delimiter_action) {
                    $null = $Acl.Add("delimiter_action")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclResetEasDevice")) {
                # Parameter was specified.
                if ($AclResetEasDevice.IsPresent) {
                    $null = $Acl.Add("eas_reset")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_eas_reset) {
                    $null = $Acl.Add("eas_reset")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclPushover")) {
                # Parameter was specified.
                if ($AclPushover.IsPresent) {
                    $null = $Acl.Add("pushover")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_pushover) {
                    $null = $Acl.Add("pushover")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclQuarantineAction")) {
                # Parameter was specified.
                if ($AclQuarantineAction.IsPresent) {
                    $null = $Acl.Add("quarantine")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_quarantine) {
                    $null = $Acl.Add("quarantine")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclQuarantineAttachment")) {
                # Parameter was specified.
                if ($AclQuarantineAttachment.IsPresent) {
                    $null = $Acl.Add("quarantine_attachments")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_quarantine_attachments) {
                    $null = $Acl.Add("quarantine_attachments")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclQuarantineNotification")) {
                # Parameter was specified.
                if ($AclQuarantineNotification.IsPresent) {
                    $null = $Acl.Add("quarantine_notification")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_quarantine_notification) {
                    $null = $Acl.Add("quarantine_notification")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclQuarantineNotificationCategory")) {
                # Parameter was specified.
                if ($AclQuarantineNotificationCategory.IsPresent) {
                    $null = $Acl.Add("quarantine_category")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_quarantine_category) {
                    $null = $Acl.Add("quarantine_category")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclSOGoProfileReset")) {
                # Parameter was specified.
                if ($AclSOGoProfileReset.IsPresent) {
                    $null = $Acl.Add("sogo_profile_reset")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_sogo_profile_reset) {
                    $null = $Acl.Add("sogo_profile_reset")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclTemporaryAlias")) {
                # Parameter was specified.
                if ($AclTemporaryAlias.IsPresent) {
                    $null = $Acl.Add("spam_alias")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_spam_alias) {
                    $null = $Acl.Add("spam_alias")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclSpamPolicy")) {
                # Parameter was specified.
                if ($AclSpamPolicy.IsPresent) {
                    $null = $Acl.Add("spam_policy")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_spam_policy) {
                    $null = $Acl.Add("spam_policy")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclSpamScore")) {
                # Parameter was specified.
                if ($AclSpamScore.IsPresent) {
                    $null = $Acl.Add("spam_score")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_spam_score) {
                    $null = $Acl.Add("spam_score")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclSyncJob")) {
                # Parameter was specified.
                if ($AclSyncJob.IsPresent) {
                    $null = $Acl.Add("syncjobs")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_syncjobs) {
                    $null = $Acl.Add("syncjobs")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclTlsPolicy")) {
                # Parameter was specified.
                if ($AclSAclTlsPolicyyncJob.IsPresent) {
                    $null = $Acl.Add("tls_policy")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_tls_policy) {
                    $null = $Acl.Add("tls_policy")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclPasswordReset")) {
                # Parameter was specified.
                if ($AclPasswordReset.IsPresent) {
                    $null = $Acl.Add("pw_reset")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_pw_reset) {
                    $null = $Acl.Add("pw_reset")
                }
            }

            $Body.attr.protocol_access = $ProtocolAccess
            $Body.attr.acl = $Acl

            if ($PSCmdlet.ShouldProcess("mailbox template [$IdentityItem].", "Update")) {
                Write-MailcowHelperLog -Message "Updating mailbox template [$IdentityItem]." -Level Information

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