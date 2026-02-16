---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-RoutingRelayHost.md
schema: 2.0.0
---

# New-MHRoutingRelayHost

## SYNOPSIS
Creates a relay host (sender-dependent transport) configuration on the mailcow server.

## SYNTAX

```
New-MHRoutingRelayHost [-Hostname] <String[]> [[-Port] <Int32>] [-Username] <String> [-Password] <SecureString>
 [-Enable] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a relay host (sender-dependent transport) configuration on the mailcow server.

Define sender-dependent transports which can be set in a domains configuration.
The transport service is always "smtp:" and will therefore try TLS when offered.
Wrapped TLS (SMTPS) is not supported.
A users individual outbound TLS policy setting is taken into account.
Affects selected domains including alias domains.

## EXAMPLES

### EXAMPLE 1
```
New-MHRoutingRelayHost -Hostname "mail.example.com" -Username "user123@example.com"
```

Add relay host "mail.example.com" with username "User123".
The password will be requested interactivly.

## PARAMETERS

### -Enable
Enable or disable the relay host.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hostname
The hostname of the relay host

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

### -Password
The password for the login on the relay host.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
The port to use.
Defaults to port 25.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 25
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

### -Username
The username for the login on the relay host.

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

### System.String[]
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-RoutingRelayHost.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-RoutingRelayHost.md)

