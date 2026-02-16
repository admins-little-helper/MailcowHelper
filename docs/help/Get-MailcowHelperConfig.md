---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailcowHelperConfig.md
schema: 2.0.0
---

# Get-MHMailcowHelperConfig

## SYNOPSIS
Reads settings form a MailcowHelper config file.

## SYNTAX

```
Get-MHMailcowHelperConfig [[-Path] <FileInfo>] [-Passthru] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Reads settings form a MailcowHelper config file.
This allows to re-use previously saved settings like mailcow servername, API key or argument completer configuration.
If the specified file or the default config file does not exist, default settings are returned.

## EXAMPLES

### EXAMPLE 1
```
Get-MHMailcowHelperConfig
```

Tries to read settings from the default MailcowHelper config file in $env:USERPROFILE\.MailcowHelper.json

## PARAMETERS

### -Passthru
If specified, returns the settings read from the file.
Otherwise the settings are only stored in the module session variable and are therefore only accessable by functions in the module.

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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailcowHelperConfig.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailcowHelperConfig.md)

