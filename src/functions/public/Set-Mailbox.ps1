function Set-Mailbox {
    <#
    .SYNOPSIS
        Update settings for one or more mailboxes.

    .DESCRIPTION
        Update settings for one or more mailboxes.

    .PARAMETER Identity
        The mail address of the mailbox to update.

    .PARAMETER Name
        The display name of the mailbox.

    .PARAMETER AuthSource
        The authentication source to use. Default is "mailcow".
        Suppored values are: "mailcow", "LDAP", "Keycloak" and "Generic-OIDC".

    .PARAMETER Password
        The password for the new mailbox user.

    .PARAMETER ActiveState
        The mailbox state. Valid values are:
        Active = Mails to the mail address are accepted, the account is enabled, so login is possible.
        DisallowLogin = Mails to the mail address are accepted, the account is disabled, so login is denied.
        Inactive = Mails to the mail address are rejected, the account is disabled, so login is denied.

    .PARAMETER MailboxQuota
        The mailbox quota in MB.
        If ommitted, the domain default mailbox quota will be applied.

    .PARAMETER Tag
        Add one or more tags to the mailbox, whicht can be used for filtering.

    .PARAMETER SogoAccess
        Direct forwarding to SOGo.
        After logging in, the user is automatically redirected to SOGo.

    .PARAMETER ImapAccess
        Enable or disable IMAP for the user.

    .PARAMETER Pop3Access
        Enable or disable POP3 for the user.

    .PARAMETER SmtpAccess
        Enable or disable SMTP for the user.

    .PARAMETER SieveAccess
        Enable or disable Sieve for the user.

    .PARAMETER EasAccess
        Enable or disable EAS (Exchange Active Sync) for the user.

    .PARAMETER DavAccess
        Enable or disable CalDAV/CardDAV for the user.

    .PARAMETER RelayHostId
        Set a specific relay host. Use 'Get-RoutingRelayHost' to get the configured relay hosts and their IDs.

    .PARAMETER ForcePasswordUpdate
        Force a password change for the user on the next logon.

    .PARAMETER RecoveryEmail
        Specify an email address that will be used for password recovery.

    .PARAMETER QuarantineNotification
        The notificatoin interval.
        Valid values are Never, Hourly, Daily, Weekly.

    .PARAMETER QuarantineCategory
        The notificatoin category.
        Valid values are Rejected, Junk folder, All categories.

    .PARAMETER TaggedMailAction
        Specify the action for tagged mail.
        Valid values are: Subject, Subfolder, Nothing

    .PARAMETER EnforceTlsIn
        Enforce TLS for incoming connections.

    .PARAMETER EnforceTlsOut
        Enforce TLS for outgoing connections.

    .EXAMPLE
        Set-MHMailbox -Identity "john.doe@example.com" -Name "John Doe" -MailboxQuota 10240

        Set the name for mailbox "john.doe@example.com" and also set the mailbox quota to 10 GByte.

    .EXAMPLE
        Set-MHMailbox -Identity "john.doe@example.com" -ForcePasswordUpdate

        Force password change on next logon for user "john.doe@example.com".

    .EXAMPLE
        Set-MHMailbox -Identity "john.doe@example.com" -EasAccess:$false

        Disable EAS protocol for the mailbox of user "john.doe@example.com".

    .EXAMPLE
        $DisabledMailboxes = (Get-ADUser -Filter {mail -like "*" -and Enabled -eq $false} -Properties mail).mail | Set-MHMailbox -ActiveState Inactive

        In an environment where Active Directory/LDAP is used as identity provider for mailcow, the example above shows how to get all disabled user accounts
        from Active Directory and send the output down the pipeline to the 'Set-MHMailbox' function to disable the mailbox in mailcow.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-Mailbox.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox to update.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The display name of the mailbox.")]
        [System.String]
        $Name,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The authentication source to use. Default is 'mailcow'.")]
        [ValidateSet("mailcow", "LDAP", "Keycloak", "Generic-OIDC")]
        [System.String]
        $AuthSource,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The password for the mailbox user.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "The mailbox state. Valid values are 'Active', 'Inactive', 'DisallowLogin'")]
        [MailcowHelperMailboxActiveState]
        $ActiveState,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "The mailbox quota in MB.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MailboxQuota = 3072,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "Add one or more tags to the mailbox, which can be used for filtering.")]
        [System.String[]]
        $Tag,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "Enable or disable access to SOGo for the user.")]
        [System.Management.Automation.SwitchParameter]
        $SogoAccess,

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "Enable or disable IMAP for the user.")]
        [System.Management.Automation.SwitchParameter]
        $ImapAccess,

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "Enable or disable POP3 for the user.")]
        [System.Management.Automation.SwitchParameter]
        $Pop3Access,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "Enable or disable SMTP for the user.")]
        [System.Management.Automation.SwitchParameter]
        $SmtpAccess,

        [Parameter(Position = 11, Mandatory = $false, HelpMessage = "Enable or disable Sieve for the user.")]
        [System.Management.Automation.SwitchParameter]
        $SieveAccess,

        [Parameter(Position = 12, Mandatory = $false, HelpMessage = "Enable or disable Exchange Active Sync.")]
        [System.Management.Automation.SwitchParameter]
        $EasAccess,

        [Parameter(Position = 13, Mandatory = $false, HelpMessage = "Enable or disable Exchange Active Sync.")]
        [System.Management.Automation.SwitchParameter]
        $DavAccess,

        [Parameter(Position = 14, Mandatory = $false, HelpMessage = "The ID of the relay host to use for the mailbox.")]
        [System.Int32]
        $RelayHostId,

        [Parameter(Position = 15, Mandatory = $false, HelpMessage = "Force a password change for the user on the next logon.")]
        [System.Management.Automation.SwitchParameter]
        $ForcePasswordUpdate,

        [Parameter(Position = 16, Mandatory = $false, HelpMessage = "Set the password recovery mail address for the mailbox.")]
        [AllowNull()]
        [System.Net.Mail.MailAddress]
        $RecoveryEmail,

        [Parameter(Position = 17, Mandatory = $false, HelpMessage = "The notification interval.")]
        [ValidateSet("Never", "Hourly", "Daily", "Weekly")]
        [System.String]
        $QuarantineNotification = "Hourly",

        [Parameter(Position = 18, Mandatory = $false, HelpMessage = "The notification category. 'Rejected' includes mail that was rejected, while 'Junk folder' will notify a user about mails that were put into the junk folder.")]
        [ValidateSet("Rejected", "Junk folder", "All categories")]
        [System.String]
        $QuarantineCategory = "Rejected",

        [Parameter(Position = 19, Mandatory = $false, HelpMessage = "The action to take for plus-tagged mails.")]
        [ValidateSet("Subject", "Subfolder", "Nothing")]
        [System.String]
        $TaggedMailAction,

        [Parameter(Position = 20, Mandatory = $false, HelpMessage = "Enforce TLS for incoming connections for this mailbox.")]
        [System.Management.Automation.SwitchParameter]
        $EnforceTlsIn,

        [Parameter(Position = 21, Mandatory = $false, HelpMessage = "Enforce TLS for outgoing connections from this mailbox.")]
        [System.Management.Automation.SwitchParameter]
        $EnforceTlsOut
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/mailbox"
    }

    process {
        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        # Prepare a string that will be used for logging.
        $LogIdString = if ($Identity.Count -gt 1) {
            "$($Identity.Count) mailboxes"
        }
        else {
            foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
        }

        # Set name to the local part of th mail address, if it was not specified explicitly.
        if (-not $PSBoundParameters.ContainsKey("Name")) {
            $Name = $Identity.User
        }

        # Prepare the request body.
        $Body = @{
            # Assign all mail addresses to the "items" attribute.
            items = foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
            attr  = @{}
        }
        if ($PSBoundParameters.ContainsKey("ActiveState")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Setting mailbox to state [$ActiveState]."
            $Body.attr.active = "$($ActiveState.value__)"
        }
        if ($PSBoundParameters.ContainsKey("Name")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Setting the mailbox name to [$($Name.Trim())]."
            $Body.attr.name = $Name.Trim()
        }
        if ($PSBoundParameters.ContainsKey("AuthSource")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Setting the auth source for mailbox to [$($AuthSource)]."
            $Body.attr.authsource = $AuthSource.Tolower()
        }
        if ($PSBoundParameters.ContainsKey("MailboxQuota")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Setting the mailbox quota for mailbox to [$($MailboxQuota)]."
            $Body.attr.quota = $MailboxQuota.ToString()
        }
        if ($PSBoundParameters.ContainsKey("SogoAccess")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Enable SOGo direct forward for mailbox --> [$($SogoAccess.IsPresent)]."
            $Body.attr.sogo_access = if ($SogoAccess.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("ImapAccess")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Enable IMAP for mailbox --> [$($ImapAccess.IsPresent)]."
            $Body.attr.imap_access = if ($ImapAccess.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("Pop3Access")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Enable POP3 for mailbox --> [$($Pop3Access.IsPresent)]."
            $Body.attr.pop3_access = if ($Pop3Access.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("SmtpAccess")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Enable SMTP for mailbox --> [$($SmtpAccess.IsPresent)]."
            $Body.attr.smtp_access = if ($SmtpAccess.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("SieveAccess")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Enable Sieve for mailbox --> [$($SieveAccess.IsPresent)]."
            $Body.attr.sieve_access = if ($SieveAccess.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("EasAccess")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Enable EAS for mailbox --> [$($EasAccess.IsPresent)]."
            $Body.attr.eas_access = if ($EasAccess.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("DavAccess")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Enable Cal/CardDAV for mailbox --> [$($DavAccess.IsPresent)]."
            $Body.attr.dav_access = if ($DavAccess.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("RelayHostId")) {
            # Set the relay host for the mailbox.
            Write-MailcowHelperLog -Message "[$LogIdString] Setting relay host for mailbox to ID [$RelayHostId]."
            $Body.attr.relayhost = $RelayHostId
        }
        if ($PSBoundParameters.ContainsKey("Password")) {
            # Set the password and the password confirmation value to the entered password.
            Write-MailcowHelperLog -Message "[$LogIdString] Setting password for mailbox."
            $Body.attr.password = $Body.password2 = $Password | ConvertFrom-SecureString -AsPlainText
        }
        if ($PSBoundParameters.ContainsKey("ForcePasswordUpdate")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Force password updatefor mailbox --> [$($ForcePasswordUpdate.IsPresent)]."
            $Body.attr.force_pw_update = if ($ForcePasswordUpdate.IsPresent) { "1" } else { "0" }
        }
        if (-not [System.String]::IsNullOrEmpty($Tag)) {
            Write-MailcowHelperLog -Message "[$LogIdString] Setting mailbox tags to [$($Tag -join ",")]."
            $Body.attr.tags = $Tag
        }
        if ($PSBoundParameters.ContainsKey("RecoveryEmail")) {
            if ([System.String]::IsNullOrEmpty($RecoveryEmail)) {
                Write-MailcowHelperLog -Message "[$LogIdString] Removing password recovery email address."
                $Body.attr.pw_recovery_email = ""
            }
            else {
                Write-MailcowHelperLog -Message "[$LogIdString] Setting password recovery email address to [$($RecoveryEmail.Address))]."
                $Body.attr.pw_recovery_email = $RecoveryEmail.Address
            }
        }
        if ($PSBoundParameters.ContainsKey("QuarantineNotification")) {
            # Call another function because the "edit/mailbox" API endpoint does not support the option "quarantine_notification".
            $SetMailboxQuarantineNotificationParams = @{
                Identity                 = $Identity
                QuaranantineNotification = $QuarantineNotification
            }
            Set-MailboxQuarantineNotification @SetMailboxQuarantineNotificationParams
        }
        if ($PSBoundParameters.ContainsKey("QuarantineCategory")) {
            # Call another function because the "edit/mailbox" API endpoint does not support the option "quarantine_category".
            $SetMailboxQuarantineNotificationCategoryParams = @{
                Identity             = $Identity
                QuaranantineCategory = $QuarantineCategory
            }
            Set-MailboxQuarantineNotificationCategory @SetMailboxQuarantineNotificationCategoryParams
        }
        if ($PSBoundParameters.ContainsKey("TaggedMailAction")) {
            # Call another function because the "edit/mailbox" API endpoint does not support the option "delimiter_action".
            $SetMailboxTaggedMailHandlingParams = @{
                Identity         = $Identity
                TaggedMailAction = $TaggedMailAction
            }
            Set-MailboxTaggedMailHandling @SetMailboxTaggedMailHandlingParams
        }
        if ($PSBoundParameters.ContainsKey("EnforceTlsIn") -or $PSBoundParameters.ContainsKey("EnforceTlsOut")) {
            # Call another function because the "edit/mailbox" API endpoint does not support the option "delimiter_action".
            $SetMHMailboxTlsPolicyParams = @{
                Identity = $Identity
            }
            if ($PSBoundParameters.ContainsKey("EnforceTlsIn")) {
                $SetMHMailboxTlsPolicyParams.EnforceTlsIn = $EnforceTlsIn
            }
            if ($PSBoundParameters.ContainsKey("EnforceTlsOut")) {
                $SetMHMailboxTlsPolicyParams.EnforceTlsOut = $EnforceTlsOut
            }
            Set-MHMailboxTlsPolicy @SetMHMailboxTlsPolicyParams
        }

        if ($PSCmdlet.ShouldProcess("mailbox settings for [$LogIdString]", "Update")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Updating mailbox settings." -Level Information

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
