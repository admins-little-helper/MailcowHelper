---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Test-MailboxPushover.md
schema: 2.0.0
---

# Test-MHMailboxPushover

## SYNOPSIS
Test Pushover notification settings for one or more Mailcow mailboxes.

## SYNTAX

```
Test-MHMailboxPushover [-Identity] <MailAddress[]> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Test Pushover notification settings for one or more Mailcow mailboxes.

## EXAMPLES

### EXAMPLE 1
```
Test-MHMailboxPushover -Identity "user@example.com"
```

Verifies Pushover notification settings for the specified mailbox.

## PARAMETERS

### -Identity
The mailbox (email address) for which Pushover settings should be verified.

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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Test-MailboxPushover.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Test-MailboxPushover.md)

