---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-MailboxTag.md
schema: 2.0.0
---

# Remove-MHMailboxTag

## SYNOPSIS
Remove one or more tags from one or more mailboxes.

## SYNTAX

```
Remove-MHMailboxTag [-Identity] <MailAddress[]> [[-Tag] <String[]>] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Remove one or more tags from one or more mailboxes.

## EXAMPLES

### EXAMPLE 1
```
Remove-MHMailboxTag -Identity "user123@example.com" -Tag "MyTag"
```

Removes the tag "MyTag" from mailbox "user123@example.com".

### EXAMPLE 2
```
Get-MHMailbox -Tag "MyTag" | Remove-MHMailboxTag -Tag "MyTag"
```

Gets all mailboxes tagged with "MyTag" and removes that tag.

## PARAMETERS

### -Identity
The mail address of the mailbox from where to remove a tag.

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

### -Tag
The tag to remove.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-MailboxTag.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-MailboxTag.md)

