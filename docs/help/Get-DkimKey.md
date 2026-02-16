---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-DkimKey.md
schema: 2.0.0
---

# Get-MHDkimKey

## SYNOPSIS
Get the DKIM key for a specific domain or for all domains.

## SYNTAX

```
Get-MHDkimKey [[-Identity] <String[]>] [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get the DKIM key for a specific domain or for all domains.

## EXAMPLES

### EXAMPLE 1
```
Get-MHDkimKey
```

Returns DKIM keys for all domains.

### EXAMPLE 2
```
Get-MHDkimKey -Domain "example.com"
```

Returns DKIM key for the domain "example.com".

## PARAMETERS

### -Identity
Domain name to get DKIM key for.

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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-DkimKey.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-DkimKey.md)

