---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxUserACL.md
schema: 2.0.0
---

# Set-MHMailboxUserACL

## SYNOPSIS
Updates the ACL (Access Control List) for one or more mailboxes.

## SYNTAX

### DefaultSettings
```
Set-MHMailboxUserACL [-Identity] <MailAddress[]> [-ResetToDefault] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### IndividualSettings
```
Set-MHMailboxUserACL [-Identity] <MailAddress[]> [-ManageAppPassword] [-DelimiterAction] [-ResetEasDevice]
 [-Pushover] [-QuarantineAction] [-QuarantineAttachment] [-QuarantineNotification]
 [-QuarantineNotificationCategory] [-TemporaryAlias] [-SpamPolicy] [-SpamScore] [-TlsPolicy] [-PasswordReset]
 [-SyncJob] [-SOGoProfileReset] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates the ACL (Access Control List) for one or more mailboxes.

The cmdlet overwrites the entire ACL set for the mailbox.
Use with caution!

## EXAMPLES

### EXAMPLE 1
```
Set-MHMailboxUserACL -Identity "user@example.com" -ResetToDefault
```

Resets all ACL permissions for the mailbox to Mailcow defaults.

### EXAMPLE 2
```
Set-MHMailboxUserACL -Identity "user@example.com" -ManageAppPassword -SpamPolicy -TlsPolicy
```

Enables the specified ACL permissions for the mailbox.

### EXAMPLE 3
```
"one@example.com","two@example.com" | Set-MHMailboxUserACL -ResetToDefault
```

Resets ACL permissions for multiple mailboxes using pipeline input.

## PARAMETERS

### -DelimiterAction
Allows the user to manage delimiter actions.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Identity
The mail address of the mailbox for which ACL settings should be updated.

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

### -ManageAppPassword
Allows the user to manage application passwords.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 2
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PasswordReset
Allow to reset mailcow user password.
Not part of the default ACL.

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

### -Pushover
Allows the user to manage Pushover settings.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 5
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -QuarantineAction
Allows the user to perform quarantine actions.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 6
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -QuarantineAttachment
Allows the user to manage quarantine attachments.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 7
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -QuarantineNotification
Allows the user to modify quarantine notification settings.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 8
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -QuarantineNotificationCategory
Allows the user to modify quarantine notification categories.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 9
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResetEasDevice
Allows the user to reset EAS devices.

```yaml
Type: SwitchParameter
Parameter Sets: IndividualSettings
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResetToDefault
Resets all ACL permissions to their default values.

```yaml
Type: SwitchParameter
Parameter Sets: DefaultSettings
Aliases:

Required: True
Position: 2
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SOGoProfileReset
Allows the user to reset their SOGo profile.
Not part of the default ACL.

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

### -SpamPolicy
Allows the user to manage SPAM policy settings.

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

### -SpamScore
Allows the user to manage SPAM score settings.

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

### -SyncJob
Allows the user to manage sync jobs.
Not part of the default ACL.

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

### -TemporaryAlias
Allows the user to manage temporary aliases.

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

### -TlsPolicy
Allows the user to manage TLS policy settings.

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

## OUTPUTS

### System.Management.Automation.PSObject
## NOTES
This cmdlet overwrites all existing ACL settings.
Ensure you understand the implications before applying changes.

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxUserACL.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxUserACL.md)

