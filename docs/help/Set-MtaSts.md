---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MtaSts.md
schema: 2.0.0
---

# Set-MHMtaSts

## SYNOPSIS
Updates the MTS-STS policy for one or more domains.

## SYNTAX

```
Set-MHMtaSts [-Identity] <String[]> [[-Version] <String>] [[-Mode] <String>] [-MxServer] <String[]>
 [-MaxAge] <Int32> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates the MTS-STS policy for one or more domains.
There can only be one MTA-STS policy per domain.
Refer to the mailcow documentation for more information.

## EXAMPLES

### EXAMPLE 1
```
Set-MHMtaSts -Domain "example.com" -Mode Enforce -MxServer 1.2.3.4, 5.6.7.8
```

Update the MTA-STS policy for domain "example.com" in enforce mode with two MX servers.

## PARAMETERS

### -Identity
The name of the domain for which to add a MTA-STS policy.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Domain

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -MaxAge
Time in seconds that receiving mail servers may cache this policy until refetching.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: 86400
Accept pipeline input: False
Accept wildcard characters: False
```

### -Mode
The MTA-STS mode to use.
Valid options are:
Enforce, Testing, None

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Enforce
Accept pipeline input: False
Accept wildcard characters: False
```

### -MxServer
The MxServer to use.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
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

### -Version
The MTA-STS version.
Only STSv1 is available.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: STSv1
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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MtaSts.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MtaSts.md)

