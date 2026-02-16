---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AddressRewriteBccMap.md
schema: 2.0.0
---

# Get-MHAddressRewriteBccMap

## SYNOPSIS
Get one or more BCC map definitions.

## SYNTAX

```
Get-MHAddressRewriteBccMap [[-Id] <String[]>] [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get one or more BCC map definitions.
BCC maps are used to silently forward copies of all messages to another address.
A recipient map type entry is used, when the local destination acts as recipient of a mail.
Sender maps conform to the same principle.
The local destination will not be informed about a failed delivery.

## EXAMPLES

### EXAMPLE 1
```
Get-MHAddressRewriteBccMap
```

Return all BCC maps.

### EXAMPLE 2
```
Get-MHAddressRewriteBccMap -Identity 15
```

Returns BCC map with id 15.

## PARAMETERS

### -Id
Id number of BCC map to get information for.
If omitted, all BCC map definitions are returned.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AddressRewriteBccMap.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AddressRewriteBccMap.md)

