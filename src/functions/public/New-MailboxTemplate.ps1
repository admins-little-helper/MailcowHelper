function New-MailboxTemplate {
    <#
    .SYNOPSIS
        Create a new mailbox template.

    .DESCRIPTION
        Create a new mailbox template.
        A mailbox template can either be specified as a default template for a domain.
        Or you can select a template when creating a new mailbox to inherit some properties from the template.

    .PARAMETER Name
        The name of the mailbox template.

    .PARAMETER MailboxQuota
        The mailbox quota limit in MiB.

    .PARAMETER Tag
        One or more tags to will be assigned to a mailbox.

    .PARAMETER TaggedMailHandler
        The action to execute for tagged mail.

    .PARAMETER QuarantineNotification
        The notification interval.

    .PARAMETER QuarantineCategory
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
        New-MHMailboxTemplate -Name "ExampleTemplate"

        This creates a new mailbox template using default values for all parameters.

    .EXAMPLE
        New-MHMailboxTemplate -Name "ExampleTemplate" -MailboxQuota 10240 -RateLimitValue 5 -RateLimitFrame Minute

        This creates a new mailbox template allowing a maximum of 10 GByte per mailbox and allowing maximum of 5 mails per minute.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-MailboxTemplate.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = "DefaultOptions")]
    param(
        [Parameter(ParametersetName = "DefaultOptions", Position = 0, Mandatory = $true, HelpMessage = "The name of the mailbox template.")]
        [Parameter(ParametersetName = "IndividualSettings", Position = 0, Mandatory = $true, HelpMessage = "The name of the mailbox template.")]
        [System.String]
        $Name,

        [Parameter(ParametersetName = "IndividualSettings", Position = 1, Mandatory = $false, HelpMessage = "The mailbox quota limit in MiB.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MailboxQuota = 3072,

        [Parameter(ParametersetName = "IndividualSettings", Position = 2, Mandatory = $false, HelpMessage = "One or more tags to will be assigned to a mailbox.")]
        [System.String[]]
        $Tag,

        [Parameter(ParametersetName = "IndividualSettings", Position = 3, Mandatory = $false, HelpMessage = "The action to execute for tagged mail.")]
        [ValidateSet("Subject", "Subfolder", "Nothing")]
        [System.String]
        $TaggedMailHandler = "Nothing",

        [Parameter(ParametersetName = "IndividualSettings", Position = 4, Mandatory = $false, HelpMessage = "The notification interval.")]
        [ValidateSet("Never", "Hourly", "Daily", "Weekly")]
        [System.String]
        $QuarantineNotification = "Hourly",

        [Parameter(ParametersetName = "IndividualSettings", Position = 5, Mandatory = $false, HelpMessage = "The notification category. 'Rejected' includes mail that was rejected, while 'Junk folder' will notify a user about mails that were put into the junk folder.")]
        [ValidateSet("Rejected", "Junk folder", "All categories")]
        [System.String]
        $QuarantineCategory = "Rejected",

        [Parameter( ParametersetName = "IndividualSettings", Position = 6, Mandatory = $false, HelpMessage = "The rate limit value.")]
        # 0 = disable rate limit
        [ValidateRange(0, 9223372036854775807)]
        [System.Int32]
        $RateLimitValue = 0,

        [Parameter(ParametersetName = "IndividualSettings", Position = 7, Mandatory = $false, HelpMessage = "The rate limit unit.")]
        [ValidateSet("Second", "Minute", "Hour", "Day")]
        [System.String]
        $RateLimitFrame = "Hour",

        [Parameter(ParametersetName = "IndividualSettings", Position = 8, Mandatory = $false, HelpMessage = "The mailbox state. Valid values are 'Active', 'Inactive', 'DisallowLogin'.")]
        [MailcowHelperMailboxActiveState]
        $ActiveState = "Active",

        [Parameter(ParametersetName = "IndividualSettings", Position = 9, Mandatory = $false, HelpMessage = "Force a password change for the user on the next logon.")]
        [System.Management.Automation.SwitchParameter]
        $ForcePasswordUpdate,

        [Parameter(ParametersetName = "IndividualSettings", Position = 10, Mandatory = $false, HelpMessage = "Enforce TLS for incoming connections for this mailbox.")]
        [System.Management.Automation.SwitchParameter]
        $EnforceTlsIn,

        [Parameter(ParametersetName = "IndividualSettings", Position = 11, Mandatory = $false, HelpMessage = "Enforce TLS for outgoing connections from this mailbox.")]
        [System.Management.Automation.SwitchParameter]
        $EnforceTlsOut,

        [Parameter(ParametersetName = "IndividualSettings", Position = 12, Mandatory = $false, HelpMessage = "Enable or disable access to SOGo for the user.")]
        [System.Management.Automation.SwitchParameter]
        $SogoAccess,

        [Parameter(ParametersetName = "IndividualSettings", Position = 13, Mandatory = $false, HelpMessage = "Enable or disable IMAP for the user.")]
        [System.Management.Automation.SwitchParameter]
        $ImapAccess,

        [Parameter(ParametersetName = "IndividualSettings", Position = 14, Mandatory = $false, HelpMessage = "Enable or disable POP3 for the user.")]
        [System.Management.Automation.SwitchParameter]
        $Pop3Access,

        [Parameter(ParametersetName = "IndividualSettings", Position = 15, Mandatory = $false, HelpMessage = "Enable or disable SMTP for the user.")]
        [System.Management.Automation.SwitchParameter]
        $SmtpAccess,

        [Parameter(ParametersetName = "IndividualSettings", Position = 16, Mandatory = $false, HelpMessage = "Enable or disable Sieve for the user.")]
        [System.Management.Automation.SwitchParameter]
        $SieveAccess,

        [Parameter(ParametersetName = "IndividualSettings", Position = 17, Mandatory = $false, HelpMessage = "Enable or disable Exchange Active Sync.")]
        [System.Management.Automation.SwitchParameter]
        $EasAccess,

        [Parameter(ParametersetName = "IndividualSettings", Position = 18, Mandatory = $false, HelpMessage = "Enable or disable Exchange Active Sync.")]
        [System.Management.Automation.SwitchParameter]
        $DavAccess,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 19, Mandatory = $false, HelpMessage = "Allow to manage app passwords.")]
        [System.Management.Automation.SwitchParameter]
        $AclManageAppPassword,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 20, Mandatory = $false, HelpMessage = "Allow Delimiter Action.")]
        [System.Management.Automation.SwitchParameter]
        $AclDelimiterAction,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 21, Mandatory = $false, HelpMessage = "Allow to reset EAS device.")]
        [System.Management.Automation.SwitchParameter]
        $AclResetEasDevice,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 22, Mandatory = $false, HelpMessage = "Allow Pushover.")]
        [System.Management.Automation.SwitchParameter]
        $AclPushover,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 23, Mandatory = $false, HelpMessage = "Allow quarantine action.")]
        [System.Management.Automation.SwitchParameter]
        $AclQuarantineAction,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 24, Mandatory = $false, HelpMessage = "Allow quarantine attachement.")]
        [System.Management.Automation.SwitchParameter]
        $AclQuarantineAttachment,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 25, Mandatory = $false, HelpMessage = "Allow to change quarantine notification.")]
        [System.Management.Automation.SwitchParameter]
        $AclQuarantineNotification,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 26, Mandatory = $false, HelpMessage = "Allow to change quarantine notification category.")]
        [System.Management.Automation.SwitchParameter]
        $AclQuarantineNotificationCategory,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 27, Mandatory = $false, HelpMessage = "Allow to reset the SOGo profile.")]
        [System.Management.Automation.SwitchParameter]
        $AclSOGoProfileReset,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 28, Mandatory = $false, HelpMessage = "Allow to manage temporary alias.")]
        [System.Management.Automation.SwitchParameter]
        $AclTemporaryAlias,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 29, Mandatory = $false, HelpMessage = "Allow to manage SPAM policy.")]
        [System.Management.Automation.SwitchParameter]
        $AclSpamPolicy,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 30, Mandatory = $false, HelpMessage = "Allow to manage SPAM score.")]
        [System.Management.Automation.SwitchParameter]
        $AclSpamScore,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 31, Mandatory = $false, HelpMessage = "Allow to manage sync job.")]
        [System.Management.Automation.SwitchParameter]
        $AclSyncJob,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 32, Mandatory = $false, HelpMessage = "Allow to manage TLS policy.")]
        [System.Management.Automation.SwitchParameter]
        $AclTlsPolicy,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 33, Mandatory = $false, HelpMessage = "Allow to reset the user password.")]
        [System.Management.Automation.SwitchParameter]
        $AclPasswordReset
    )

    # Prepare the base Uri path.
    $UriPath = "add/mailbox/template"

    # Prepare the request body.
    $Body = @{
        template        = $Name.Trim()
        protocol_access = [System.Collections.ArrayList]@()
        acl             = [System.Collections.ArrayList]@()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("MailboxQuota")) {
        $Body.quota = $MailboxQuota.ToString()
    }
    if ($PSBoundParameters.ContainsKey("Tag")) {
        $Body.tags = $Tag
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("TaggedMailHandler")) {
        $Body.tagged_mail_handler = $TaggedMailHandler.ToLower()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("QuarantineNotification")) {
        $Body.quarantine_notification = $QuarantineNotification.ToLower()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("QuarantineCategory")) {
        $Body.quarantine_category = switch ($QuarantineCategory) {
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
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("RateLimitValue")) {
        $Body.rl_value = $RateLimitValue.ToString()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("RateLimitFrame")) {
        $Body.rl_frame = $RateLimitFrame.Substring(0, 1).ToLower()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("ActiveState")) {
        $Body.active = "$($ActiveState.value__)"
    }

    # Set some default options.
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions") {
        $EnforceTlsIn = $false
        $EnforceTlsOut = $false
        $ForcePasswordUpdate = $false
        $SogoAccess = $true

        $ImapAccess = $true
        $Pop3Access = $true
        $SmtpAccess = $true
        $SieveAccess = $true
        $EasAccess = $false
        $DavAccess = $true

        $AclManageAppPassword = $true
        $AclDelimiterAction = $true
        $AclResetEasDevice = $true
        $AclPushover = $true
        $AclQuarantineAction = $true
        $AclQuarantineAttachment = $true
        $AclQuarantineNotification = $true
        $AclQuarantineNotificationCategory = $true
        $AclSOGoProfileReset = $false
        $AclTemporaryAlias = $true
        $AclSpamPolicy = $true
        $AclSpamScore = $true
        $AclSyncJob = $false
        $AclTlsPolicy = $true
        $AclPasswordReset = $true
    }

    if ($EnforceTlsIn.IsPresent) {
        $Body.tls_enforce_in = if ($EnforceTlsIn.IsPresent) { "1" } else { "0" }
    }
    if ($EnforceTlsOut.IsPresent) {
        $Body.tls_enforce_out = if ($EnforceTlsOut.IsPresent) { "1" } else { "0" }
    }
    if ($ForcePasswordUpdate.IsPresent) {
        $Body.force_pw_update = if ($ForcePasswordUpdate.IsPresent) { "1" } else { "0" }
    }
    if ($SogoAccess.IsPresent) {
        $Body.sogo_access = if ($SogoAccess.IsPresent) { "1" } else { "0" }
    }
    if ($ImapAccess.IsPresent) {
        $null = $Body.protocol_access.Add("imap")
    }
    if ($Pop3Access.IsPresent) {
        $null = $Body.protocol_access.Add("pop3")
    }
    if ($SmtpAccess.IsPresent) {
        $null = $Body.protocol_access.Add("smtp")
    }
    if ($SieveAccess.IsPresent) {
        $null = $Body.protocol_access.Add("sieve")
    }
    if ($EasAccess.IsPresent) {
        $null = $Body.protocol_access.Add("eas")
    }
    if ($DavAccess.IsPresent) {
        $null = $Body.protocol_access.Add("dav")
    }

    if ($AclManageAppPassword.IsPresent) {
        $null = $Body.acl.Add("app_passwds")
    }
    if ($AclDelimiterAction.IsPresent) {
        $null = $Body.acl.Add("delimiter_action")
    }
    if ($AclResetEasDevice.IsPresent) {
        $null = $Body.acl.Add("eas_reset")
    }
    if ($AclPushover.IsPresent) {
        $null = $Body.acl.Add("pushover")
    }
    if ($AclQuarantineAction.IsPresent) {
        $null = $Body.acl.Add("quarantine")
    }
    if ($AclQuarantineAttachment.IsPresent) {
        $null = $Body.acl.Add("quarantine_attachments")
    }
    if ($AclQuarantineNotification.IsPresent) {
        $null = $Body.acl.Add("quarantine_notification")
    }
    if ($AclQuarantineNotificationCategory.IsPresent) {
        $null = $Body.acl.Add("quarantine_category")
    }
    if ($AclSOGoProfileReset.IsPresent) {
        $null = $Body.acl.Add("sogo_profile_reset")
    }
    if ($AclTemporaryAlias.IsPresent) {
        $null = $Body.acl.Add("spam_alias")
    }
    if ($AclSpamPolicy.IsPresent) {
        $null = $Body.acl.Add("spam_policy")
    }
    if ($AclSpamScore.IsPresent) {
        $null = $Body.acl.Add("spam_score")
    }
    if ($AclSyncJob.IsPresent) {
        $null = $Body.acl.Add("syncjobs")
    }
    if ($AclTlsPolicy.IsPresent) {
        $null = $Body.acl.Add("tls_policy")
    }
    if ($AclPasswordReset.IsPresent) {
        $null = $Body.acl.Add("pw_reset")
    }

    if ($PSCmdlet.ShouldProcess("mailbox template [$($Name.Trim())].", "Add")) {
        Write-MailcowHelperLog -Message "Adding mailbox template [$($Name.Trim())]." -Level Information

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