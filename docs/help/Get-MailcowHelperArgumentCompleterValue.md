---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailcowHelperArgumentCompleterValue.md
schema: 2.0.0
---

# Get-MHMailcowHelperArgumentCompleterValue

## SYNOPSIS
Get values for the specified argument completer.

## SYNTAX

```
Get-MHMailcowHelperArgumentCompleterValue [-ItemType] <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Get values for the specified argument completer.
This function is used internally in the module to enable argument completion
on function parameters expecting one of the following input values:
Alias, AliasDomain, Domain, DomainAdmin, Mailbox, Resource

## EXAMPLES

### EXAMPLE 1
```
Get-MHMailcowHelperArgumentCompleterValue ItemType Domain
```

Returns all domain values available for argument completion.

## PARAMETERS

### -ItemType
One of the following types:
Alias, AliasDomain, Domain, DomainAdmin, Mailbox, Resource

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Nothing
## OUTPUTS

### System.String
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailcowHelperArgumentCompleterValue.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailcowHelperArgumentCompleterValue.md)

