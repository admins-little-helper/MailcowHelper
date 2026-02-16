---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Domain.md
schema: 2.0.0
---

# Get-MHDomain

## SYNOPSIS
Get information about one or more domains registered on the mailcow server.

## SYNTAX

```
Get-MHDomain [[-Identity] <String[]>] [[-Tag] <String[]>] [-Raw] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Get information about one or more domains registered on the mailcow server.

## EXAMPLES

### EXAMPLE 1
```
Get-MHDomain
```

Return information for all domains.

### EXAMPLE 2
```
Get-MHDomain -Domain "example.com"
```

Returns information for domain "example.com".

### EXAMPLE 3
```
Get-MHDomain -Tag "MyTag"
```

Returns information for all domais tagged with "MyTag".

## PARAMETERS

### -Identity
The name of the domain for which to get information.
By default, information for all domains are returned.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Domain

Required: False
Position: 1
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
Position: 3
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tag
A tag to filter the result on.
This is only relevant if parameter "Identity" is not specified or if it is set to value "All" to return all domains.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]
## OUTPUTS

### PSCustomObject
## NOTES
Author: Dieter Koch
Email: diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Domain.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Domain.md)

