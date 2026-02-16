function Set-SyncJob {
    <#
    .SYNOPSIS
        Updates a sync job configuration on the mailcow server.

    .DESCRIPTION
        Updates a sync job configuration on the mailcow server.

    .PARAMETER JobId
        The ID number for the sync job to delete.

    .PARAMETER Hostname
        The hostname of the remote mail server from where to sync.

    .PARAMETER Port
        The IMAP port number on the remote mail server.

    .PARAMETER Username
        The username for the login on the remote mail server.

    .PARAMETER Password
        The password for the login on the remote mail server.

    .PARAMETER Encryption
        The type of encryption to use for the remote mail server.

    .PARAMETER Interval
        Interval in minutes for checking the remote mailbox.

    .PARAMETER TargetSubfolder
        The name of the folder to where the remote folder should be synced.

    .PARAMETER MaxAge
        Maximum age of messages in days that will be polled from remote (0 = ignore age).

    .PARAMETER MaxBytesPerSecond
        Max. bytes per second (0 = unlimited).

    .PARAMETER TimeoutRemoteHost
        Timeout for connection to remote host (seconds).

    .PARAMETER TimeoutLocalHost
        Timeout for connection to local host (seconds).

    .PARAMETER ExcludeObjectsRegex
        Exclude objects (regex).

    .PARAMETER CustomParameter
        Example: --some-param=xy --other-param=yx

    .PARAMETER DeleteDuplicatesOnDestination
        Delete duplicates on destination (--delete2duplicates). Default is enabled.

    .PARAMETER DeleteFromSourceWhenCompleted
        Delete from source when completed (--delete1). Default is disabled.

    .PARAMETER DeleteMessagesOnDestinationThatAreNotOnSource
        Delete messages on destination that are not on source (--delete2). Default is disabled.

    .PARAMETER AutomapFolders
        Try to automap folders ("Sent items", "Sent" => "Sent" etc.) (--automap). Default is enabled.

    .PARAMETER SkipCrossDuplicates
        Skip duplicate messages across folders (first come, first serve) (--skipcrossduplicates). Default is disabled.

    .PARAMETER SubscribeAll
        Subscribe all folders (--subscribeall). Default is enabled.

    .PARAMETER SimulateSync
        Simulate synchronization (--dry). Default is enabled.

    .PARAMETER Enable
        Enable or disable the sync job.

    .EXAMPLE
        Set-MHSyncJob

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-SyncJob.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The ID number for the sync job to update.")]
        [System.Int32]
        $Id,

        [Parameter(Mandatory = $false, HelpMessage = "The hostname of the remote mail server from where to sync.")]
        [System.String]
        $Hostname,

        [Parameter(Mandatory = $false, HelpMessage = "The IMAP port number on the remote mail server.")]
        [ValidateRange(1, 65535)]
        [System.Int32]
        $Port = 993,

        [Parameter(Mandatory = $false, HelpMessage = "The username for the login on the remote mail server.")]
        [System.Net.Mail.MailAddress]
        $Username,

        [Parameter(Mandatory = $false, HelpMessage = "The password for the login on the remote mail server.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Mandatory = $false, HelpMessage = "The type of encryption to use for the remote mail server.")]
        [ValidateSet("TLS", "SSL", "PLAIN")]
        [System.String]
        $Encryption = "TLS",

        [Parameter(Mandatory = $false, HelpMessage = "Interval in minutes for checking the remote mailbox.")]
        [ValidateRange(0, 43800)]
        [System.Int32]
        $Interval = 20,

        [Parameter(Mandatory = $false, HelpMessage = "The name of the folder to where the remote folder should be synced.")]
        [System.String]
        $TargetSubfolder,

        [Parameter(Mandatory = $false, HelpMessage = "Maximum age of messages in days that will be polled from remote (0 = ignore age).")]
        [ValidateRange(0, 32000)]
        [System.Int32]
        $MaxAge = 0,

        [Parameter(Mandatory = $false, HelpMessage = "Max. bytes per second (0 = unlimited).")]
        [ValidateRange(0, 125000000)]
        [System.Int32]
        $MaxBytesPerSecond = 0,

        [Parameter( Mandatory = $false, HelpMessage = "Timeout for connection to remote host (seconds).")]
        [ValidateRange(1, 32000)]
        [System.Int32]
        $TimeoutRemoteHost = 600,

        [Parameter(Mandatory = $false, HelpMessage = "Timeout for connection to local host (seconds).")]
        [ValidateRange(1, 32000)]
        [System.Int32]
        $TimeoutLocalHost = 600,

        [Parameter(Mandatory = $false, HelpMessage = "Exclude objects (regex).")]
        [System.String]
        $ExcludeObjectsRegex = "(?i)spam|(?i)junk",

        [Parameter(Mandatory = $false, HelpMessage = "Example: --some-param=xy --other-param=yx")]
        [System.String]
        $CustomParameter,

        [Parameter(Mandatory = $false, Helpmessage = "Delete duplicates on destination (--delete2duplicates). Default is enabled.")]
        [System.Management.Automation.SwitchParameter]
        $DeleteDuplicatesOnDestination,

        [Parameter(Mandatory = $false, Helpmessage = "Delete from source when completed (--delete1). Default is disabled.")]
        [System.Management.Automation.SwitchParameter]
        $DeleteFromSourceWhenCompleted,

        [Parameter(Mandatory = $false, Helpmessage = "Delete messages on destination that are not on source (--delete2). Default is disabled.")]
        [System.Management.Automation.SwitchParameter]
        $DeleteMessagesOnDestinationThatAreNotOnSource,

        [Parameter(Mandatory = $false, Helpmessage = "Try to automap folders ('Sent items', 'Sent' => 'Sent' etc.) (--automap). Default is enabled.")]
        [System.Management.Automation.SwitchParameter]
        $AutomapFolders,

        [Parameter(Mandatory = $false, Helpmessage = "Skip duplicate messages across folders (first come, first serve) (--skipcrossduplicates). Default is disabled.")]
        [System.Management.Automation.SwitchParameter]
        $SkipCrossDuplicates,

        [Parameter( Mandatory = $false, Helpmessage = "Subscribe all folders (--subscribeall). Default is enabled.")]
        [System.Management.Automation.SwitchParameter]
        $SubscribeAll,

        [Parameter(Mandatory = $false, Helpmessage = "Simulate synchronization (--dry). Default is enabled.")]
        [System.Management.Automation.SwitchParameter]
        $SimulateSync,

        [Parameter(Mandatory = $false, HelpMessage = "Enable or disable the sync job.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/syncjob"
    }

    process {
        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        # Get the current SyncJob by the specified id value.
        $SyncJobConfiguration = Get-SyncJob -Verbose | Where-Object { $_.id -eq $Id }

        # Prepare the request body.
        $Body = @{
            items = $Id
            attr  = $SyncJobConfiguration
        }

        # Set values based on what was provided by parameters.
        if ($PSBoundParameters.ContainsKey("Hostname")) {
            $Body.attr.host1 = $Hostname.Trim()
        }
        if ($PSBoundParameters.ContainsKey("Port")) {
            $Body.attr.port1 = $Port.ToString()
        }
        if ($PSBoundParameters.ContainsKey("Username")) {
            $Body.attr.user1 = $Username.Address
        }
        if ($PSBoundParameters.ContainsKey("Password")) {
            $Body.attr.password1 = $Password | ConvertFrom-SecureString -AsPlainText
        }
        if ($PSBoundParameters.ContainsKey("Encryption")) {
            $Body.attr.enc1 = $Encryption.ToUpper() # must be upper case, because otherwise "access_denied" is returned.
        }
        if ($PSBoundParameters.ContainsKey("Interval")) {
            $Body.attr.mins_interval = $Interval.ToString()
        }
        if ($PSBoundParameters.ContainsKey("MaxAge")) {
            $Body.attr.maxage = $MaxAge.ToString()
        }
        if ($PSBoundParameters.ContainsKey("MaxBytesPerSecond")) {
            $Body.attr.maxbytespersecond = $MaxBytesPerSecond.ToString()
        }
        if ($PSBoundParameters.ContainsKey("TimeoutRemoteHost")) {
            $Body.attr.timeout1 = $TimeoutRemoteHost.ToString()
        }
        if ($PSBoundParameters.ContainsKey("TimeoutLocalHost")) {
            $Body.attr.timeout2 = $TimeoutLocalHost.ToString()
        }
        if ($PSBoundParameters.ContainsKey("ExcludeObjectsRegex")) {
            $Body.attr.exclude = $ExcludeObjectsRegex
        }
        if ($PSBoundParameters.ContainsKey("TargetSubfolder")) {
            $Body.attr.subfolder2 = $TargetSubfolder.Trim()
        }
        if ($PSBoundParameters.ContainsKey("CustomParameter")) {
            $Body.attr.custom_params = $CustomParameter.Trim()
        }
        if ($PSBoundParameters.ContainsKey("Enable")) {
            $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("DeleteDuplicatesOnDestination")) {
            $Body.attr.delete2duplicates = if ($DeleteDuplicatesOnDestination.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("DeleteFromSourceWhenCompleted")) {
            $Body.attr.delete1 = if ($DeleteFromSourceWhenCompleted.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("DeleteMessagesOnDestinationThatAreNotOnSource")) {
            $Body.attr.delete2 = if ($DeleteMessagesOnDestinationThatAreNotOnSource.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("AutomapFolders")) {
            $Body.attr.automap = if ($AutomapFolders.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("SkipCrossDuplicates")) {
            $Body.attr.skipcrossduplicates = if ($SkipCrossDuplicates.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("SubscribeAll")) {
            $Body.attr.subscribeall = if ($SubscribeAll.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("SimulateSync")) {
            $Body.attr.dry = if ($SimulateSync.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("Update sync job id [$($Id -join ",")].", "Update")) {
            Write-MailcowHelperLog -Message "Updating sync job id [$($Id -join ",")]." -Level Information
            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $RequestUriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}
