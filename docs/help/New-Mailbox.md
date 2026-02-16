---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-Mailbox.md
schema: 2.0.0
---

# New-MHMailbox

## SYNOPSIS
Add one or more mailboxes.

## SYNTAX

```
New-MHMailbox [-Identity] <MailAddress[]> [[-Name] <String>] [[-AuthSource] <String>]
 [-Password] <SecureString> [[-ActiveState] <MailcowHelperMailboxActiveState>] [[-MailboxQuota] <Int32>]
 [[-Tag] <String[]>] [-ForcePasswordUpdate] [-EnforceTlsIn] [-EnforceTlsOut] [[-Template] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Add one or more mailboxes.

## EXAMPLES

### EXAMPLE 1
```
New-MHMailbox -Identity "user123@example.com" -Template "MyCustomMailboxTemplate"
```

Creates a new mailbox for "user123@example.com".
The mailbox is configured based on settings from a template.

### EXAMPLE 2
```
New-MHMailbox -Identity "user456@example.com" -ActiveState DisallowLogin
```

Creates a new mailbox for "user456@example.com".
The mailbox is set to disallow login.

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
The authentcation source to use.
Default is "mailcow".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Mailcow
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnforceTlsIn
Enforce TLS for incoming connections for this mailbox.

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

### -EnforceTlsOut
Enforce TLS for outgoing connections from this mailbox.

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

### -ForcePasswordUpdate
Force a password change for the user on the next logon.

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

### -Identity
The mail address for the new mailbox.

```yaml
Type: MailAddress[]
Parameter Sets: (All)
Aliases: Mailbox, PrimaryAddress, SmtpAddress

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
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
The name of the new mailbox.
If ommited the local part of the mail address is used.

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

Required: True
Position: 4
Default value: None
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

### -Tag
Add a tag that can be used for filtering

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

### -Template
The mailbox template to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-Mailbox.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-Mailbox.md)

