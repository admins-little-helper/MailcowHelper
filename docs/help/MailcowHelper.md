---
Module Name: MailcowHelper
Module Guid: 5e9a9fbd-86b3-44ab-ab25-10ed46bac7c0
Download Help Link: {{ Update Download Link }}
Help Version: 1.0.0.0
Locale: en-US
---

# MailcowHelper Module
## Description
{{ Fill in the Description }}

## MailcowHelper Cmdlets
### [Clear-MHEasCache](Clear-MHEasCache.md)
Clear the EAS (Exchange Active Sync) cache for one or more mailboxes.

### [Clear-MHQueue](Clear-MHQueue.md)
Flush the current mail queue.
This will try to deliver all mails currently in the queue.

### [Connect-MHMailcow](Connect-MHMailcow.md)
Connects to the specified mailcow server using the specified API key, or loads previously saved settings.

### [Copy-MHDkimKey](Copy-MHDkimKey.md)
Copy a DKIM key from one domain to another.

### [Disable-MHMailcowHelperArgumentCompleter](Disable-MHMailcowHelperArgumentCompleter.md)
Disables the MailcowHelper custom ArgumentCompleter for the specified item type.

### [Disconnect-MHMailcow](Disconnect-MHMailcow.md)
Clears the session variable holding information about a previously connected mailcow server and the custom ArgumentCompleter cache.

### [Enable-MHMailcowHelperArgumentCompleter](Enable-MHMailcowHelperArgumentCompleter.md)
Enables the MailcowHelper custom ArgumentCompleter for the specified item type.

### [Get-MHAddressRewriteBccMap](Get-MHAddressRewriteBccMap.md)
Get one or more BCC map definitions.

### [Get-MHAddressRewriteRecipientMap](Get-MHAddressRewriteRecipientMap.md)
Get one or more recipient map definitions.

### [Get-MHAdmin](Get-MHAdmin.md)
Get information about one or more admin user accounts.

### [Get-MHAliasDomain](Get-MHAliasDomain.md)
Get information about one or more alias-domains.

### [Get-MHAliasMail](Get-MHAliasMail.md)
Get information about one ore more alias mail addresses.

### [Get-MHAliasTimeLimited](Get-MHAliasTimeLimited.md)
Get information about all time-limited aliases (spam-alias) defined for a mailbox.

### [Get-MHAppPassword](Get-MHAppPassword.md)
Get application-specific password settings for a mailbox.

### [Get-MHBanList](Get-MHBanList.md)
Get ban list entries from the fail2ban service.

### [Get-MHDkimKey](Get-MHDkimKey.md)
Get the DKIM key for a specific domain or for all domains.

### [Get-MHDomain](Get-MHDomain.md)
Get information about one or more domains registered on the mailcow server.

### [Get-MHDomainAdmin](Get-MHDomainAdmin.md)
Get information about one or more domain admins.

### [Get-MHDomainAntiSpamPolicy](Get-MHDomainAntiSpamPolicy.md)
Get blacklist or whitelist policies for a domain.

### [Get-MHDomainTemplate](Get-MHDomainTemplate.md)
Get information about domain templates.

### [Get-MHFail2BanConfig](Get-MHFail2BanConfig.md)
Returns the fail2ban configuration of the mailcow server.

### [Get-MHForwardingHost](Get-MHForwardingHost.md)
Returns the forwarding hosts configured in mailcow.

### [Get-MHIdentityProvider](Get-MHIdentityProvider.md)
Returns the identity provider configuration of the authentication source that is currently set in mailcow.

### [Get-MHLog](Get-MHLog.md)
Get mailcow server logs of the specified type.

### [Get-MHMailbox](Get-MHMailbox.md)
Return information about one or more mailboxes.

### [Get-MHMailboxLastLogin](Get-MHMailboxLastLogin.md)
Return information about the last login to one or more mailboxes.

### [Get-MHMailboxSpamScore](Get-MHMailboxSpamScore.md)
Get the spam score for one ore more mailboxes.

### [Get-MHMailboxTemplate](Get-MHMailboxTemplate.md)
Get information about mailbox templates.

### [Get-MHMailcowHelperArgumentCompleterValue](Get-MHMailcowHelperArgumentCompleterValue.md)
Get values for the specified argument completer.

### [Get-MHMailcowHelperConfig](Get-MHMailcowHelperConfig.md)
Reads settings form a MailcowHelper config file.

### [Get-MHOauthClient](Get-MHOauthClient.md)
Return OAuth client configuration.

### [Get-MHPasswordPolicy](Get-MHPasswordPolicy.md)
Return the password policy configured in mailcow.

### [Get-MHQuarantine](Get-MHQuarantine.md)
Get all mails that are currently in quarantine.

### [Get-MHQueue](Get-MHQueue.md)
Get the current mail queue and everything it contains.

### [Get-MHRatelimit](Get-MHRatelimit.md)
Get the rate limit for one or more mailboxes or domains.

### [Get-MHResource](Get-MHResource.md)
Return information about one or more resource accounts.

### [Get-MHRoutingRelayHost](Get-MHRoutingRelayHost.md)
Returns information about the relay hosts configured in a mailcow.

### [Get-MHRoutingTransport](Get-MHRoutingTransport.md)
Return transport map configuration.

### [Get-MHRspamdSetting](Get-MHRspamdSetting.md)
Returns one or more Rspamd rules.

### [Get-MHSieveFilter](Get-MHSieveFilter.md)
Returns admin defined Sieve filters for one or more user mailboxes.

### [Get-MHSieveGlobalFilter](Get-MHSieveGlobalFilter.md)
Return the global Sieve filter script.

### [Get-MHStatus](Get-MHStatus.md)
Returns status information for the specified area for a mailcow server.

### [Get-MHSyncJob](Get-MHSyncJob.md)
Get information about all sync jobs on the mailcow server.

### [Get-MHTlsPolicyMap](Get-MHTlsPolicyMap.md)
Return TLS policy map override map.

### [Initialize-MHMailcowHelperSession](Initialize-MHMailcowHelperSession.md)
Initializes a session to a mailcow server using the MailcowHelper module.

### [Invoke-MHMailcowApiRequest](Invoke-MHMailcowApiRequest.md)
Wrapper function for "Invoke-WebRequest" used to call the mailcow API.

### [New-MHAddressRewriteBccMap](New-MHAddressRewriteBccMap.md)
Add a new BCC map.

### [New-MHAddressRewriteRecipientMap](New-MHAddressRewriteRecipientMap.md)
Add a new address rewriting recipient map.

### [New-MHAdmin](New-MHAdmin.md)
Add a new admin user account on the mailcow server.

### [New-MHAliasDomain](New-MHAliasDomain.md)
Adds a new alias domain.

### [New-MHAliasMail](New-MHAliasMail.md)
Add an alias mail address.

### [New-MHAliasTimeLimited](New-MHAliasTimeLimited.md)
Adds a time-limited alias (spamalias) to a mailbox.

### [New-MHAppPassword](New-MHAppPassword.md)
Add a new application-specific password for a mailbox user.

### [New-MHDkimKey](New-MHDkimKey.md)
Adds a DKIM key for a domain.

### [New-MHDomain](New-MHDomain.md)
Add a domain to mailcow server.

### [New-MHDomainAdmin](New-MHDomainAdmin.md)
Add a domain admin user account.

### [New-MHDomainAntiSpamPolicy](New-MHDomainAntiSpamPolicy.md)
Add a blacklist or whitelist policy for a domain.

### [New-MHDomainTemplate](New-MHDomainTemplate.md)
Create a new domain template.

### [New-MHForwardingHost](New-MHForwardingHost.md)
Add one or more forwarding hosts to mailcow.

### [New-MHMailbox](New-MHMailbox.md)
Add one or more mailboxes.

### [New-MHMailboxTemplate](New-MHMailboxTemplate.md)
Create a new mailbox template.

### [New-MHMtaSts](New-MHMtaSts.md)
Add a MTS-STS policy for the specified domain.

### [New-MHOauthClient](New-MHOauthClient.md)
Add an OAuth client to the mailcow server.

### [New-MHResource](New-MHResource.md)
Adds one or more resource accounts on a mailcow server.

### [New-MHRoutingRelayHost](New-MHRoutingRelayHost.md)
Creates a relay host (sender-dependent transport) configuration on the mailcow server.

### [New-MHRoutingTransport](New-MHRoutingTransport.md)
Create a transport map configuration.

### [New-MHRspamdSetting](New-MHRspamdSetting.md)
Creates a new Rspamd rule.

### [New-MHSieveFilter](New-MHSieveFilter.md)
Create a new admin defined Sieve filter for one or more mailboxes.

### [New-MHSyncJob](New-MHSyncJob.md)
Add a new sync job for a mailbox.

### [New-MHTlsPolicyMap](New-MHTlsPolicyMap.md)
Create a new TLS policy map override.

### [Remove-MHAddressRewriteBccMap](Remove-MHAddressRewriteBccMap.md)
Removes a BCC map.

### [Remove-MHAddressRewriteRecipientMap](Remove-MHAddressRewriteRecipientMap.md)
Remove a recipient map.

### [Remove-MHAdmin](Remove-MHAdmin.md)
Removes an admin user account.

### [Remove-MHAliasDomain](Remove-MHAliasDomain.md)
Removes an alias domain.

### [Remove-MHAliasMail](Remove-MHAliasMail.md)
Removes one or more mail aliases.

### [Remove-MHAliasTimeLimited](Remove-MHAliasTimeLimited.md)
Removes one or more time-limited alias (spamalias).

### [Remove-MHAppPassword](Remove-MHAppPassword.md)
Deletes one or more appliation-specific passwords.

### [Remove-MHDkimKey](Remove-MHDkimKey.md)
Deletes a DKIM key for one or more domains.

### [Remove-MHDomain](Remove-MHDomain.md)
Deletes one or more domains from mailcow server.

### [Remove-MHDomainAdmin](Remove-MHDomainAdmin.md)
Deletes one or more domain admin user accounts.

### [Remove-MHDomainAntiSpamPolicy](Remove-MHDomainAntiSpamPolicy.md)
Remove one ore more blacklist or whitelist policies.

### [Remove-MHDomainTag](Remove-MHDomainTag.md)
Remove one or more tags from one or more domains.

### [Remove-MHDomainTemplate](Remove-MHDomainTemplate.md)
Remove one or more domain templates.

### [Remove-MHForwardingHost](Remove-MHForwardingHost.md)
Delete one or more forwarding host from the mailcow configuration.

### [Remove-MHMailbox](Remove-MHMailbox.md)
Delete one or more mailboxes.

### [Remove-MHMailboxTag](Remove-MHMailboxTag.md)
Remove one or more tags from one or more mailboxes.

### [Remove-MHMailboxTemplate](Remove-MHMailboxTemplate.md)
Remove one or more mailbox templates.

### [Remove-MHOauthClient](Remove-MHOauthClient.md)
Remove one or more OAuth client configurations.

### [Remove-MHQuarantineItem](Remove-MHQuarantineItem.md)
Remove one or more mail items from the quarantine.

### [Remove-MHQueue](Remove-MHQueue.md)
Delete the current mail queue.
This will delete all mails in the queue.

### [Remove-MHRateLimit](Remove-MHRateLimit.md)
Remove the rate limit for one or more mailboxs or domains.

### [Remove-MHRoutingRelayHost](Remove-MHRoutingRelayHost.md)
Removes one or more relay hosts configured on a mailcow server.

### [Remove-MHRoutingTransport](Remove-MHRoutingTransport.md)
Removes one or more transport map configurations.

### [Remove-MHRspamdSetting](Remove-MHRspamdSetting.md)
Removes one or more Rspamd rules.

### [Remove-MHSieveFilter](Remove-MHSieveFilter.md)
Removes one or more admin defined Sieve filter scripts.

### [Remove-MHSyncJob](Remove-MHSyncJob.md)
Remove one or more sync jobs from the mailcow server.

### [Remove-MHTlsPolicyMap](Remove-MHTlsPolicyMap.md)
Removes one or more TLS policy map override maps.

### [Set-MHAddressRewriteBccMap](Set-MHAddressRewriteBccMap.md)
Updates one or more BCC maps.

### [Set-MHAddressRewriteRecipientMap](Set-MHAddressRewriteRecipientMap.md)
Updates one or more address rewriting recipient maps.

### [Set-MHAdmin](Set-MHAdmin.md)
Updates an admin user account.

### [Set-MHAliasDomain](Set-MHAliasDomain.md)
Updates one or more alias domains.

### [Set-MHAliasMail](Set-MHAliasMail.md)
Update a mail alias.

### [Set-MHAliasTimeLimited](Set-MHAliasTimeLimited.md)
Updates one or more time-limited aliases (spamalias).

### [Set-MHAppPassword](Set-MHAppPassword.md)
Updates one or more users application-specific password configurations.

### [Set-MHDomain](Set-MHDomain.md)
Update one or more domains on the mailcow server.

### [Set-MHDomainAdmin](Set-MHDomainAdmin.md)
Updates one or more domain admin user accounts.

### [Set-MHDomainAdminAcl](Set-MHDomainAdminAcl.md)
Updates one or more domain admin ACL (Access Control List) permissions.

### [Set-MHDomainFooter](Set-MHDomainFooter.md)
Update the footer of one or more domains.

### [Set-MHDomainTemplate](Set-MHDomainTemplate.md)
Updates one or more domain templates.

### [Set-MHFail2BanConfig](Set-MHFail2BanConfig.md)
Updates the fail2ban configuration of the mailcow server.

### [Set-MHForwardingHost](Set-MHForwardingHost.md)
Updates one or more forwarding host configurations.

### [Set-MHIdPGenericOIDC](Set-MHIdPGenericOIDC.md)
Updates settings for a generic OIDC auth source as an external identity provider in mailcow.

### [Set-MHIdPKeycloak](Set-MHIdPKeycloak.md)
Updates settings for a Keycloak auth source as an external identity provider in mailcow.

### [Set-MHIdpLdap](Set-MHIdpLdap.md)
Updates settings for a LDAP auth source as an external identity provider in mailcow.

### [Set-MHMailbox](Set-MHMailbox.md)
Update settings for one or more mailboxes.

### [Set-MHMailboxCustomAttribute](Set-MHMailboxCustomAttribute.md)
Updates custom attributes for one or more mailboxes.

### [Set-MHMailboxPushover](Set-MHMailboxPushover.md)
Updates Pushover notification settings for one or more mailboxes.

### [Set-MHMailboxQuarantineNotification](Set-MHMailboxQuarantineNotification.md)
Updates the quarantine notfication interval for one or more mailboxes.

### [Set-MHMailboxQuarantineNotificationCategory](Set-MHMailboxQuarantineNotificationCategory.md)
Updates the quarantine notfication interval for one or more mailboxes.

### [Set-MHMailboxSpamScore](Set-MHMailboxSpamScore.md)
Updates the spam score for one or more mailboxes.

### [Set-MHMailboxTaggedMailHandling](Set-MHMailboxTaggedMailHandling.md)
Updates plus-tagged mail handling for one or more mailboxes.

### [Set-MHMailboxTemplate](Set-MHMailboxTemplate.md)
Updates one or more mailbox templates.

### [Set-MHMailboxTlsPolicy](Set-MHMailboxTlsPolicy.md)
Updates the TLS policy for incoming and outgoing connections for one or more mailboxes.

### [Set-MHMailboxUserACL](Set-MHMailboxUserACL.md)
Updates the ACL (Access Control List) for one or more mailboxes.

### [Set-MHMailcowHelperConfig](Set-MHMailcowHelperConfig.md)
Saves settings to a MailcowHelper config file.

### [Set-MHMtaSts](Set-MHMtaSts.md)
Updates the MTS-STS policy for one or more domains.

### [Set-MHOauthClient](Set-MHOauthClient.md)
Updates an OAuth client configuration on the mailcow server.

### [Set-MHPasswordNotification](Set-MHPasswordNotification.md)
Updates the password reset notification settings on the mailcow server.

### [Set-MHPasswordPolicy](Set-MHPasswordPolicy.md)
Updates the mailcow password policy.

### [Set-MHQuotaNotification](Set-MHQuotaNotification.md)
Updates the quota notification mail configuration.

### [Set-MHRateLimit](Set-MHRateLimit.md)
Updates the rate limit for one or more mailboxes or domains.

### [Set-MHResource](Set-MHResource.md)
Updates one or mre mailcow resource accounts.

### [Set-MHRoutingRelayHost](Set-MHRoutingRelayHost.md)
Updates one or more relay host configurations.

### [Set-MHRoutingTransport](Set-MHRoutingTransport.md)
Updates one or more transport map configurations.

### [Set-MHRspamdSetting](Set-MHRspamdSetting.md)
Updates one or more Rspamd rules.

### [Set-MHSieveFilter](Set-MHSieveFilter.md)
Updates one or more admin defined Sieve filters for a user mailbox.

### [Set-MHSieveGlobalFilter](Set-MHSieveGlobalFilter.md)
Updates a global Sieve filter script.

### [Set-MHSyncJob](Set-MHSyncJob.md)
Updates a sync job configuration on the mailcow server.

### [Set-MHTlsPolicyMap](Set-MHTlsPolicyMap.md)
Updates one or more TLS policy map overrides.

### [Test-MHMailboxPushover](Test-MHMailboxPushover.md)
Test Pushover notification settings for one or more Mailcow mailboxes.

