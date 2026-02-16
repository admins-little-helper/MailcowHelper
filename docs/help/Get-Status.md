---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Status.md
schema: 2.0.0
---

# Get-MHStatus

## SYNOPSIS
Returns status information for the specified area for a mailcow server.

## SYNTAX

```
Get-MHStatus [[-Status] <String>] [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Returns status information for the specified area for a mailcow server.
Accepted values for status area are:
Containers, Host, Version, Vmail

## EXAMPLES

### EXAMPLE 1
```
Get-MHStatus -Status Containers
```

Returns status for the mailcow containers.

### EXAMPLE 2
```
Get-MHStatus -Status Host
```

Returns mailcow server host information.

### EXAMPLE 3
```
Get-MHStatus -Status Version
```

Returns the mailcow server version.

### EXAMPLE 4
```
Get-MHStatus -Status Vmail
```

Returns status for the mailcow vmail and the amount of used storage.

## PARAMETERS

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

### -Status
The area for which to get status information.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Version
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Status.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Status.md)

