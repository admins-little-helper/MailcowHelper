function Set-MailboxPushover {
    <#
    .SYNOPSIS
        Updates Pushover notification settings for one or more mailboxes.

    .DESCRIPTION
        Updates Pushover notification settings for one or more mailboxes.

    .PARAMETER Identity
        The mail address of the mailbox for which Pushover settings should be configured.

    .PARAMETER Token
        The Pushover API application token.

    .PARAMETER Key
        The Pushover user or group key.

    .PARAMETER Title
        The notification title sent via Pushover.

    .PARAMETER Text
        The notification body text sent via Pushover.

    .PARAMETER SenderMailAddress
        One or more sender email addresses that should trigger a Pushover notification.

    .PARAMETER Sound
        Specifies the notification sound to play. Must be one of the predefined Pushover sound names.
        Defaults to "Pushover".

    .PARAMETER SenderRegex
        Specifies a regular expression used to match sender addresses for triggering notifications.

    .PARAMETER EvaluateXPrio
        If specified, high-priority messages (X-Priority headers) are evaluated and escalated.

    .PARAMETER OnlyXPrio
        If specified, only high-priority messages (X-Priority headers) are considered for notifications.

    .PARAMETER Enable
        Enables or disables Pushover notifications for the mailbox.

    .EXAMPLE
        Set-MHMailboxPushover -Identity "user@example.com" -Token "APP_TOKEN" -Key "USER_KEY" -Enable

        Enables Pushover notifications for the specified mailbox using the provided token and key.

    .EXAMPLE
        "user123@example.com", "user456@example.com" | Set-MHMailboxPushover -Enable -Sound "Magic"

        Enables Pushover notifications for multiple mailboxes piped into the function and sets the
        notification sound to "Magic".

    .EXAMPLE
        Set-MHMailboxPushover -Identity "alerts@example.com" -SenderRegex ".*@critical\.com" -EvaluateXPrio -Enable

        Enables notifications only for senders matching the regex and escalates high-priority messages.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxPushover.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which Pushover settings should be configured.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The Pushover API Token/Key (Application).")]
        [System.String]
        $Token,

        [Parameter(Position = 2, Mandatory = $true, HelpMessage = "The Pushover User/Group Key.")]
        [System.String]
        $Key,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The notification title.")]
        [System.String]
        $Title,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "The notification text.")]
        [System.String]
        $Text,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "Sender email address to consider.")]
        [System.Net.Mail.MailAddress[]]
        $SenderMailAddress,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "The sound to play.")]
        [ValidateSet("Pushover", "Bike", "Bugle", "Cash Register", "Classical", "Cosmic", "Falling", "Gamelan", "Incoming", "Intermission", "Magic", "Mechanical", "Piano Bar", "Siren", "Space Alarm", "Tug Boat", "Aliean alarm", "Climb", "Persistent", "Pushover Echo", "Up Down", "Vibrate Only", "None")]
        [System.String]
        $Sound = "Pushover",

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "Sender regex string to consider.")]
        [System.String]
        $SenderRegex,

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "Escalate high priority mail.")]
        [System.Management.Automation.SwitchParameter]
        $EvaluateXPrio,

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "Only consider high priority mail.")]
        [System.Management.Automation.SwitchParameter]
        $OnlyXPrio,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "Enable or disable the pushover settings.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/pushover"
    }

    process {
        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        # Prepare a string that will be used for logging.
        $LogIdString = if ($Identity.Count -gt 1) {
            "$($Identity.Count) mailboxes"
        }
        else {
            foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
        }

        # Prepare the request body.
        $Body = @{
            # Assign all mail addresses to the "items" attribute.
            items = foreach ($IdentityItem in $Identity) {
                $IdentityItem.Address
            }
            attr  = @{}
        }
        if ($PSBoundParameters.ContainsKey("Token")) {
            $Body.attr.token = $Token
        }
        if ($PSBoundParameters.ContainsKey("Key")) {
            $Body.attr.key = $Key
        }
        if ($PSBoundParameters.ContainsKey("Title")) {
            $Body.attr.title = $Title
        }
        if ($PSBoundParameters.ContainsKey("Text")) {
            $Body.attr.text = $Text
        }
        if ($PSBoundParameters.ContainsKey("SenderMailAddress")) {
            $Body.attr.senders = foreach ($SenderMailAddressItem in $SenderMailAddress) {
                $SenderMailAddressItem.Address
            }
        }
        if ($PSBoundParameters.ContainsKey("Sound")) {
            $Body.attr.sound = $Sound.ToLower()
        }
        if ($PSBoundParameters.ContainsKey("SenderRegex")) {
            $Body.attr.senders_regex = $SenderRegex
        }
        if ($PSBoundParameters.ContainsKey("EvaluateXPrio")) {
            $Body.attr.evaluate_x_prio = if ($EvaluateXPrio.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("OnlyXPrio")) {
            $Body.attr.only_x_prio = if ($OnlyXPrio.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("Enable")) {
            $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("mailbox Pushover settings for [$LogIdString].", "Update")) {
            Write-MailcowHelperLog -Message "Updating pushover settings for [$LogIdString]." -Level Information

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
