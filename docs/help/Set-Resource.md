---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-Resource.md
schema: 2.0.0
---

# Set-MHResource

## SYNOPSIS
Updates one or mre mailcow resource accounts.

## SYNTAX

### BookingShowBusyWhenBooked (Default)
```
Set-MHResource [-Identity] <MailAddress[]> [[-Description] <String>] [[-Type] <String>]
 [-BookingShowBusyWhenBooked] [-Enable] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### BookingShowAlwaysFree
```
Set-MHResource [-Identity] <MailAddress[]> [[-Description] <String>] [[-Type] <String>]
 [-BookingShowAlwaysFree] [-Enable] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### BookingCustomLimit
```
Set-MHResource [-Identity] <MailAddress[]> [[-Description] <String>] [[-Type] <String>]
 [[-BookingCustomLimit] <Int32>] [-Enable] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Updates one or mre mailcow resource accounts.

## EXAMPLES

### EXAMPLE 1
```
Set-MHResource -Identity "resource123@example.com" -Description "Calendar resource"
```

Set the description of resource "resource123@example.com".

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

### -Description
Set the description of the resource account.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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

### -Identity
The mail address of the resource account to update.

```yaml
Type: MailAddress[]
Parameter Sets: (All)
Aliases: Resource

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
Set the resource type.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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

### System.Net.Mail.MailAddress[]
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-Resource.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-Resource.md)

