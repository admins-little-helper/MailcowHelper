function Set-AliasMail {
    <#
    .SYNOPSIS
        Update a mail alias.

    .DESCRIPTION
        Update a mail alias.

    .PARAMETER Identity
        The alias mail address to update.

    .PARAMETER Destination
        The destination mail address for the alias.

    .PARAMETER SilentlyDiscard
        If specified, silently discard mail messages sent to the alias address.

    .PARAMETER LearnAsSpam
        If specified, all mails sent to the alias are treated as spam (blacklisted).

    .PARAMETER LearnAsHam
        If specified, all mails sent to the alias are treated as "ham" (whitelisted).

    .PARAMETER Enable
        Enalbe or disable the alias address.

    .PARAMETER Internal
        Internal aliases are only accessible from the own domain or alias domains.

    .PARAMETER SOGoVisible
        Make the new alias visible ein SOGo.

    .PARAMETER PublicComment
        Specify a public comment.

    .PARAMETER PrivateComment
        Specify a private comment.

    .PARAMETER AllowSendAs
        Allow the destination mailbox uesrs to SendAs the alias.

    .EXAMPLE
        Set-MHAliasMail -Alias "alias@example.com" -Destination "mailbox@example.com" -SOGoVisible

        Creates an alias "alias@example.com" for mailbox "mailbox@example.com". The alias will be visible for the user in SOGo.

    .EXAMPLE
        Set-MHAliasMail -Alias "spam@example.com" -Destination "mailbox@example.com" LearnAsSpam

        Creates an alias "spam@example.com" for mailbox "mailbox@example.com". Mails sent to the new alias will be treated as spam.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AliasMail.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = "DestinationMailbox")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The alias mail address to update.")]
        [MailcowHelperArgumentCompleter("Alias")]
        [Alias("Alias")]
        [System.Net.Mail.MailAddress]
        $Identity,

        [Parameter(ParameterSetName = "DestinationMailbox", Position = 1, Mandatory = $false, HelpMessage = "The destination mail address for the alias.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Destination,

        [Parameter(ParameterSetName = "DestinationDiscard", Position = 2, Mandatory = $false, HelpMessage = "Silently discard mail messages sent to the alias address.")]
        [System.Management.Automation.SwitchParameter]
        $SilentlyDiscard,

        [Parameter(ParameterSetName = "DestinationSpam", Position = 3, Mandatory = $false, HelpMessage = "All mails sent to the alias are treated as spam (blacklisted)")]
        [System.Management.Automation.SwitchParameter]
        $LearnAsSpam,

        [Parameter(ParameterSetName = "DestinationHam", Position = 4, Mandatory = $false, HelpMessage = "All mails sent to the alias are treated as 'ham' (whitelisted).")]
        [System.Management.Automation.SwitchParameter]
        $LearnAsHam,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "Allows to enable or disable the new alias.")]
        [System.Management.Automation.SwitchParameter]
        $Enable,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "Internal aliases are only accessible from the own domain or alias domains.")]
        [System.Management.Automation.SwitchParameter]
        $Internal,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "Make the new alias visiabl ein SOGo.")]
        [System.Management.Automation.SwitchParameter]
        $SOGoVisible,

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "Specify a public comment.")]
        [System.String]
        $PublicComment,

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "Specify a private comment.")]
        [System.String]
        $PrivateComment,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "Allow the destination mailbox uesrs to SendAs the alias.")]
        [System.Management.Automation.SwitchParameter]
        $AllowSendAs
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/alias"
    }

    process {
        # First get the ID value of the specified alias email address.
        $AliasId = Get-AliasMail -Identity $Identity.Address

        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        # Prepare the request body.
        $Body = @{
            # Set the alias ID that should be updated.
            items = $AliasId.Id
            attr  = @{}
        }
        if ($PSBoundParameters.ContainsKey("Destination")) {
            # Set the specified destination address.
            $Destinations = foreach ($DestinationItem in $Destination) { $DestinationItem.Address }
            $Body.attr.goto = [System.String]$Destinations -join ","
        }
        if ($PSBoundParameters.ContainsKey("SilentlyDiscard")) {
            # Set the destination to "null@localhost".
            $Body.attr.goto_null = "1"
        }
        if ($PSBoundParameters.ContainsKey("LearnAsSpam")) {
            # Set the destination to "spam@localhost".
            $Body.attr.goto_spam = "1"
        }
        if ($PSBoundParameters.ContainsKey("LearnAsHam")) {
            # Set the destination to "ham@localhost".
            $Body.attr.goto_ham = "1"
        }
        if ($PSBoundParameters.ContainsKey("Enable")) {
            # Set the active state in case the "Enable" parameter was specified based on it's value.
            $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("Internal")) {
            # Set if the alias should be reachable only internal.
            $Body.attr.internal = if ($Internal.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("SOGoVisible")) {
            # Set if the alias should be availabl ein SOGo.
            $Body.attr.sogo_visible = if ($SOGoVisible.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("PublicComment")) {
            # Set the public comment for the alias.
            $Body.attr.public_comment = $PublicComment
        }
        if ($PSBoundParameters.ContainsKey("PrivateComment")) {
            # Set the private comment for the alias.
            $Body.attr.private_comment = $PrivateComment
        }
        if ($PSBoundParameters.ContainsKey("AllowSendAs")) {
            # Set SenderAllowed option.
            $Body.attr.sender_allowed = if ($AllowSendAs.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("alias [$($Identity.Address)].", "Update")) {
            Write-MailcowHelperLog -Message "Updating alias id [$($AliasId.Id)] with address [$($Identity.Address)]." -Level Information

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
