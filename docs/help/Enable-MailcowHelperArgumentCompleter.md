---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Enable-MailcowHelperArgumentCompleter.md
schema: 2.0.0
---

# Enable-MHMailcowHelperArgumentCompleter

## SYNOPSIS
Enables the MailcowHelper custom ArgumentCompleter for the specified item type.

## SYNTAX

### All (Default)
```
Enable-MHMailcowHelperArgumentCompleter [-All] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Individual
```
Enable-MHMailcowHelperArgumentCompleter [-Alias] [-AliasDomain] [-Domain] [-DomainAdmin] [-DomainTemplate]
 [-Mailbox] [-MailboxTemplate] [-Resource] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Enables the MailcowHelper custom ArgumentCompleter for the specified item type.
This module provides custom ArgumentCompleter for parameter expecting one of the following input types:
Alias, AliasDomain, Domain, DomainAdmin, Mailbox, Resource

## EXAMPLES

### EXAMPLE 1
```
Enable-MHMailcowHelperArgumentCompleter -All
```

Enables custom ArgumentCompleter for all item types.

### EXAMPLE 2
```
Enable-MHMailcowHelperArgumentCompleter -Mailbox
```

Enables custom ArgumentCompleter for mailbox item type.

## PARAMETERS

### -Alias
Enables argument completer for Alias items.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: 1
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AliasDomain
Enables argument completer for AliasDomain items.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: 2
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -All
Enables argument completer for all items

```yaml
Type: SwitchParameter
Parameter Sets: All
Aliases:

Required: False
Position: 1
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Domain
Enables argument completer for Domain items.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DomainAdmin
Enables argument completer for AliasDoDomainAdminmain items.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DomainTemplate
Enables argument completer for DomainTemplate items.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: 5
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Mailbox
Enables argument completer for Mailbox items.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: 6
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -MailboxTemplate
Enables argument completer for MailboxTemplate items.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: 7
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

### -Resource
Enables argument completer for Resource items.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: 8
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Nothing
## OUTPUTS

### Nothing
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Enable-MailcowHelperArgumentCompleter.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Enable-MailcowHelperArgumentCompleter.md)

