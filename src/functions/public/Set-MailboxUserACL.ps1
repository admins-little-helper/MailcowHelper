function Set-MailboxUserACL {
    <#
    .SYNOPSIS
        Updates the ACL (Access Control List) for one or more mailboxes.

    .DESCRIPTION
        Updates the ACL (Access Control List) for one or more mailboxes.

        The cmdlet overwrites the entire ACL set for the mailbox. Use with caution!

    .PARAMETER Identity
        The mail address of the mailbox for which ACL settings should be updated.

    .PARAMETER ResetToDefault
        Resets all ACL permissions to their default values.

    .PARAMETER ManageAppPassword
        Allows the user to manage application passwords.

    .PARAMETER DelimiterAction
        Allows the user to manage delimiter actions.

    .PARAMETER ResetEasDevice
        Allows the user to reset EAS devices.

    .PARAMETER Pushover
        Allows the user to manage Pushover settings.

    .PARAMETER QuarantineAction
        Allows the user to perform quarantine actions.

    .PARAMETER QuarantineAttachment
        Allows the user to manage quarantine attachments.

    .PARAMETER QuarantineNotification
        Allows the user to modify quarantine notification settings.

    .PARAMETER QuarantineNotificationCategory
        Allows the user to modify quarantine notification categories.

    .PARAMETER TemporaryAlias
        Allows the user to manage temporary aliases.

    .PARAMETER SpamPolicy
        Allows the user to manage SPAM policy settings.

    .PARAMETER SpamScore
        Allows the user to manage SPAM score settings.

    .PARAMETER TlsPolicy
        Allows the user to manage TLS policy settings.

    .PARAMETER PasswordReset
        Allow to reset mailcow user password.
        Not part of the default ACL.

    .PARAMETER SyncJob
        Allows the user to manage sync jobs.
        Not part of the default ACL.

    .PARAMETER SOGoProfileReset
        Allows the user to reset their SOGo profile.
        Not part of the default ACL.

    .EXAMPLE
        Set-MHMailboxUserACL -Identity "user@example.com" -ResetToDefault

        Resets all ACL permissions for the mailbox to Mailcow defaults.

    .EXAMPLE
        Set-MHMailboxUserACL -Identity "user@example.com" -ManageAppPassword -SpamPolicy -TlsPolicy

        Enables the specified ACL permissions for the mailbox.

    .EXAMPLE
        "one@example.com","two@example.com" | Set-MHMailboxUserACL -ResetToDefault

        Resets ACL permissions for multiple mailboxes using pipeline input.

    .NOTES
        This cmdlet overwrites all existing ACL settings.
        Ensure you understand the implications before applying changes.

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxUserACL.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(ParameterSetName = "IndividualSettings", Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which ACL settings should be updated.")]
        [Parameter(ParameterSetName = "DefaultSettings", Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(ParameterSetName = "DefaultSettings", Position = 1, Mandatory = $true, HelpMessage = "Reset all permissions to default values.")]
        [System.Management.Automation.SwitchParameter]
        $ResetToDefault,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 1, Mandatory = $false, HelpMessage = "Allow to manage app passwords.")]
        [System.Management.Automation.SwitchParameter]
        $ManageAppPassword,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 2, Mandatory = $false, HelpMessage = "Allow Delimiter Action.")]
        [System.Management.Automation.SwitchParameter]
        $DelimiterAction,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 3, Mandatory = $false, HelpMessage = "Allow to reset EAS device.")]
        [System.Management.Automation.SwitchParameter]
        $ResetEasDevice,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 4, Mandatory = $false, HelpMessage = "Allow Pushover.")]
        [System.Management.Automation.SwitchParameter]
        $Pushover,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 5, Mandatory = $false, HelpMessage = "Allow quarantine action.")]
        [System.Management.Automation.SwitchParameter]
        $QuarantineAction,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 6, Mandatory = $false, HelpMessage = "Allow quarantine attachement.")]
        [System.Management.Automation.SwitchParameter]
        $QuarantineAttachment,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 7, Mandatory = $false, HelpMessage = "Allow to change quarantine notification.")]
        [System.Management.Automation.SwitchParameter]
        $QuarantineNotification,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 8, Mandatory = $false, HelpMessage = "Allow to change quarantine notification category.")]
        [System.Management.Automation.SwitchParameter]
        $QuarantineNotificationCategory,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 9, Mandatory = $false, HelpMessage = "Allow to manage temporary alias.")]
        [System.Management.Automation.SwitchParameter]
        $TemporaryAlias,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 10, Mandatory = $false, HelpMessage = "Allow to manage SPAM policy.")]
        [System.Management.Automation.SwitchParameter]
        $SpamPolicy,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 11, Mandatory = $false, HelpMessage = "Allow to manage SPAM score.")]
        [System.Management.Automation.SwitchParameter]
        $SpamScore,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 12, Mandatory = $false, HelpMessage = "Allow to manage TLS policy.")]
        [System.Management.Automation.SwitchParameter]
        $TlsPolicy,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 13, Mandatory = $false, HelpMessage = "Allow to reset mailcow user password.")]
        [System.Management.Automation.SwitchParameter]
        $PasswordReset,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 14, Mandatory = $false, HelpMessage = "Allow to manage sync job.")]
        [System.Management.Automation.SwitchParameter]
        $SyncJob,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 15, Mandatory = $false, HelpMessage = "Allow to reset the SOGo profile.")]
        [System.Management.Automation.SwitchParameter]
        $SOGoProfileReset
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/user-acl"
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

        Write-MailcowHelperLog -Message "[$LogIdString] Updating quarantine notification setting for mailbox."

        # Prepare the request body.
        $Body = @{
            # Assign all mail addresses to the "items" attribute.
            items = foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
            attr  = @{
                user_acl = [System.Collections.ArrayList]@()
            }
        }

        # Set the default options or any explicitly defined options.
        if ($ResetToDefault.IsPresent -or $ManageAppPassword.IsPresent) {
            $null = $Body.attr.user_acl.Add("app_passwds")
        }
        if ($ResetToDefault.IsPresent -or $DelimiterAction.IsPresent) {
            $null = $Body.attr.user_acl.Add("delimiter_action")
        }
        if ($ResetToDefault.IsPresent -or $Pushover.IsPresent) {
            $null = $Body.attr.user_acl.Add("pushover")
        }
        if ($ResetToDefault.IsPresent -or $ResetEasDevice.IsPresent) {
            $null = $Body.attr.user_acl.Add("eas_reset")
        }
        if ($ResetToDefault.IsPresent -or $QuarantineAction.IsPresent) {
            $null = $Body.attr.user_acl.Add("quarantine")
        }
        if ($ResetToDefault.IsPresent -or $QuarantineAttachment.IsPresent) {
            $null = $Body.attr.user_acl.Add("quarantine_attachments")
        }
        if ($ResetToDefault.IsPresent -or $QuarantineNotification.IsPresent) {
            $null = $Body.attr.user_acl.Add("quarantine_notification")
        }
        if ($ResetToDefault.IsPresent -or $QuarantineNotificationCategory.IsPresent) {
            $null = $Body.attr.user_acl.Add("quarantine_category")
        }
        if ($ResetToDefault.IsPresent -or $TemporaryAlias.IsPresent) {
            $null = $Body.attr.user_acl.Add("spam_alias")
        }
        if ($ResetToDefault.IsPresent -or $SpamPolicy.IsPresent) {
            $null = $Body.attr.user_acl.Add("spam_policy")
        }
        if ($ResetToDefault.IsPresent -or $SpamScore.IsPresent) {
            $null = $Body.attr.user_acl.Add("spam_score")
        }
        if ($ResetToDefault.IsPresent -or $TlsPolicy.IsPresent) {
            $null = $Body.attr.user_acl.Add("tls_policy")
        }

        # Set the non-default options only if specified explicitely.
        if ($PasswordReset.IsPresent) {
            $null = $Body.attr.user_acl.Add("pw_reset")
        }
        if ($SyncJob.IsPresent) {
            $null = $Body.attr.user_acl.Add("syncjobs")
        }
        if ($SOGoProfileReset.IsPresent) {
            $null = $Body.attr.user_acl.Add("sogo_profile_reset")
        }

        Write-MailcowHelperLog -Message "Setting the ACL will overwrite any existing ACL. Know what you do!" -Level "Warning"

        if ($PSCmdlet.ShouldProcess("Mailbox user ACL for [$LogIdString]", "Update")) {
            Write-MailcowHelperLog -Message "Updating mailbox user ACL for [$LogIdString]." -Level Information

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
