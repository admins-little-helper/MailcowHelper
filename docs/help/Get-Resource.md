---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Resource.md
schema: 2.0.0
---

# Get-MHResource

## SYNOPSIS
Return information about one or more resource accounts.

## SYNTAX

```
Get-MHResource [[-Identity] <MailAddress[]>] [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Return information about one or more resource accounts.

## EXAMPLES

### EXAMPLE 1
```
Get-MHResource -Identity "resourceABC@example.com"
```

Returns information for resource with mail address "resourceABC@example.com".

### EXAMPLE 2
```
Get-MHResource
```

Returns information for all resource accounts on a mailcow server.

## PARAMETERS

### -Identity
The mail address of the resource for which to get information.
If omitted, all resources are returned.

```yaml
Type: MailAddress[]
Parameter Sets: (All)
Aliases: Resource

Required: False
Position: 1
Default value: None
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

### System.Net.Mail.MailAddress[]
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Resource.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Resource.md)

