function Set-DomainAdminAcl {
    <#
    .SYNOPSIS
        Updates one or more domain admin ACL (Access Control List) permissions.

    .DESCRIPTION
        Updates one or more domain admin ACL (Access Control List) permissions.

    .PARAMETER Username
        Specifies one or more domain admin usernames whose ACL settings should be updated.

    .PARAMETER All
        Enables all ACL permissions for the specified domain admin(s).

    .PARAMETER SyncJob
        Allows management of sync job settings.

    .PARAMETER Quarantine
        Allows management of quarantine settings.

    .PARAMETER LoginAs
        Allows login as a mailbox user.

    .PARAMETER SogoAccess
        Allows management of SOGo access.

    .PARAMETER AppPassword
        Allows management of app passwords.

    .PARAMETER BccMap
        Allows management of BCC maps.

    .PARAMETER Pushover
        Allows management of Pushover settings.

    .PARAMETER Filter
        Allows management of filters.

    .PARAMETER RateLimit
        Allows management of rate limits.

    .PARAMETER SpamPolicy
        Allows management of spam policy settings.

    .PARAMETER ExtendedSenderAcl
        Allows extending sender ACLs with external addresses.

    .PARAMETER UnlimitedQuota
        Allows setting unlimited mailbox quota.

    .PARAMETER ProtocolAccess
        Allows changing protocol access settings.

    .PARAMETER SmtpIpAccess
        Allows modifying allowed SMTP hosts.

    .PARAMETER AliasDomains
        Allows adding alias domains.

    .PARAMETER DomainDescription
        Allows modifying the domain description.

    .PARAMETER ChangeRelayhostForDomain
        Allows changing the relay host for a domain.

    .PARAMETER ChangeRelayhostForMailbox
        Allows changing the relay host for a mailbox.

    .EXAMPLE
        Set-MHDomainAdminAcl -Username "admin1" -SyncJob -Quarantine -LoginAs

        Enables SyncJob, Quarantine, and LoginAs ACL permissions for the domain admin "admin1".

    .EXAMPLE
        "admin1","admin2" | Set-MHDomainAdminAcl -All

        Enables all ACL permissions for multiple domain admins piped into the function.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-DomainAdminAcl.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(ParameterSetName = "Individual", Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The username of the domain admin for whom to update the ACL.")]
        [Parameter(ParameterSetName = "All", Mandatory = $true, ValueFromPipeline = $true)]
        [MailcowHelperArgumentCompleter("DomainAdmin")]
        [System.String[]]
        $Identity,

        [Parameter(ParameterSetName = "All", Mandatory = $true, HelpMessage = "Enable or disable all ACL entries.")]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to manage sync job settings.")]
        [System.Management.Automation.SwitchParameter]
        $SyncJob,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to manage quarantine settings.")]
        [System.Management.Automation.SwitchParameter]
        $Quarantine,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to manage login as mailbox user.")]
        [System.Management.Automation.SwitchParameter]
        $LoginAs,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to manage SOGo access.")]
        [System.Management.Automation.SwitchParameter]
        $SogoAccess,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to manage app passwords.")]
        [System.Management.Automation.SwitchParameter]
        $AppPassword,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to manage BCC maps.")]
        [System.Management.Automation.SwitchParameter]
        $BccMap,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to manage pushover settings.")]
        [System.Management.Automation.SwitchParameter]
        $Pushover,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to manage filters.")]
        [System.Management.Automation.SwitchParameter]
        $Filter,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to manage rate limits.")]
        [System.Management.Automation.SwitchParameter]
        $RateLimit,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to manage spam policy.")]
        [System.Management.Automation.SwitchParameter]
        $SpamPolicy,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to extend sender ACL by external addresses.")]
        [System.Management.Automation.SwitchParameter]
        $ExtendedSenderAcl,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to set unlimited quota for mailboxes.")]
        [System.Management.Automation.SwitchParameter]
        $UnlimitedQuota,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to change protocol access.")]
        [System.Management.Automation.SwitchParameter]
        $ProtocolAccess,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to change allowed hosts for STMP.")]
        [System.Management.Automation.SwitchParameter]
        $SmtpIpAccess,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to add alias domains.")]
        [System.Management.Automation.SwitchParameter]
        $AliasDomains,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to change the domain description.")]
        [System.Management.Automation.SwitchParameter]
        $DomainDescription,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to change the relay host for a domain.")]
        [System.Management.Automation.SwitchParameter]
        $ChangeRelayhostForDomain,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to change the relay host for a mailbox.")]
        [System.Management.Automation.SwitchParameter]
        $ChangeRelayhostForMailbox
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/da-acl"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = @{
                items = $Identity
                attr  = @{}
            }
            $DAACL = @()
            if ($All.IsPresent -or $SyncJob.IsPresent) { $DAACL += "syncjobs" }
            if ($All.IsPresent -or $Quarantine.IsPresent) { $DAACL += "quarantine" }
            if ($All.IsPresent -or $LoginAs.IsPresent) { $DAACL += "login_as" }
            if ($All.IsPresent -or $SogoAccess.IsPresent) { $DAACL += "sogo_access" }
            if ($All.IsPresent -or $AppPassword.IsPresent) { $DAACL += "app_passwds" }
            if ($All.IsPresent -or $BccMap.IsPresent) { $DAACL += "bcc_maps" }
            if ($All.IsPresent -or $Pushover.IsPresent) { $DAACL += "pushover" }
            if ($All.IsPresent -or $Filter.IsPresent) { $DAACL += "filters" }
            if ($All.IsPresent -or $RateLimit.IsPresent) { $DAACL += "ratelimit" }
            if ($All.IsPresent -or $SpamPolicy.IsPresent) { $DAACL += "spam_policy" }
            if ($All.IsPresent -or $ExtendedSenderAcl.IsPresent) { $DAACL += "extend_sender_acl" }
            if ($All.IsPresent -or $UnlimitedQuota.IsPresent) { $DAACL += "unlimited_quota" }
            if ($All.IsPresent -or $ProtocolAccess.IsPresent) { $DAACL += "protocol_access" }
            if ($All.IsPresent -or $SmtpIpAccess.IsPresent) { $DAACL += "smtp_ip_access" }
            if ($All.IsPresent -or $AliasDomains.IsPresent) { $DAACL += "alias_domains" }
            if ($All.IsPresent -or $DomainDescription.IsPresent) { $DAACL += "domain_desc" }
            if ($All.IsPresent -or $ChangeRelayhostForDomain.IsPresent) { $DAACL += "domain_relayhost" }
            if ($All.IsPresent -or $ChangeRelayhostForMailbox.IsPresent) { $DAACL += "mailbox_relayhost" }
            $Body.attr.da_acl = $DAACL

            Write-MailcowHelperLog -Message "Setting the ACL will overwrite any existing ACL. Know what you do!" -Level "Warning"

            if ($PSCmdlet.ShouldProcess("domain admin ACL [$IdentityItem].", "Update")) {
                Write-MailcowHelperLog -Message "Updating domain admin ACL [$IdentityItem]." -Level Information

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
