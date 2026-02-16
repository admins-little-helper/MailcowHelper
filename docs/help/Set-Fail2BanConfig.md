---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-Fail2BanConfig.md
schema: 2.0.0
---

# Set-MHFail2BanConfig

## SYNOPSIS
Updates the fail2ban configuration of the mailcow server.

## SYNTAX

```
Set-MHFail2BanConfig [[-BanTime] <Int32>] [-BanTimeIncrement] [[-MaxBanTime] <Int32>] [[-MaxAttempts] <Int32>]
 [[-RetryWindow] <Int32>] [[-NetbanIpv4] <Int32>] [[-NetbanIpv6] <Int32>] [[-BlackListIpAddress] <IPNetwork[]>]
 [[-WhiteListIpAddress] <IPNetwork[]>] [[-WhiteListHostname] <String[]>] [[-ListOperation] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates the fail2ban configuration of the mailcow server.

## EXAMPLES

### EXAMPLE 1
```
Set-MHFail2BanConfig -BanTime 900 -BanTimeIncrement
```

This will set the ban time to 900 seconds and enable the ban time imcrement.

## PARAMETERS

### -BanTime
Specify for how many seconds to ban a source ip.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -BanTimeIncrement
Enable or disable the ban time increment.

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

### -BlackListIpAddress
Specify an ip address or ip network to blacklist.

```yaml
Type: IPNetwork[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ListOperation
Specify an action to execute for the list record.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: Append
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxAttempts
The maximum number of attempts, before an ip gets banned.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxBanTime
The maximum ban time in seconds.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetbanIpv4
IPv4 subnet size to apply ban on (8-32).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetbanIpv6
IPv6 subnet size to apply ban on (8-128).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 0
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

### -RetryWindow
The number of seconds of within failed attempts need to occur to be counted.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhiteListHostname
Specify a hostname to whitelist.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhiteListIpAddress
Specify an ip address or ip network to whitelist.

```yaml
Type: IPNetwork[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-Fail2BanConfig.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-Fail2BanConfig.md)

