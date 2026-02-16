---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-AddressRewriteBccMap.md
schema: 2.0.0
---

# Remove-MHAddressRewriteBccMap

## SYNOPSIS
Removes a BCC map.

## SYNTAX

```
Remove-MHAddressRewriteBccMap [-Id] <Int32[]> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Removes a BCC map.
BCC maps are used to silently forward copies of all messages to another address.
A recipient map type entry is used, when the local destination acts as recipient of a mail.
Sender maps conform to the same principle.
The local destination will not be informed about a failed delivery.

## EXAMPLES

### EXAMPLE 1
```
Remove-MHAddressRewriteBccMap -Id 1
```

Removes BCC map with ID 1.

## PARAMETERS

### -Id
Id number of BCC map to remove.

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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-AddressRewriteBccMap.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-AddressRewriteBccMap.md)

