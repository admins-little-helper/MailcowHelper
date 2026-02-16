---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxTaggedMailHandling.md
schema: 2.0.0
---

# Set-MHMailboxTaggedMailHandling

## SYNOPSIS
Updates plus-tagged mail handling for one or more mailboxes.

## SYNTAX

```
Set-MHMailboxTaggedMailHandling [-Identity] <MailAddress[]> [-Action] <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates plus-tagged mail handling for one or more mailboxes.

In subfolder: a new subfolder named after the tag will be created below INBOX ("INBOX/Newsletter").
In subject: the tags name will be prepended to the mails subject, example: "\[Newsletter\] My News".
Do nothing: no special handling for tagged mail.

Example for a tagged email address: me+Newsletter@example.org

## EXAMPLES

### EXAMPLE 1
```
Set-MHMailboxTaggedMailHandling -Identity "user123@example.com" -Action Subfolder
```

This will move tagged mails to a subfolder named after the tag.

### EXAMPLE 2
```
Set-MHMailboxTaggedMailHandling -Identity "user123@example.com" -Action Subject
```

This will prepand the the tags name to the subject of the mail.

### EXAMPLE 3
```
Set-MHMailboxTaggedMailHandling -Identity "user123@example.com" -Action Nothing
```

This will do nothing extra for plus-tagged mail.
Mail gets delivered to the inbox.

## PARAMETERS

### -Action
Specify the action for tagged mail.
Valid values are: Subject, Subfolder, Nothing

```yaml
Type: String
Parameter Sets: (All)
Aliases: TaggedMailAction, DelimiterAction

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Identity
The mail address of the mailbox for which to update plus-tagged mail handling.

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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxTaggedMailHandling.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxTaggedMailHandling.md)

