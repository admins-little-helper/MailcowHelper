---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-Mailbox.md
schema: 2.0.0
---

# Set-MHMailbox

## SYNOPSIS
Update settings for one or more mailboxes.

## SYNTAX

```
Set-MHMailbox [-Identity] <MailAddress[]> [[-Name] <String>] [[-AuthSource] <String>]
 [[-Password] <SecureString>] [[-ActiveState] <MailcowHelperMailboxActiveState>] [[-MailboxQuota] <Int32>]
 [[-Tag] <String[]>] [-SogoAccess] [-ImapAccess] [-Pop3Access] [-SmtpAccess] [-SieveAccess] [-EasAccess]
 [-DavAccess] [[-RelayHostId] <Int32>] [-ForcePasswordUpdate] [[-RecoveryEmail] <MailAddress>]
 [[-QuarantineNotification] <String>] [[-QuarantineCategory] <String>] [[-TaggedMailAction] <String>]
 [-EnforceTlsIn] [-EnforceTlsOut] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Update settings for one or more mailboxes.

## EXAMPLES

### EXAMPLE 1
```
Set-MHMailbox -Identity "john.doe@example.com" -Name "John Doe" -MailboxQuota 10240
```

Set the name for mailbox "john.doe@example.com" and also set the mailbox quota to 10 GByte.

### EXAMPLE 2
```
Set-MHMailbox -Identity "john.doe@example.com" -ForcePasswordUpdate
```

Force password change on next logon for user "john.doe@example.com".

### EXAMPLE 3
```
Set-MHMailbox -Identity "john.doe@example.com" -EasAccess:$false
```

Disable EAS protocol for the mailbox of user "john.doe@example.com".

### EXAMPLE 4
```
$DisabledMailboxes = (Get-ADUser -Filter {mail -like "*" -and Enabled -eq $false} -Properties mail).mail | Set-MHMailbox -ActiveState Inactive
```

In an environment where Active Directory/LDAP is used as identity provider for mailcow, the example above shows how to get all disabled user accounts
from Active Directory and send the output down the pipeline to the 'Set-MHMailbox' function to disable the mailbox in mailcow.

## PARAMETERS

### -ActiveState
The mailbox state.
Valid values are:
Active = Mails to the mail address are accepted, the account is enabled, so login is possible.
DisallowLogin = Mails to the mail address are accepted, the account is disabled, so login is denied.
Inactive = Mails to the mail address are rejected, the account is disabled, so login is denied.

```yaml
Type: MailcowHelperMailboxActiveState
Parameter Sets: (All)
Aliases:
Accepted values: Inactive, Active, DisallowLogin

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AuthSource
The authentication source to use.
Default is "mailcow".
Suppored values are: "mailcow", "LDAP", "Keycloak" and "Generic-OIDC".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DavAccess
Enable or disable CalDAV/CardDAV for the user.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -EasAccess
Enable or disable EAS (Exchange Active Sync) for the user.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnforceTlsIn
Enforce TLS for incoming connections.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 21
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnforceTlsOut
Enforce TLS for outgoing connections.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 22
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ForcePasswordUpdate
Force a password change for the user on the next logon.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Identity
The mail address of the mailbox to update.

```yaml
Type: MailAddress[]
Parameter Sets: (All)
Aliases: Mailbox

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ImapAccess
Enable or disable IMAP for the user.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -MailboxQuota
The mailbox quota in MB.
If ommitted, the domain default mailbox quota will be applied.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 3072
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The display name of the mailbox.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
The password for the new mailbox user.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Pop3Access
Enable or disable POP3 for the user.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -QuarantineCategory
The notificatoin category.
Valid values are Rejected, Junk folder, All categories.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 19
Default value: Rejected
Accept pipeline input: False
Accept wildcard characters: False
```

### -QuarantineNotification
The notificatoin interval.
Valid values are Never, Hourly, Daily, Weekly.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 18
Default value: Hourly
Accept pipeline input: False
Accept wildcard characters: False
```

### -RecoveryEmail
Specify an email address that will be used for password recovery.

```yaml
Type: MailAddress
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RelayHostId
Set a specific relay host.
Use 'Get-RoutingRelayHost' to get the configured relay hosts and their IDs.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -SieveAccess
Enable or disable Sieve for the user.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SmtpAccess
Enable or disable SMTP for the user.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SogoAccess
Direct forwarding to SOGo.
After logging in, the user is automatically redirected to SOGo.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tag
Add one or more tags to the mailbox, whicht can be used for filtering.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TaggedMailAction
Specify the action for tagged mail.
Valid values are: Subject, Subfolder, Nothing

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 20
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Net.Mail.MailAddress[]
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-Mailbox.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-Mailbox.md)

