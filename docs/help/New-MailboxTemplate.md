---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-MailboxTemplate.md
schema: 2.0.0
---

# New-MHMailboxTemplate

## SYNOPSIS
Create a new mailbox template.

## SYNTAX

### DefaultOptions (Default)
```
New-MHMailboxTemplate [-Name] <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### IndividualSettings
```
New-MHMailboxTemplate [-Name] <String> [[-MailboxQuota] <Int32>] [[-Tag] <String[]>]
 [[-TaggedMailHandler] <String>] [[-QuarantineNotification] <String>] [[-QuarantineCategory] <String>]
 [[-RateLimitValue] <Int32>] [[-RateLimitFrame] <String>] [[-ActiveState] <MailcowHelperMailboxActiveState>]
 [-ForcePasswordUpdate] [-EnforceTlsIn] [-EnforceTlsOut] [-SogoAccess] [-ImapAccess] [-Pop3Access]
 [-SmtpAccess] [-SieveAccess] [-EasAccess] [-DavAccess] [-AclManageAppPassword] [-AclDelimiterAction]
 [-AclResetEasDevice] [-AclPushover] [-AclQuarantineAction] [-AclQuarantineAttachment]
 [-AclQuarantineNotification] [-AclQuarantineNotificationCategory] [-AclSOGoProfileReset] [-AclTemporaryAlias]
 [-AclSpamPolicy] [-AclSpamScore] [-AclSyncJob] [-AclTlsPolicy] [-AclPasswordReset]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Create a new mailbox template.
A mailbox template can either be specified as a default template for a domain.
Or you can select a template when creating a new mailbox to inherit some properties from the template.

## EXAMPLES

### EXAMPLE 1
```
New-MHMailboxTemplate -Name "ExampleTemplate"
```

This creates a new mailbox template using default values for all parameters.

### EXAMPLE 2
```
New-MHMailboxTemplate -Name "ExampleTemplate" -MailboxQuota 10240 -RateLimitValue 5 -RateLimitFrame Minute
```

This creates a new mailbox template allowing a maximum of 10 GByte per mailbox and allowing maximum of 5 mails per minute.

## PARAMETERS

### -AclDelimiterAction
Allow Delimiter Action.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 21
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AclManageAppPassword
Allow to manage app passwords.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 20
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AclPasswordReset
Allow to reset the user password.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 34
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AclPushover
Allow Pushover.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 23
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AclQuarantineAction
Allow quarantine action.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 24
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AclQuarantineAttachment
Allow quarantine attachement.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 25
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AclQuarantineNotification
Allow to change quarantine notification.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 26
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AclQuarantineNotificationCategory
Allow to change quarantine notification category.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 27
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AclResetEasDevice
Allow to reset EAS device.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 22
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AclSOGoProfileReset
Allow to reset the SOGo profile.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 28
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AclSpamPolicy
Allow to manage SPAM policy.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 30
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AclSpamScore
Allow to manage SPAM score.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 31
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AclSyncJob
Allow to manage sync job.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 32
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AclTemporaryAlias
Allow to manage temporary alias.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 29
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AclTlsPolicy
Allow to manage TLS policy.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 33
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ActiveState
The mailbox state.
Valid values are 'Active', 'Inactive', 'DisallowLogin'.

```yaml
Type: MailcowHelperMailboxActiveState
Parameter Sets: IndividualSettings
Aliases:
Accepted values: Inactive, Active, DisallowLogin

Required: False
Position: 9
Default value: Active
Accept pipeline input: False
Accept wildcard characters: False
```

### -DavAccess
Enable or disable CalDAV/CardDav for the user.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 19
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -EasAccess
Enable or disable Exchange Active Sync for the user.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 18
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnforceTlsIn
Enforce TLS for incoming connections for this mailbox.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 11
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnforceTlsOut
Enforce TLS for outgoing connections from this mailbox.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 12
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ForcePasswordUpdate
Force a password change for the user on the next logon.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 10
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImapAccess
Enable or disable IMAP for the user.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 14
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -MailboxQuota
The mailbox quota limit in MiB.

```yaml
Type: Int32
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 2
Default value: 3072
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the mailbox template.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Pop3Access
Enable or disable POP3 for the user.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 15
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
The notification category.
'Rejected' includes mail that was rejected, while 'Junk folder' will notify a user about mails that were put into the junk folder.

```yaml
Type: String
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 6
Default value: Rejected
Accept pipeline input: False
Accept wildcard characters: False
```

### -QuarantineNotification
The notification interval.

```yaml
Type: String
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 5
Default value: Hourly
Accept pipeline input: False
Accept wildcard characters: False
```

### -RateLimitFrame
The rate limit unit.

```yaml
Type: String
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 8
Default value: Hour
Accept pipeline input: False
Accept wildcard characters: False
```

### -RateLimitValue
The rate limit value.

```yaml
Type: Int32
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 7
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -SieveAccess
Enable or disable Sieve for the user.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 17
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SmtpAccess
Enable or disable SMTP for the user.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 16
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SogoAccess
Enable or disable access to SOGo for the user.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 13
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tag
One or more tags to will be assigned to a mailbox.

```yaml
Type: String[]
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TaggedMailHandler
The action to execute for tagged mail.

```yaml
Type: String
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 4
Default value: Nothing
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

### Nothing
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-MailboxTemplate.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-MailboxTemplate.md)

