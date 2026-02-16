---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-Resource.md
schema: 2.0.0
---

# New-MHResource

## SYNOPSIS
Adds one or more resource accounts on a mailcow server.

## SYNTAX

### BookingShowBusyWhenBooked (Default)
```
New-MHResource [-Name] <String[]> [-Domain] <String> [-Type] <String> [-BookingShowBusyWhenBooked] [-Enable]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### BookingShowAlwaysFree
```
New-MHResource [-Name] <String[]> [-Domain] <String> [-Type] <String> [-BookingShowAlwaysFree] [-Enable]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### BookingCustomLimit
```
New-MHResource [-Name] <String[]> [-Domain] <String> [-Type] <String> [[-BookingCustomLimit] <Int32>] [-Enable]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Adds one or more resource accounts on a mailcow server.

## EXAMPLES

### EXAMPLE 1
```
New-MHResource
```

Returns all resource accounts on a mailcow server.

## PARAMETERS

### -BookingCustomLimit
Allow the specified number of bookings only.

```yaml
Type: Int32
Parameter Sets: BookingCustomLimit
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -BookingShowAlwaysFree
Show resource always as free.

```yaml
Type: SwitchParameter
Parameter Sets: BookingShowAlwaysFree
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -BookingShowBusyWhenBooked
Show busy when resource is booked.

```yaml
Type: SwitchParameter
Parameter Sets: BookingShowBusyWhenBooked
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Domain
The domain in which the resource account should be created.

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

### -Enable
Enable or disable the resource account.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the new resource account.
Will be used as the user part for the mail address.

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

### -Type
The resource type.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
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

### Nothing
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-Resource.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-Resource.md)

