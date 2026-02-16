---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Admin.md
schema: 2.0.0
---

# Get-MHAdmin

## SYNOPSIS
Get information about one or more admin user accounts.

## SYNTAX

```
Get-MHAdmin [[-Identity] <String[]>] [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get information about one or more admin user accounts.

## EXAMPLES

### EXAMPLE 1
```
Get-MHAdmin
```

Returns all admin user accounts.

### EXAMPLE 2
```
Get-MHAdmin -Identity superadmin
```

Returns information about the admin user "superadmin".

## PARAMETERS

### -Identity
The username of the admin account for which to get information.
If omitted, all admin user accounts are returned.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Username

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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Admin.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Admin.md)

