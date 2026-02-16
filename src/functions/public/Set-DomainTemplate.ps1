function Set-DomainTemplate {
    <#
    .SYNOPSIS
        Updates one or more domain templates.

    .DESCRIPTION
        Updates one or more domain templates.
        A domain template can either be specified as a default template for a new domain.
        Or you can select a template when creating a new mailbox to inherit some properties.

    .PARAMETER Id
        The ID value of the mailbox template to update.

    .PARAMETER MaxNumberOfAliasesForDomain
        The maximum number of aliases allowed in a domain.

    .PARAMETER MaxNumberOfMailboxesForDomain
        The maximum number of mailboxes allowed in a domain.

    .PARAMETER DefaultMailboxQuota
        The default mailbox quota limit in MiB.

    .PARAMETER MaxMailboxQuota
        The maximum mailbox quota limit in MiB.

    .PARAMETER MaxDomainQuota
        The domain wide total maximum mailbox quota limit in MiB.

    .PARAMETER Tag
        One or more tags to will be assigned to a mailbox.

    .PARAMETER RateLimitValue
        The rate limit value.

    .PARAMETER RateLimitFrame
        The rate limit unit.

    .PARAMETER DkimSelector
        The string to be used as DKIM selector.

    .PARAMETER DkimKeySize
        The DKIM key keysize.

    .PARAMETER Enable
        Enable or disable the domain created by the template.

    .PARAMETER GlobalAddressList
        Enable or disable the Global Address list for the domain created by the template.

    .PARAMETER RelayThisDomain
        Enable or disable the relaying for the domain created by the template.

    .PARAMETER RelayAllRecipients
        Enable or disable the relaying for all recipients for the domain created by the template.

    .PARAMETER RelayUnknownOnly
        Enable or disable the relaying for unknown recipients for the domain created by the template.

    .EXAMPLE
        Set-MHDomainTemplate -Name "MyDefaultDomainTemplate"

        Creates a domain template with the name "MyDefaultDomainTemplate". All values are set to mailcow defaults.

    .EXAMPLE
        Set-MHDomainTemplate -Name "MyDefaultDomainTemplate" -MaxNumberOfAliasesForDomain 1000 -MaxNumberOfMailboxesForDomain 1000 -MaxDomainQuota 102400

        Creates a domain template with the name "MyDefaultDomainTemplate".
        The maximum number of aliases and mailboxes will be set to 1000. The domain wide total mailbox quota will be set to 100 GByte.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-DomainTemplate.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The ID value of the mailbox template to update.")]
        [System.Int64[]]
        $Id,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The name of the domain template.")]
        [System.String]
        $Name,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The maximum number of aliases allowed in a domain.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MaxNumberOfAliasesForDomain = 400,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The maximum number of mailboxes allowed in a domain.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MaxNumberOfMailboxesForDomain = 10,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The default mailbox quota limit in MiB.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $DefaultMailboxQuota = 3072,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The maximum mailbox quota limit in MiB.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MaxMailboxQuota = 10240,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "The domain wide total maximum mailbox quota limit in MiB.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MaxDomainQuota = 10240,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "One or more tags to will be assigned to a mailbox.")]
        [System.String[]]
        $Tag,

        [Parameter( Position = 6, Mandatory = $false, HelpMessage = "The rate limit value.")]
        # 0 = disable rate limit
        [ValidateRange(0, 9223372036854775807)]
        [System.Int32]
        $RateLimitValue = 0,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "The rate limit unit.")]
        [ValidateSet("Second", "Minute", "Hour", "Day")]
        [System.String]
        $RateLimitFrame = "Hour",

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "The string to be used as DKIM selector.")]
        [System.String]
        $DkimSelector = "dkim",

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "The DKIM key keysize.")]
        [ValidateSet(1024, 2024, 4096, 8192)]
        [System.Int32]
        $DkimKeySize = 2096,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "Enable or disable the domain created by the template.")]
        [System.Management.Automation.SwitchParameter]
        $Enable,

        [Parameter(Position = 11, Mandatory = $false, HelpMessage = "Enable or disable the Global Address list for the domain created by the template.")]
        [System.Management.Automation.SwitchParameter]
        $GlobalAddressList,

        [Parameter(Position = 12, Mandatory = $false, HelpMessage = "Enable or disable the relaying for the domain created by the template.")]
        [System.Management.Automation.SwitchParameter]
        $RelayThisDomain,

        [Parameter(Position = 13, Mandatory = $false, HelpMessage = "Enable or disable the relaying for all recipients for the domain created by the template.")]
        [System.Management.Automation.SwitchParameter]
        $RelayAllRecipients,

        [Parameter(Position = 14, Mandatory = $false, HelpMessage = "Enable or disable the relaying for unknown recipients for the domain created by the template.")]
        [System.Management.Automation.SwitchParameter]
        $RelayUnknownOnly
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/domain/template"
    }

    process {
        # Make an API call for each ID.
        foreach ($IdItem in $Id) {
            # First get the current mailbox template settings to use as base.
            # This is needed because otherwise any option not explicitly specified, will be set to be disabled by the API.
            $CurrentConfig = Get-DomainTemplate -Raw | Where-Object { $_.id -eq $IdItem }

            # Prepare the request body.
            $Body = @{
                items = $IdItem.ToSTring()
                attr  = @{
                    # Set current template settings as base values for the update.
                    template                   = $CurrentConfig.template
                    tags                       = $CurrentConfig.attributes.tags
                    max_num_aliases_for_domain = $CurrentConfig.attributes.max_num_aliases_for_domain
                    max_num_mboxes_for_domain  = $CurrentConfig.attributes.max_num_mboxes_for_domain
                    def_quota_for_mbox         = $CurrentConfig.attributes.def_quota_for_mbox / 1048576 # to convert bytes into MiB.
                    max_quota_for_mbox         = $CurrentConfig.attributes.max_quota_for_mbox / 1048576 # to convert bytes into MiB.
                    max_quota_for_domain       = $CurrentConfig.attributes.max_quota_for_domain / 1048576 # to convert bytes into MiB.
                    rl_frame                   = $CurrentConfig.attributes.rl_frame
                    rl_value                   = $CurrentConfig.attributes.rl_value
                    active                     = $CurrentConfig.attributes.active
                    gal                        = $CurrentConfig.attributes.gal
                    backupmx                   = $CurrentConfig.attributes.backupmx
                    relay_all_recipients       = $CurrentConfig.attributes.relay_all_recipients
                    relay_unknown_only         = $CurrentConfig.attributes.relay_unknown_only
                    dkim_selector              = $CurrentConfig.attributes.dkim_selector
                    key_size                   = $CurrentConfig.attributes.key_size
                }
            }

            if ($PSBoundParameters.ContainsKey("Name")) {
                $Body.attr.template = $Name.Trim()
            }
            if ($PSBoundParameters.ContainsKey("Tag")) {
                $Body.attr.tags = $Tag
            }
            if ($PSBoundParameters.ContainsKey("MaxNumberOfAliasesForDomain")) {
                $Body.attr.max_num_aliases_for_domain = $MaxNumberOfAliasesForDomain.ToString()
            }
            if ($PSBoundParameters.ContainsKey("MaxNumberOfMailboxesForDomain")) {
                $Body.attr.max_num_mboxes_for_domain = $MaxNumberOfMailboxesForDomain.ToString()
            }
            if ($PSBoundParameters.ContainsKey("DefaultMailboxQuota")) {
                $Body.attr.def_quota_for_mbox = $DefaultMailboxQuota.ToString()
            }
            if ($PSBoundParameters.ContainsKey("MaxMailboxQuota")) {
                $Body.attr.max_quota_for_mbox = $MaxMailboxQuota.ToString()
            }
            if ($PSBoundParameters.ContainsKey("MaxDomainQuota")) {
                $Body.attr.max_quota_for_domain = $MaxDomainQuota.ToString()
            }
            if ($PSBoundParameters.ContainsKey("RateLimitValue")) {
                $Body.attr.rl_value = $RateLimitValue.ToString()
            }
            if ($PSBoundParameters.ContainsKey("RateLimitFrame")) {
                $Body.attr.rl_frame = $RateLimitFrame.Substring(0, 1).ToLower()
            }
            if ($PSBoundParameters.ContainsKey("DkimSelector")) {
                $Body.attr.dkim_selector = $DkimSelector.Trim()
            }
            if ($PSBoundParameters.ContainsKey("DkimKeySize")) {
                $Body.attr.key_size = $DkimKeySize.ToString()
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
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

            if ($PSCmdlet.ShouldProcess("domain template [$IdItem].", "Update")) {
                Write-MailcowHelperLog -Message "Updating domain template [$IdItem]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
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