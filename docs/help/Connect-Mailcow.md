---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Connect-Mailcow.md
schema: 2.0.0
---

# Connect-MHMailcow

## SYNOPSIS
Connects to the specified mailcow server using the specified API key, or loads previously saved settings.

## SYNTAX

### ManualConfig (Default)
```
Connect-MHMailcow [-Computername] <String> [-ApiKey] <String> [[-ApiVersion] <String>]
 [-DisableArgumentCompleter] [-Insecure] [-SkipCertificateCheck] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### AutoConfig
```
Connect-MHMailcow [-LoadConfig] [[-Path] <FileInfo>] [-DisableArgumentCompleter]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Connects to the specified mailcow server using the specified API key, or loads previously saved settings.

This ensures that the specified API key is valid and stored in memory for sub-sequent function calls.
To clear the connection settings from memory, run "Disconnect-Mailcow".

## EXAMPLES

### EXAMPLE 1
```
Connect-MHMailcow -Computername mymailcow.example.com -ApiKey 12345-67890-ABCDE-FGHIJ-KLMNO
```

Connect to server mymailcow.example.com using the specified API key.
If the connection is successful, the mailcow server version is returned.

### EXAMPLE 2
```
Connect-MHMailcow -LoadConfig
```

Loads the config from the default config file ($env:USERPROFILE\.MailcowHelper.json on Windows,
env:HOME\.MailcowHelper.json on Unix) and uses the connection settings loaded.
If the connection is successful, the mailcow server version is returned.

## PARAMETERS

### -ApiKey
The API key to use for authentication.

```yaml
Type: String
Parameter Sets: ManualConfig
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiVersion
The API version to use.

```yaml
Type: String
Parameter Sets: ManualConfig
Aliases:

Required: False
Position: 3
Default value: V1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Computername
The mailcow server name to connect to.

```yaml
Type: String
Parameter Sets: ManualConfig
Aliases: Server, Hostname

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisableArgumentCompleter
Disable the MailcowHelper custom ArgumentCompleter completly.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Insecure
Use http instead of https.

```yaml
Type: SwitchParameter
Parameter Sets: ManualConfig
Aliases:

Required: False
Position: 5
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -LoadConfig
Loads the config from a file.

```yaml
Type: SwitchParameter
Parameter Sets: AutoConfig
Aliases:

Required: False
Position: 1
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
The path to the config file to load.

```yaml
Type: FileInfo
Parameter Sets: AutoConfig
Aliases: FilePath

Required: False
Position: 2
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

### -SkipCertificateCheck
Skips certificate validation checks.
This includes all validations such as expiration, revocation, trusted root authority, etc.

```yaml
Type: SwitchParameter
Parameter Sets: ManualConfig
Aliases:

Required: False
Position: 6
Default value: False
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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Connect-Mailcow.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Connect-Mailcow.md)

