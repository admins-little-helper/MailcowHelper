function Get-SyncJob {
    <#
    .SYNOPSIS
        Get information about all sync jobs on the mailcow server.

    .DESCRIPTION
        Get information about all sync jobs on the mailcow server.

    .PARAMETER IncludeLog
        Includes logs for each sync job.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHSyncJob

        Returns all sync jobs.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-SyncJob.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "Include logs for a sync job.")]
        [System.Management.Automation.SwitchParameter]
        $IncludeLog,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    if ($IncludeLog.IsPresent) {
        # Prepare the base Uri path.
        $UriPath = "get/syncjobs/all"
    }
    else {
        # Prepare the base Uri path.
        $UriPath = "get/syncjobs/all/no_log"
    }

    # Execute the API call.
    $Result = Invoke-MailcowApiRequest -UriPath $UriPath

    # Return result.
    if ($Raw.IsPresent) {
        # Return the result in raw format.
        $Result
    }
    else {
        # Prepare the result in a custom format.
        $ConvertedResult = foreach ($Item in $Result) {
            $ConvertedItem = [PSCustomObject]@{
                ID                  = $Item.id
                Mailbox             = $Item.user2
                Subfolder           = $Item.subfolder2
                SourceAccout        = $Item.user1
                SourceHost          = $Item.host1
                SourcePort          = $Item.port1
                Active              = [System.Boolean][System.Int32]$Item.active
                Success             = [System.Boolean][System.Int32]$Item.success
                LastRun             = if ($Item.last_run) { (Get-Date -Date $Item.last_run) }

                AuthMech            = $Item.authmech1
                Encryption          = $Item.enc1
                RegexTrans2         = $Item.regextrans2
                Authmd51            = $Item.authmd51
                Domain2             = $Item.domain2
                Exclude             = $Item.exclude
                Maxage              = $Item.maxage
                MinsInterval        = $Item.mins_interval
                MaxBytesPerSecond   = $Item.maxbytespersecond
                Delete2Duplicates   = $Item.delete2duplicates
                Delete1             = $Item.delete1
                Delete2             = $Item.delete2
                Automap             = $Item.automap
                SkipCrossDuplicates = $Item.skipcrossduplicates
                CustomParams        = $Item.custom_params
                Timeout1            = $Item.timeout1
                Timeout2            = $Item.timeout2
                SubscribeAll        = [System.Boolean][System.Int32]$Item.subscribeall
                Dry                 = [System.Boolean][System.Int32]$Item.dry
                IsRunning           = [System.Boolean][System.Int32]$Item.is_running
                ExitStatus          = $Item.exit_status
                Log                 = $Item.log
                WhenCreated         = if ($Item.created) { (Get-Date -Date $Item.created) }
                WhenModified        = if ($Item.modified) { (Get-Date -Date $Item.modified) }
            }
            $ConvertedItem.PSObject.TypeNames.Insert(0, "MHSyncJob")
            $ConvertedItem
        }
        # Return the result in custom format.
        $ConvertedResult
    }
}