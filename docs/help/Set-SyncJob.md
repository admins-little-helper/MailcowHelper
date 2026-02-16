---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-SyncJob.md
schema: 2.0.0
---

# Set-MHSyncJob

## SYNOPSIS
Updates a sync job configuration on the mailcow server.

## SYNTAX

```
Set-MHSyncJob [-Id] <Int32> [[-Hostname] <String>] [[-Port] <Int32>] [[-Username] <MailAddress>]
 [[-Password] <SecureString>] [[-Encryption] <String>] [[-Interval] <Int32>] [[-TargetSubfolder] <String>]
 [[-MaxAge] <Int32>] [[-MaxBytesPerSecond] <Int32>] [[-TimeoutRemoteHost] <Int32>]
 [[-TimeoutLocalHost] <Int32>] [[-ExcludeObjectsRegex] <String>] [[-CustomParameter] <String>]
 [-DeleteDuplicatesOnDestination] [-DeleteFromSourceWhenCompleted]
 [-DeleteMessagesOnDestinationThatAreNotOnSource] [-AutomapFolders] [-SkipCrossDuplicates] [-SubscribeAll]
 [-SimulateSync] [-Enable] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates a sync job configuration on the mailcow server.

## EXAMPLES

### EXAMPLE 1
```
Set-MHSyncJob
```

## PARAMETERS

### -AutomapFolders
Try to automap folders ("Sent items", "Sent" =\> "Sent" etc.) (--automap).
Default is enabled.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomParameter
Example: --some-param=xy --other-param=yx

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeleteDuplicatesOnDestination
Delete duplicates on destination (--delete2duplicates).
Default is enabled.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeleteFromSourceWhenCompleted
Delete from source when completed (--delete1).
Default is disabled.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeleteMessagesOnDestinationThatAreNotOnSource
Delete messages on destination that are not on source (--delete2).
Default is disabled.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enable
Enable or disable the sync job.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Encryption
The type of encryption to use for the remote mail server.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: TLS
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeObjectsRegex
Exclude objects (regex).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: (?i)spam|(?i)junk
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hostname
The hostname of the remote mail server from where to sync.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
The ID number for the sync job to update.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Interval
Interval in minutes for checking the remote mailbox.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 20
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxAge
Maximum age of messages in days that will be polled from remote (0 = ignore age).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxBytesPerSecond
Max.
bytes per second (0 = unlimited).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
The password for the login on the remote mail server.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
The IMAP port number on the remote mail server.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 993
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

### -SimulateSync
Simulate synchronization (--dry).
Default is enabled.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipCrossDuplicates
Skip duplicate messages across folders (first come, first serve) (--skipcrossduplicates).
Default is disabled.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubscribeAll
Subscribe all folders (--subscribeall).
Default is enabled.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetSubfolder
The name of the folder to where the remote folder should be synced.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeoutLocalHost
Timeout for connection to local host (seconds).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: 600
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeoutRemoteHost
Timeout for connection to remote host (seconds).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: 600
Accept pipeline input: False
Accept wildcard characters: False
```

### -Username
The username for the login on the remote mail server.

```yaml
Type: MailAddress
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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

### System.Int32[]
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-SyncJob.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-SyncJob.md)

