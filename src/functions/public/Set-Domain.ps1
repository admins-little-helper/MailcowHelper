function Set-Domain {
    <#
    .SYNOPSIS
        Update one or more domains on the mailcow server.

    .DESCRIPTION
        Update one or more domains on the mailcow server.

    .PARAMETER Domain
        The domain name to update.

    .PARAMETER Description
        A description for the domain.

    .PARAMETER Enable
        Enable or disable the domain.

    .PARAMETER MaxMailboxCount
        Specify the maximum number of mailboxes allowed for the domain.
        Defaults to 10.

    .PARAMETER MaxAliasCount
        Specify the maximum number of aliases allowed for the domain.
        Defaults to 400.

    .PARAMETER DefaultMailboxQuota
        Specify the default mailbox quota.
        Defaults to 3072.

    .PARAMETER MailboxQuota
        Specify the maximum mailbox quota.
        Defaults to 10240.

    .PARAMETER TotalDomainQuota
        Specify the total domain quota valid for all mailboxes in the domain.
        Defaults to 10240.

    .PARAMETER GlobalAddressList
        Enable or disable the Global Address list for the domain.

    .PARAMETER RelayThisDomain
        Enable or disable the relaying for the domain created.

    .PARAMETER RelayAllRecipients
        Enable or disable the relaying for all recipients for the domain.

    .PARAMETER RelayUnknownOnly
        Enable or disable the relaying for unknown recipients for the domain.

    .PARAMETER Tag
        Add a tag to the new domain.

    .PARAMETER RateLimit
        Set the message rate limit for the domain.
        Defaults to 10.

    .PARAMETER RateLimitPerUnit
        Set the message rate limit unit.
        Defaults to seconds.

    .EXAMPLE
        Set-MHDomain -Domain "example.com" -MaxMailboxCount 100

        Sets the mailbox count value for the domain "example.com" to 100.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-Domain.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The domain name to add.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [Alias("Domain")]
        [System.String[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "A description for the new domain.")]
        [System.String]
        $Description,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Enable or disable the domain.")]
        [System.Management.Automation.SwitchParameter]
        $Enable,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "Specify the maximum number of mailboxes allowed for the domain.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MaxMailboxCount = 10,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "Specify the maximum number of aliases allowed for the domain.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MaxAliasCount = 400,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "Specify the default mailbox quota.")]
        # Default mailbox quota accepts max 8 Exabyte.
        [ValidateRange(1, 9223372036854775807)]
        [System.Int64]
        $DefaultMailboxQuotaMB = 3072,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "Specify the maximum mailbox quota.")]
        # Max. mailbox quota accepts max 8 Exabyte.
        [ValidateRange(1, 9223372036854775807)]
        [System.Int64]
        $MaxMailboxQuotaMB = 10240,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "Specify the total domain quota valid for all mailboxes in the domain.")]
        # Total domain quota accepts max 8 Exabyte.
        [ValidateRange(1, 9223372036854775807)]
        [System.Int64]
        $TotalDomainQuotaMB = 10240,

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "Enable or disable the Global Address list for the domain.")]
        [System.Management.Automation.SwitchParameter]
        $GlobalAddressList,

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "Enable or disable the relaying for the domain.")]
        [System.Management.Automation.SwitchParameter]
        $RelayThisDomain,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "Enable or disable the relaying for all recipients for the domain.")]
        [System.Management.Automation.SwitchParameter]
        $RelayAllRecipients,

        [Parameter(Position = 11, Mandatory = $false, HelpMessage = "Enable or disable the relaying for unknown recipients for the domain.")]
        [System.Management.Automation.SwitchParameter]
        $RelayUnknownOnly,

        [Parameter(Position = 12, Mandatory = $false)]
        [System.String[]]
        $Tag,

        [Parameter(Position = 13, Mandatory = $false)]
        [ValidateRange(0, 9223372036854775807)]
        [System.Int64]
        $RateLimit = 10,

        [Parameter(Position = 14, Mandatory = $false)]
        [ValidateSet("Second", "Minute", "Hour", "Day")]
        [System.String]
        $RateLimitPerUnit = "Seconds"
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/domain/"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath

            # Prepare the request body.
            $Body = @{
                items = $IdentityItem
                attr  = @{}
            }

            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("MaxAliasCount")) {
                $Body.attr.aliases = $MaxAliasCount.ToString()
            }
            if ($PSBoundParameters.ContainsKey("DefaultMailboxQuotaMB")) {
                # Default mailbox quota accepts max 8 Exabyte.
                $Body.attr.defquota = $($DefaultMailboxQuotaMB).ToString()
            }
            if ($PSBoundParameters.ContainsKey("Description")) {
                if (-not [System.String]::IsNullOrEmpty($Description)) {
                    $Body.attr.description = $Description
                }
            }
            if ($PSBoundParameters.ContainsKey("MaxMailboxCount")) {
                $Body.attr.mailboxes = $MaxMailboxCount.ToString()
            }
            if ($PSBoundParameters.ContainsKey("TotalDomainQuotaMB")) {
                # Total mailbox quota accepts max 8 Exabyte.
                $Body.attr.quota = $($TotalDomainQuotaMB).ToString()
            }
            if ($PSBoundParameters.ContainsKey("MaxMailboxQuotaMB")) {
                # Mailbox quota accepts max 8 Exabyte.
                $Body.attr.maxquota = $($MaxMailboxQuotaMB).ToString()
            }
            if ($PSBoundParameters.ContainsKey("GlobalAddressList")) {
                $Body.attr.gal = if ($GlobalAddressList.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("RelayThisDomain")) {
                $Body.attr.backupmx = if ($RelayThisDomain.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("RelayAllRecipients")) {
                $Body.attr.relay_all_recipients = if ($RelayAllRecipients.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("RelayUnknownOnly")) {
                $Body.attr.relay_unknown_only = if ($RelayUnknownOnly.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("RateLimitPerUnit")) {
                $Body.attr.rl_frame = $RateLimitPerUnit.Substring(0, 1).ToLower()
            }
            if ($PSBoundParameters.ContainsKey("RateLimit")) {
                $Body.attr.rl_value = $RateLimit.ToString()
            }
            if (-not [System.String]::IsNullOrEmpty($Tag)) {
                $Body.attr.tags = $Tag
            }

            if ($PSCmdlet.ShouldProcess("domain [$IdentityItem].", "Update")) {
                Write-MailcowHelperLog -Message "Updating domain [$IdentityItem]." -Level Information

                # Execute the API call.
                $InvokeMailcowHelperRequestParams = @{
                    UriPath = $RequestUriPath
                    Method  = "Post"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowHelperRequestParams

                # Return the result.
                $Result
            }
        }
    }
}
