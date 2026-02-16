---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailcowHelperConfig.md
schema: 2.0.0
---

# Set-MHMailcowHelperConfig

## SYNOPSIS
Saves settings to a MailcowHelper config file.

## SYNTAX

```
Set-MHMailcowHelperConfig [[-Path] <FileInfo>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Saves settings to a MailcowHelper config file.
This allows to re-use previously saved settings like mailcow servername, API key or argument completer configuration.

## EXAMPLES

### EXAMPLE 1
```
Set-MHMailcowHelperConfig
```

Saves settings to the default MailcowHelper config file in $env:USERPROFILE\.MailcowHelper.json

## PARAMETERS

### -Path
The full path to a MailcowHelper settings file (a JSON file).

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases: FilePath

Required: False
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

### Nothing
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailcowHelperConfig.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailcowHelperConfig.md)

