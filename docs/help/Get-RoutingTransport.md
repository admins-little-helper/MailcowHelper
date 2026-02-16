---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-RoutingTransport.md
schema: 2.0.0
---

# Get-MHRoutingTransport

## SYNOPSIS
Return transport map configuration.

## SYNTAX

```
Get-MHRoutingTransport [[-Id] <Int32[]>] [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Return transport map configuration.
A transport map entry overrules a sender-dependent transport map (RoutingRelayHost).

## EXAMPLES

### EXAMPLE 1
```
Get-MHRoutingTransport
```

Returns all transport map configurations.

### EXAMPLE 2
```
Get-MHRoutingTransport -Identity 7
```

Returns transport map configuration for transport map with ID 7.

## PARAMETERS

### -Id
The ID number of a specific transport map record.
If ommited, all configured transport map records are returned.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

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

### System.Int32[]
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-RoutingTransport.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-RoutingTransport.md)

