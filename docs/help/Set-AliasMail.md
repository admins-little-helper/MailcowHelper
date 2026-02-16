---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AliasMail.md
schema: 2.0.0
---

# Set-MHAliasMail

## SYNOPSIS
Update a mail alias.

## SYNTAX

### DestinationMailbox
```
Set-MHAliasMail [-Identity] <MailAddress> [[-Destination] <MailAddress[]>] [-Enable] [-Internal] [-SOGoVisible]
 [[-PublicComment] <String>] [[-PrivateComment] <String>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### DestinationDiscard
```
Set-MHAliasMail [-Identity] <MailAddress> [-SilentlyDiscard] [-Enable] [-Internal] [-SOGoVisible]
 [[-PublicComment] <String>] [[-PrivateComment] <String>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### DestinationSpam
```
Set-MHAliasMail [-Identity] <MailAddress> [-LearnAsSpam] [-Enable] [-Internal] [-SOGoVisible]
 [[-PublicComment] <String>] [[-PrivateComment] <String>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### DestinationHam
```
Set-MHAliasMail [-Identity] <MailAddress> [-LearnAsHam] [-Enable] [-Internal] [-SOGoVisible]
 [[-PublicComment] <String>] [[-PrivateComment] <String>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Update a mail alias.

## EXAMPLES

### EXAMPLE 1
```
Set-MHMailAlias -Alias "alias@example.com" -Destination "mailbox@example.com" -SOGoVisible
```

Creates an alias "alias@example.com" for mailbox "mailbox@example.com".
The alias will be visible for the user in SOGo.

### EXAMPLE 2
```
Set-MHMailAlias -Alias "spam@example.com" -Destination "mailbox@example.com" LearnAsSpam
```

Creates an alias "spam@example.com" for mailbox "mailbox@example.com".
Mails sent to the new alias will be treated as spam.

## PARAMETERS

### -Destination
The destination mail address for the alias.

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
Enalbe or disable the alias address.

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
The alias mail address to update.

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
If specified, all mails sent to the alias are treated as "ham" (whitelisted).

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
If specified, all mails sent to the alias are treated as spam (blacklisted).

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
If specified, silently discard mail messages sent to the alias address.

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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AliasMail.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AliasMail.md)

