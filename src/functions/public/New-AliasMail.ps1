function New-AliasMail {
    <#
    .SYNOPSIS
        Add an alias mail address.

    .DESCRIPTION
        Add an alias mail address.

    .PARAMETER Identity
        The new alias mail address to create.

    .PARAMETER Destination
        The destination mail address(es) for the new alias.
        Specifying multiple destination addresses basically creates a distribution list.

    .PARAMETER SilentlyDiscard
        Silently discard mail messages sent to the alias address.

    .PARAMETER LearnAsSpam
        All mails sent to the alias are treated as spam (blacklisted).

    .PARAMETER LearnAsHam
        All mails sent to the alias are treated as "ham" (whitelisted).

    .PARAMETER Enable
        Enable or disable the new alias.
        By default the new alias address is enabled. To create a disable alias use "-Enable:$false".

    .PARAMETER Internal
        Internal aliases are only accessible from the own domain or alias domains.

    .PARAMETER SOGoVisible
        Make the new alias visible ein SOGo.

    .PARAMETER PublicComment
        Specify a public comment.

    .PARAMETER PrivateComment
        Specify a private comment.

    .EXAMPLE
        New-MHMailAlias -Alias "alias@example.com" -Destination "mailbox@example.com" -SOGoVisible

        Creates an alias "alias@example.com" for mailbox "mailbox@example.com". The alias will be visible for the user in SOGo.

    .EXAMPLE
        New-MHMailAlias -Alias "spam@example.com" -Destination "mailbox@example.com" -LearnAsSpam

        Creates an alias "spam@example.com" for mailbox "mailbox@example.com". Mails sent to the new alias will be treated as spam.

    .EXAMPLE
        New-MHMailAlias -Alias "groupA@example.com" -Destination "user1@example.com", "user2@example.com"

        This creates an alias that acts like a distribution group because mails to the alias are forwarded to two mailboxes.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-AliasMail.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The new alias mail address to create.")]
        [Alias("Alias")]
        [System.Net.Mail.MailAddress]
        $Identity,

        [Parameter(ParameterSetName = "DestinationMailbox", Position = 1, Mandatory = $false, HelpMessage = "The destination mail address for the new alias.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Destination,

        [Parameter(ParameterSetName = "DestinationDiscard", Position = 2, Mandatory = $false, HelpMessage = "Silently discard mail messages sent to the alias address.")]
        [System.Management.Automation.SwitchParameter]
        $SilentlyDiscard,

        [Parameter(ParameterSetName = "DestinationSpam", Position = 3, Mandatory = $false, HelpMessage = "All mails sent to the alias are treated as spam (blacklisted).")]
        [System.Management.Automation.SwitchParameter]
        $LearnAsSpam,

        [Parameter(ParameterSetName = "DestinationHam", Position = 4, Mandatory = $false, HelpMessage = "All mails sent to the alias are treated as ham (whitelisted).")]
        [System.Management.Automation.SwitchParameter]
        $LearnAsHam,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "Enable or disable the new alias.")]
        [System.Management.Automation.SwitchParameter]
        $Enable,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "Internal aliases are only accessible from the own domain or alias domains.")]
        [System.Management.Automation.SwitchParameter]
        $Internal,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "Make the new alias visible ein SOGo.")]
        [System.Management.Automation.SwitchParameter]
        $SOGoVisible,

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "Specify a public comment.")]
        [System.String]
        $PublicComment,

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "Specify a private comment.")]
        [System.String]
        $PrivateComment
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/alias"
    }

    process {
        foreach ($AliasItem in $Alias) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath

            # Prepare the request body.
            $Body = @{
                # By default, activate the new alias.
                active  = 1
                # Set the Alias address.
                address = $AliasItem.Address
            }
            if ($PSBoundParameters.ContainsKey("Destination")) {
                # Set the specified destination address.
                $Destinations = foreach ($DestinationItem in $Destination) { $DestinationItem.Address }
                $Body.goto = [System.String]$Destinations -join ","
            }
            if ($PSBoundParameters.ContainsKey("SilentlyDiscard")) {
                # Set the destination to "null@localhost".
                $Body.goto_null = "1"
            }
            if ($PSBoundParameters.ContainsKey("LearnAsSpam")) {
                # Set the destination to "spam@localhost".
                $Body.goto_spam = "1"
            }
            if ($PSBoundParameters.ContainsKey("LearnAsHam")) {
                # Set the destination to "ham@localhost".
                $Body.goto_ham = "1"
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                # Set the active state in case the "Enable" parameter was specified based on it's value.
                $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("Internal")) {
                # Set if the alias should be reachable only internal.
                $Body.internal = if ($Internal.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("SOGoVisible")) {
                # Set if the alias should be availabl ein SOGo.
                $Body.sogo_visible = if ($SOGoVisible.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("PublicComment")) {
                # Set the public comment for the alias.
                $Body.public_comment = $PublicComment
            }
            if ($PSBoundParameters.ContainsKey("PrivateComment")) {
                # Set the private comment for the alias.
                $Body.private_comment = $PrivateComment
            }

            if ($PSCmdlet.ShouldProcess("alias [$AliasItem].", "Add")) {
                Write-MailcowHelperLog -Message "Adding alias [$AliasItem]." -Level Information
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
}
