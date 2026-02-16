function Get-Mailbox {
    <#
    .SYNOPSIS
        Return information about one or more mailboxes.

    .DESCRIPTION
        Return information about one or more mailboxes.

    .PARAMETER Identity
        The mail address of the mailbox for which to get information.
        If omitted, all mailboxes are returned.

    .PARAMETER Tag
        A tag to filter the result on.
        This is only relevant if parameter "Identity" is not specified so to return all mailboxes.

    .PARAMETER Domain
        The name of the domain for which to get mailbox information.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHMailbox

        Return information for all mailboxes on the mailcow server.

    .EXAMPLE
        Get-MHMailbox -Domain "example.com"

        Returns mailbox information for all mailboxes in domain "example.com".

    .EXAMPLE
        Get-MHMailbox -Tag "MyTag"

        Returns mailbox information for all mailboxes tagged with "MyTag"

    .EXAMPLE
        Get-MHMailbox -Domain "example.com" -Tag "MyTag"

        Returns mailbox information for all mailboxes tagged with "MyTag" in domain "example.com"

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Mailbox.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = "Identity")]
    param(
        [Parameter(ParameterSetName = "Identity", Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to get information.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(ParameterSetName = "Domain", Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The name of the domain for which to get mailbox information.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String[]]
        $Domain,

        [Parameter(ParameterSetName = "Identity", Position = 1, Mandatory = $false, HelpMessage = "Specify a tag to filter.")]
        [Parameter(ParameterSetName = "Domain", Position = 1, Mandatory = $false, HelpMessage = "Specify a tag to filter.")]
        [System.String[]]
        $Tag,

        [Parameter(ParameterSetName = "Identity", Position = 2, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [Parameter(ParameterSetName = "Domain", Position = 2, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        switch ($PSCmdlet.ParameterSetName) {
            "Identity" {
                # Prepare the base Uri path.
                $UriPath = "get/mailbox/"
                if ([System.String]::IsNullOrEmpty($Identity)) {
                    # In case no specific mailbox name/mail address was given, use "All".
                    $RequestedIdentity = "All"
                }
                else {
                    # Set the requsted identity to all mail addresses (String value) specified by parameter "Identity".
                    $RequestedIdentity = foreach ($IdentityItem in $Identity) {
                        $IdentityItem.Address
                    }
                }
                break
            }
            "Domain" {
                # Prepare the base Uri path.
                $UriPath = "get/mailbox/all/"
            }
            default {
                # Should never reach this point.
                Write-MailcowHelperLog -Message "Error - invalid parameter set name!" - Level Error
            }
        }
    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            "Identity" {
                $Result = foreach ($IdentityItem in $RequestedIdentity) {
                    # Build full Uri.
                    $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdentityItem.ToLower())
                    if (-not [System.String]::IsNullOrEmpty($Tag)) {
                        $RequestUriPath += "?tags=" + [System.Web.HttpUtility]::UrlEncode($Tag.ToLower() -join ",")
                    }

                    # Execute the API call.
                    Invoke-MailcowApiRequest -UriPath $RequestUriPath
                }
                break
            }
            "Domain" {
                $Result = foreach ($DomainItem in $Domain) {
                    # Build full Uri.
                    $RequestUriPath = $UriPath + $DomainItem

                    # Execute the API call.
                    Invoke-MailcowApiRequest -UriPath $RequestUriPath
                }
                break
            }
            default {
                # Should never reach this point.
                Write-MailcowHelperLog -Message "Error - invalid parameter set name!" - Level Error
            }
        }

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
                    $RateLimit = "$($Item.rl.value) msgs/$($Item.rl.frame)"
                }
                else {
                    $RateLimit = "Unlimited"
                }

                $ConvertedItem = [PSCustomObject]@{
                    Username               = $Item.username
                    Active                 = [System.Boolean][System.Int32]$Item.active
                    ActiveInt              = [System.Boolean][System.Int32]$Item.active_int
                    Domain                 = $Item.domain
                    Name                   = $Item.name
                    LocalPart              = $Item.local_part

                    # Attributes           = $Item.attributes
                    ForcePasswordUpdate    = [System.Boolean][System.Int32]$Item.attributes.force_pw_update
                    EnforceTlsIn           = [System.Boolean][System.Int32]$Item.attributes.tls_enforce_in
                    EnforceTlsOut          = [System.Boolean][System.Int32]$Item.attributes.tls_enforce_out
                    SOGoAccess             = [System.Boolean][System.Int32]$Item.attributes.sogo_access
                    ImapAccess             = [System.Boolean][System.Int32]$Item.attributes.imap_access
                    Pop3Access             = [System.Boolean][System.Int32]$Item.attributes.pop3_access
                    SmtpAccess             = [System.Boolean][System.Int32]$Item.attributes.smtp_access
                    SieveAccess            = [System.Boolean][System.Int32]$Item.attributes.sieve_access
                    EasAccess              = [System.Boolean][System.Int32]$Item.attributes.eas_access
                    DavAccess              = [System.Boolean][System.Int32]$Item.attributes.dav_access
                    RelayHostId            = $Item.attributes.relayhost
                    PasswordUpdate         = if ($Item.attributes.passwd_update) { (Get-Date -Date $Item.attributes.passwd_update) }
                    MailboxFormat          = $Item.attributes.mailbox_format
                    QuarantineNotification = $Item.attributes.quarantine_notification
                    QuarantineCategory     = $Item.attributes.quarantine_category
                    RecoveryEmail          = $Item.attributes.recovery_email

                    CustomAttributes       = $Item.custom_attributes
                    QuotaUsed              = $Item.quota_used
                    PercentInUse           = $Item.percent_in_use
                    PercentClass           = $Item.pcerent_class
                    AuthSource             = $Item.authsource
                    MaxNewQuota            = $Item.max_new_quota
                    SpamAliases            = $Item.spam_aliases
                    PushoverActive         = [System.Boolean][System.Int32]$Item.pushover_active
                    RateLimit              = $RateLimit
                    RlScope                = $Item.rl_scope
                    IsRelayed              = [System.Boolean][System.Int32]$Item.is_relayed
                    WhenCreated            = if ($Item.created) { (Get-Date -Date $Item.created) }
                    WhenModified           = if ($Item.modified) { (Get-Date -Date $Item.modified) }
                    LastImapLogin          = if ($Item.last_imap_login) { (Get-Date -Date $Item.last_imap_login) }
                    LastSmtpLogin          = if ($Item.last_smtp_login) { (Get-Date -Date $Item.last_smtp_login) }
                    LastPop3Login          = if ($Item.last_pop3_login) { (Get-Date -Date $Item.last_pop3_login) }
                    LastSsoLogin           = if ($Item.last_sso_login) { (Get-Date -Date $Item.last_sso_login) }
                }
                $ConvertedItem.PSObject.TypeNames.Insert(0, "MHMailbox")
                $ConvertedItem
            }
            # Return the result in custom format.
            $ConvertedResult
        }
    }
}
