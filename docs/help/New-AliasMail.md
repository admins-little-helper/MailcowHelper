---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-AliasMail.md
schema: 2.0.0
---

# New-MHAliasMail

## SYNOPSIS
Add an alias mail address.

## SYNTAX

### DestinationMailbox
```
New-MHAliasMail [-Identity] <MailAddress> [[-Destination] <MailAddress[]>] [-Enable] [-Internal] [-SOGoVisible]
 [[-PublicComment] <String>] [[-PrivateComment] <String>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### DestinationDiscard
```
New-MHAliasMail [-Identity] <MailAddress> [-SilentlyDiscard] [-Enable] [-Internal] [-SOGoVisible]
 [[-PublicComment] <String>] [[-PrivateComment] <String>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### DestinationSpam
```
New-MHAliasMail [-Identity] <MailAddress> [-LearnAsSpam] [-Enable] [-Internal] [-SOGoVisible]
 [[-PublicComment] <String>] [[-PrivateComment] <String>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### DestinationHam
```
New-MHAliasMail [-Identity] <MailAddress> [-LearnAsHam] [-Enable] [-Internal] [-SOGoVisible]
 [[-PublicComment] <String>] [[-PrivateComment] <String>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Add an alias mail address.

## EXAMPLES

### EXAMPLE 1
```
New-MHMailAlias -Alias "alias@example.com" -Destination "mailbox@example.com" -SOGoVisible
```

Creates an alias "alias@example.com" for mailbox "mailbox@example.com".
The alias will be visible for the user in SOGo.

### EXAMPLE 2
```
New-MHMailAlias -Alias "spam@example.com" -Destination "mailbox@example.com" -LearnAsSpam
```

Creates an alias "spam@example.com" for mailbox "mailbox@example.com".
Mails sent to the new alias will be treated as spam.

### EXAMPLE 3
```
New-MHMailAlias -Alias "groupA@example.com" -Destination "user1@example.com", "user2@example.com"
```

This creates an alias that acts like a distribution group because mails to the alias are forwarded to two mailboxes.

## PARAMETERS

### -Destination
The destination mail address(es) for the new alias.
Specifying multiple destination addresses basically creates a distribution list.

```yaml
Type: MailAddress[]
Parameter Sets: DestinationMailbox
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enable
Enable or disable the new alias.
By default the new alias address is enabled.
To create a disable alias use "-Enable:$false".

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Identity
The new alias mail address to create.

```yaml
Type: MailAddress
Parameter Sets: (All)
Aliases: Alias

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Internal
Internal aliases are only accessible from the own domain or alias domains.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -LearnAsHam
All mails sent to the alias are treated as "ham" (whitelisted).

```yaml
Type: SwitchParameter
Parameter Sets: DestinationHam
Aliases:

Required: False
Position: 5
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -LearnAsSpam
All mails sent to the alias are treated as spam (blacklisted).

```yaml
Type: SwitchParameter
Parameter Sets: DestinationSpam
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrivateComment
Specify a private comment.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
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

### -PublicComment
Specify a public comment.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SilentlyDiscard
Silently discard mail messages sent to the alias address.

```yaml
Type: SwitchParameter
Parameter Sets: DestinationDiscard
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SOGoVisible
Make the new alias visible ein SOGo.

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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-AliasMail.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-AliasMail.md)

