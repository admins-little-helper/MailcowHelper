---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-DkimKey.md
schema: 2.0.0
---

# New-MHDkimKey

## SYNOPSIS
Adds a DKIM key for a domain.

## SYNTAX

```
New-MHDkimKey [-Domain] <String[]> [[-DkimSelector] <String>] [[-KeySize] <Int32>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Adds a DKIM key for a domain.

## EXAMPLES

### EXAMPLE 1
```
New-MHDkimKey -Domain "example.com" -DkimSelector "dkim2026" -KeySize 2048
```

Adds a new DKIM key for domain "example.com" with DKIM selector name "dkim2026" and a keysize of 2048.

### EXAMPLE 2
```
(Get-Domain).DomainName | New-MHDkimKey
```

Creates a new DKIM key for each mailcow domain using the default options.

## PARAMETERS

### -DkimSelector
The DKIM selector name.
By defaults set to "dkim".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Dkim
Accept pipeline input: False
Accept wildcard characters: False
```

### -Domain
The name of the domain for which to create a DKIM key.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -KeySize
The keysize for the DKIM key.
By defaults set to 2096.
Allowed values are 1024, 2024, 4096, 8192.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 2096
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

### System.String[]
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-DkimKey.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-DkimKey.md)

