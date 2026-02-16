---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-SieveGlobalFilter.md
schema: 2.0.0
---

# Get-MHSieveGlobalFilter

## SYNOPSIS
Return the global Sieve filter script.

## SYNTAX

```
Get-MHSieveGlobalFilter [[-FilterType] <Object>] [-Raw] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Return the global Sieve filter script for the specified type.

## EXAMPLES

### EXAMPLE 1
```
Get-MHSieveGlobalFilter -All
```

Returns the global pre- and post filter Sieve scripts.

### EXAMPLE 2
```
Get-MHSieveGlobalFilter -PreFilter
```

Returns the global prefilter Sieve script.

### EXAMPLE 3
```
Get-MHSieveGlobalFilter -PostFilter
```

Returns the global postfilter Sieve script.

## PARAMETERS

### -FilterType
The type of filter to return.
Valid values are:
All, PreFilter, PostFilter

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: All
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

### Nothing
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-SieveGlobalFilter.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-SieveGlobalFilter.md)

