---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailboxSpamScore.md
schema: 2.0.0
---

# Get-MHMailboxSpamScore

## SYNOPSIS
Get the spam score for one ore more mailboxes.

## SYNTAX

```
Get-MHMailboxSpamScore [[-Identity] <MailAddress[]>] [-Raw] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Get the spam score for one ore more mailboxes.

## EXAMPLES

### EXAMPLE 1
```
Get-MHMailboxSpamScore
```

Return spam score information for all mailboxes.

### EXAMPLE 2
```
Get-MHMailboxSpamScore -Identity "user1@example.com"
```

Return spam score information for "user1@example.com".

## PARAMETERS

### -Identity
The mail address for which to get information.

```yaml
Type: MailAddress[]
Parameter Sets: (All)
Aliases: Mailbox

Required: False
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

### -Raw
Return the result in raw format as returned by Invoke-WebRequest.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: False
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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailboxSpamScore.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailboxSpamScore.md)

