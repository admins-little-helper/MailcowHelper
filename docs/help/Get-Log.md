---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Log.md
schema: 2.0.0
---

# Get-MHLog

## SYNOPSIS
Get mailcow server logs of the specified type.

## SYNTAX

```
Get-MHLog [-Logtype] <String> [[-Count] <Decimal>] [-Raw] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Get mailcow server logs of the specified type.

## EXAMPLES

### EXAMPLE 1
```
Get-MHLog -LogType "Acme" -Count 100
```

Get the last 100 records from the Acme log.

### EXAMPLE 2
```
Get-MHLog -LogType "Postfix"
```

Get records from the Postfix log.
By default the last 20 records are returned.

## PARAMETERS

### -Count
The number of logs records to return.
This always returns the latest (newest) log records.

```yaml
Type: Decimal
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 20
Accept pipeline input: False
Accept wildcard characters: False
```

### -Logtype
Specify the type of log to return.
Supported values are:
Acme, Api, Autodiscover, Dovecot, Netfilter, Postfix, RateLimited, Rspamd-History, Sogo, Watchdog

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
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
Position: 3
Default value: False
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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Log.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Log.md)

