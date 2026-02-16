---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Disable-MailcowHelperArgumentCompleter.md
schema: 2.0.0
---

# Disable-MHMailcowHelperArgumentCompleter

## SYNOPSIS
Disables the MailcowHelper custom ArgumentCompleter for the specified item type.

## SYNTAX

### All (Default)
```
Disable-MHMailcowHelperArgumentCompleter [-All] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Individual
```
Disable-MHMailcowHelperArgumentCompleter [-Alias] [-AliasDomain] [-Domain] [-DomainAdmin] [-DomainTemplate]
 [-Mailbox] [-MailboxTemplate] [-Resource] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Disables the MailcowHelper custom ArgumentCompleter for the specified item type.
This module provides custom ArgumentCompleter for parameter expecting one of the following input types:
Alias, AliasDomain, Domain, DomainAdmin, Mailbox, Resource

## EXAMPLES

### EXAMPLE 1
```
Disable-MHMailcowHelperArgumentCompleter -All
```

Disables custom ArgumentCompleter for all item types.

### EXAMPLE 2
```
Disable-MHMailcowHelperArgumentCompleter -Mailbox
```

Disables custom ArgumentCompleter for mailbox item type.

## PARAMETERS

### -Alias
Disable argument completer for Alias items.

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
Disable argument completer for AliasDomain items.

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
Disable argument completer for all items

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
Disable argument completer for Domain items.

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
Disable argument completer for AliasDoDomainAdminmain items.

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
Disable argument completer for DomainTemplate items.

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
Disable argument completer for Mailbox items.

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
Disable argument completer for MailboxTemplate items.

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
Disable argument completer for Resource items.

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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Disable-MailcowHelperArgumentCompleter.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Disable-MailcowHelperArgumentCompleter.md)

