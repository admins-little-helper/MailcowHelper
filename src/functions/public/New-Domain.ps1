function New-Domain {
    <#
    .SYNOPSIS
        Add a domain to mailcow server.

    .DESCRIPTION
        Add a domain to mailcow server.

    .PARAMETER Domain
        The domain name to add.

    .PARAMETER Description
        A description for the new domain.

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
        Enable or disable the relaying for the domain.

    .PARAMETER RelayAllRecipients
        Enable or disable the relaying for all recipients for the domain.

    .PARAMETER RelayUnknownOnly
        Enable or disable the relaying for unknown recipients for the domain.

    .PARAMETER Tag
        Add one or more tags to the new domain.

    .PARAMETER RateLimit
        Set the message rate limit for the domain.
        Defaults to 10.

    .PARAMETER RateLimitPerUnit
        Set the message rate limit unit.
        Defaults to seconds.

    .PARAMETER RestartSogo
        If specified, SOGo will be restarted after adding the domain.

    .PARAMETER Template
        The name of a domain template to use to get default values based on the template.

    .EXAMPLE
        New-MHDomain -Domain "example.com"

        Adds a new domain "example.com" to the mailcow server using default values from the default template.

    .EXAMPLE
        New-MHDomain -Domain "example.com" -Template "MyTemplate"

        Adds a new domain "example.com" to the mailcow server using default values from the "MyTemplate" domain template.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-Domain.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The domain name to add.")]
        [System.String[]]
        $Domain,

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
        $DefaultMailboxQuota = 3072,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "Specify the maximum mailbox quota.")]
        # Max. mailbox quota accepts max 8 Exabyte.
        [ValidateRange(1, 9223372036854775807)]
        [System.Int64]
        $MailboxQuota = 10240,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "Specify the total domain quota valid for all mailboxes in the domain.")]
        # Total domain quota accepts max 8 Exabyte.
        [ValidateRange(1, 9223372036854775807)]
        [System.Int64]
        $TotalDomainQuota = 10240,

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

        [Parameter(Position = 12, Mandatory = $false, HelpMessage = "Add one or more tags to the new domain.")]
        [System.String[]]
        $Tag,

        [Parameter(Position = 13, Mandatory = $false, HelpMessage = "Set the message rate limit for the domain.")]
        [ValidateRange(0, 9223372036854775807)]
        [System.Int64]
        $RateLimit = 10,

        [Parameter(Position = 14, Mandatory = $false, HelpMessage = "Set the message rate limit unit.")]
        [ValidateSet("Second", "Minute", "Hour", "Day")]
        [System.String]
        $RateLimitPerUnit = "Seconds",

        [Parameter(Position = 15, Mandatory = $false, HelpMessage = "If specified, SOGo will be restarted after adding the domain.")]
        [System.Management.Automation.SwitchParameter]
        $RestartSogo,

        [Parameter(Position = 16, Mandatory = $false, HelpMessage = "The name of a domain template to use to get default values based on the template.")]
        [MailcowHelperArgumentCompleter("DomainTemplate")]
        [System.String]
        $Template
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/domain/"
    }

    process {
        foreach ($DomainItem in $Domain) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath + "$($DomainItem.ToLower())"

            # Prepare the request body.
            $Body = @{
                domain = $DomainItem.Trim()
            }

            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("MaxAliasCount")) {
                $Body.aliases = $MaxAliasCount.ToString()
            }
            if ($PSBoundParameters.ContainsKey("DefaultMailboxQuota")) {
                $Body.defquota = $DefaultMailboxQuota.ToString()
            }
            if ($PSBoundParameters.ContainsKey("Description")) {
                if (-not [System.String]::IsNullOrEmpty($Description)) {
                    $Body.description = $Description
                }
            }
            if ($PSBoundParameters.ContainsKey("MaxMailboxCount")) {
                $Body.mailboxes = $MaxMailboxCount.ToString()
            }
            if ($PSBoundParameters.ContainsKey("TotalDomainQuota")) {
                $Body.quota = $TotalDomainQuota.ToString()
            }
            if ($PSBoundParameters.ContainsKey("MailboxQuota")) {
                $Body.maxquota = $MailboxQuota.ToString()
            }
            if ($PSBoundParameters.ContainsKey("GlobalAddressList")) {
                $Body.gal = if ($GlobalAddressList.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("RelayThisDomain")) {
                $Body.backupmx = if ($RelayThisDomain.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("RelayAllRecipients")) {
                $Body.relay_all_recipients = if ($RelayAllRecipients.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("RelayUnknownOnly")) {
                $Body.relay_unknown_only = if ($RelayUnknownOnly.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("RateLimitPerUnit")) {
                $Body.rl_frame = $RateLimitPerUnit.Substring(0, 1).ToLower()
            }
            if ($PSBoundParameters.ContainsKey("RateLimit")) {
                $Body.rl_value = $RateLimit.ToString()
            }
            if ($PSBoundParameters.ContainsKey("RestartSogo")) {
                $Body.restart_sogo = if ($RestartSogo.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("Tag")) {
                if (-not [System.String]::IsNullOrEmpty($Tag)) {
                    $Body.tags = $Tag
                }
            }
            if ($PSBoundParameters.ContainsKey("Template")) {
                # If no template is specified, the API will use values from the default domain template for values that have not been explicitly specified otherwise.
                if (-not [System.String]::IsNullOrEmpty($Template)) {
                    $Body.template = $Template
                }
            }

            if ($PSCmdlet.ShouldProcess("domain [$DomainItem].", "Add")) {
                Write-MailcowHelperLog -Message "Adding domain [$DomainItem]." -Level Information

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
