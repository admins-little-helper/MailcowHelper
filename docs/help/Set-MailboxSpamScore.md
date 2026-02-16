---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxSpamScore.md
schema: 2.0.0
---

# Set-MHMailboxSpamScore

## SYNOPSIS
Updates the spam score for one or more mailboxes.

## SYNTAX

```
Set-MHMailboxSpamScore [-Identity] <MailAddress[]> [[-SpamScoreLow] <Int32>] [[-SpamScoreHigh] <Int32>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates the spam score for one or more mailboxes.

## EXAMPLES

### EXAMPLE 1
```
Set-MHMailboxSpamScore -Identity "user123@example.com" -SpamScoreLow 7 -SpamScoreHigh 14
```

Set the low and high spam score values for mailbox "user123@example.com".

## PARAMETERS

### -Identity
The mail address of the mailbox for which to set the spam score.

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

### -SpamScoreHigh
The high spam score value.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 15
Accept pipeline input: False
Accept wildcard characters: False
```

### -SpamScoreLow
The low spam score value.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 8
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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxSpamScore.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxSpamScore.md)

