---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-DomainAntiSpamPolicy.md
schema: 2.0.0
---

# Get-MHDomainAntiSpamPolicy

## SYNOPSIS
Get blacklist or whitelist policies for a domain.

## SYNTAX

```
Get-MHDomainAntiSpamPolicy [[-Identity] <String[]>] [-ListType] <String> [-Raw]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get blacklist or whitelist policies for a domain.

## EXAMPLES

### EXAMPLE 1
```
Get-MHDomainAntiSpamPolicy -ListType Whitelist
```

Returns whitelist policies for all domains.

### EXAMPLE 2
```
Get-MHDomainAntiSpamPolicy -Domain "example.com" -ListType Blacklist
```

Returns blacklits policies for domain "example.com".

## PARAMETERS

### -Identity
The name of the domain for which to get the AntiSpam policy.

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

### -ListType
Either blacklist or whitelist.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-DomainAntiSpamPolicy.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-DomainAntiSpamPolicy.md)

