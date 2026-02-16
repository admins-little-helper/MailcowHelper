---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AddressRewriteRecipientMap.md
schema: 2.0.0
---

# Get-MHAddressRewriteRecipientMap

## SYNOPSIS
Get one or more recipient map definitions.

## SYNTAX

```
Get-MHAddressRewriteRecipientMap [[-Id] <String[]>] [-Raw] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Get one or more recipient map definitions.
Recipient maps are used to replace the destination address on a message before it is delivered.

## EXAMPLES

### EXAMPLE 1
```
Get-MHAddressRewriteRecipientMap
```

Returns all recipient maps.

### EXAMPLE 2
```
Get-MHAddressRewriteRecipientMap -Identity 15
```

Returns recipient map with id 15.

## PARAMETERS

### -Id
Id number of recipient map to get information for.
If omitted, all recipient map definitions are returned.

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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AddressRewriteRecipientMap.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AddressRewriteRecipientMap.md)

