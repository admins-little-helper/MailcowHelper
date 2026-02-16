---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AliasDomain.md
schema: 2.0.0
---

# Get-MHAliasDomain

## SYNOPSIS
Get information about one or more alias-domains.

## SYNTAX

```
Get-MHAliasDomain [-Identity <String[]>] [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get information about one or more alias-domains.

## EXAMPLES

### EXAMPLE 1
```
Get-MHAliasDomain
```

Returns all alias-domains.

### EXAMPLE 2
```
Get-MHAliasDomain -Identity alias.example.com
```

Returns information for the alias-domain alias.example.com

## PARAMETERS

### -Identity
The name of the domain for which to get information.
If omitted, all alias domains are returned.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: AliasDomain

Required: False
Position: Named
Default value: All
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

### System.String[]
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AliasDomain.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AliasDomain.md)

