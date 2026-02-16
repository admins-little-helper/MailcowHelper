---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-DomainAdmin.md
schema: 2.0.0
---

# Get-MHDomainAdmin

## SYNOPSIS
Get information about one or more domain admins.

## SYNTAX

```
Get-MHDomainAdmin [[-Identity] <String[]>] [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get information about one or more domain admins.

## EXAMPLES

### EXAMPLE 1
```
Get-MHDomainAdmin
```

Returns information for all domain admins.

### EXAMPLE 2
```
Get-MHDomainAdmin -Identity "MyDomainAdmin"
```

Returns informatin for user with name "MyDomainAdmin".

## PARAMETERS

### -Identity
The username for which to return information.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: DomainAdmin

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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-DomainAdmin.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-DomainAdmin.md)

