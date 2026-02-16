---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AddressRewriteBccMap.md
schema: 2.0.0
---

# Set-MHAddressRewriteBccMap

## SYNOPSIS
Updates one or more BCC maps.

## SYNTAX

```
Set-MHAddressRewriteBccMap [-Id] <Int32[]> [-BccDestination <MailAddress>] [-Enable]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates one or more BCC maps.
BCC maps are used to silently forward copies of all messages to another address.
A recipient map type entry is used, when the local destination acts as recipient of a mail.
Sender maps conform to the same principle.
The local destination will not be informed about a failed delivery.

## EXAMPLES

### EXAMPLE 1
```
Set-MHAddressRewriteBccMap -Id 15 -BccDestination "user2@example.com"
```

Sets the BCC destiontion to "user2@example.com" for the BCC map with ID 15.

## PARAMETERS

### -BccDestination
The Bcc target mail address.

```yaml
Type: MailAddress
Parameter Sets: (All)
Aliases: Target

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enable
By default new BCC maps are always enabled.
To create a new BCC map in disabled state, specify "-Enable:$false".

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
The mail address or the The name of the domain for which to edit a BCC map.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases: BccMapId

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

### System.Int32[]
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AddressRewriteBccMap.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AddressRewriteBccMap.md)

