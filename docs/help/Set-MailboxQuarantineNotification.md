---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxQuarantineNotification.md
schema: 2.0.0
---

# Set-MHMailboxQuarantineNotification

## SYNOPSIS
Updates the quarantine notfication interval for one or more mailboxes.

## SYNTAX

```
Set-MHMailboxQuarantineNotification [-Identity] <MailAddress[]> [-QuaranantineNotification] <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates the quarantine notfication interval for one or more mailboxes.

## EXAMPLES

### EXAMPLE 1
```
Set-MHMailboxQuarantineNotification -Identity "user123@example.com" -QuaranantineNotification "Daily"
```

Set the notification period to "Daily" for the mailbox of the user "user123@example.com".

## PARAMETERS

### -Identity
The mail address of the mailbox for which to set the quarantine notification interval.

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

### -QuaranantineNotification
The notificatoin interval.
Valid values are Never, Hourly, Daily, Weekly.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxQuarantineNotification.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxQuarantineNotification.md)

