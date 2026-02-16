function New-DomainTemplate {
    <#
    .SYNOPSIS
        Create a new domain template.

    .DESCRIPTION
        Create a new domain template.
        A domain template can either be specified as a default template for a new domain.
        Or you can select a template when creating a new mailbox to inherit some properties from the template.

    .PARAMETER Name
        The name of the domain template.

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
        New-MHDomainTemplate -Name "MyDefaultDomainTemplate"

        Creates a domain template with the name "MyDefaultDomainTemplate". All values are set to mailcow defaults.

    .EXAMPLE
        New-MHDomainTemplate -Name "MyDefaultDomainTemplate" -MaxNumberOfAliasesForDomain 1000 -MaxNumberOfMailboxesForDomain 1000 -MaxDomainQuota 102400

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
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-MailboxTemplate.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = "DefaultOptions")]
    param(
        [Parameter(ParametersetName = "DefaultOptions", Position = 0, Mandatory = $true, HelpMessage = "The name of the domain template.")]
        [Parameter(ParametersetName = "IndividualSettings", Position = 0, Mandatory = $true, HelpMessage = "The name of the domain template.")]
        [System.String]
        $Name,

        [Parameter(ParametersetName = "IndividualSettings", Position = 1, Mandatory = $false, HelpMessage = "The maximum number of aliases allowed in a domain.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MaxNumberOfAliasesForDomain = 400,

        [Parameter(ParametersetName = "IndividualSettings", Position = 1, Mandatory = $false, HelpMessage = "The maximum number of mailboxes allowed in a domain.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MaxNumberOfMailboxesForDomain = 10,

        [Parameter(ParametersetName = "IndividualSettings", Position = 2, Mandatory = $false, HelpMessage = "The default mailbox quota limit in MiB.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $DefaultMailboxQuota = 3072,

        [Parameter(ParametersetName = "IndividualSettings", Position = 3, Mandatory = $false, HelpMessage = "The maximum mailbox quota limit in MiB.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MaxMailboxQuota = 10240,

        [Parameter(ParametersetName = "IndividualSettings", Position = 4, Mandatory = $false, HelpMessage = "The domain wide total maximum mailbox quota limit in MiB.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MaxDomainQuota = 10240,

        [Parameter(ParametersetName = "IndividualSettings", Position = 5, Mandatory = $false, HelpMessage = "One or more tags to will be assigned to a mailbox.")]
        [System.String[]]
        $Tag,

        [Parameter( ParametersetName = "IndividualSettings", Position = 6, Mandatory = $false, HelpMessage = "The rate limit value.")]
        # 0 = disable rate limit
        [ValidateRange(0, 9223372036854775807)]
        [System.Int32]
        $RateLimitValue = 0,

        [Parameter(ParametersetName = "IndividualSettings", Position = 7, Mandatory = $false, HelpMessage = "The rate limit unit.")]
        [ValidateSet("Second", "Minute", "Hour", "Day")]
        [System.String]
        $RateLimitFrame = "Hour",

        [Parameter(ParametersetName = "IndividualSettings", Position = 8, Mandatory = $false, HelpMessage = "The string to be used as DKIM selector.")]
        [System.String]
        $DkimSelector = "dkim",

        [Parameter(ParametersetName = "IndividualSettings", Position = 9, Mandatory = $false, HelpMessage = "The DKIM key keysize.")]
        [ValidateSet(1024, 2024, 4096, 8192)]
        [System.Int32]
        $DkimKeySize = 2096,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 10, Mandatory = $false, HelpMessage = "Enable or disable the domain created by the template.")]
        [System.Management.Automation.SwitchParameter]
        $Enable,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 11, Mandatory = $false, HelpMessage = "Enable or disable the Global Address list for the domain created by the template.")]
        [System.Management.Automation.SwitchParameter]
        $GlobalAddressList,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 12, Mandatory = $false, HelpMessage = "Enable or disable the relaying for the domain created by the template.")]
        [System.Management.Automation.SwitchParameter]
        $RelayThisDomain,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 13, Mandatory = $false, HelpMessage = "Enable or disable the relaying for all recipients for the domain created by the template.")]
        [System.Management.Automation.SwitchParameter]
        $RelayAllRecipients,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 14, Mandatory = $false, HelpMessage = "Enable or disable the relaying for unknown recipients for the domain created by the template.")]
        [System.Management.Automation.SwitchParameter]
        $RelayUnknownOnly
    )

    # Prepare the base Uri path.
    $UriPath = "add/domain/template"

    # Prepare the request body.
    $Body = @{
        template = $Name.Trim()
    }
    if ($PSBoundParameters.ContainsKey("Tag")) {
        $Body.tags = $Tag
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("MaxNumberOfAliasesForDomain")) {
        $Body.max_num_aliases_for_domain = $MaxNumberOfAliasesForDomain.ToString()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("MaxNumberOfMailboxesForDomain")) {
        $Body.max_num_mboxes_for_domain = $MaxNumberOfMailboxesForDomain.ToString()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("DefaultMailboxQuota")) {
        $Body.def_quota_for_mbox = $DefaultMailboxQuota.ToString()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("MaxMailboxQuota")) {
        $Body.max_quota_for_mbox = $MaxMailboxQuota.ToString()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("MaxDomainQuota")) {
        $Body.max_quota_for_domain = $MaxDomainQuota.ToString()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("RateLimitValue")) {
        $Body.rl_value = $RateLimitValue.ToString()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("RateLimitFrame")) {
        $Body.rl_frame = $RateLimitFrame.Substring(0, 1).ToLower()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("DkimSelector")) {
        $Body.dkim_selector = $DkimSelector.Trim()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("DkimKeySize")) {
        $Body.key_size = $DkimKeySize.ToString()
    }
    if ($PSBoundParameters.ContainsKey("Enable")) {
        $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
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

    if ($PSCmdlet.ShouldProcess("domain template [$($Name.Trim())].", "Add")) {
        Write-MailcowHelperLog -Message "Adding domain template [$($Name.Trim())]." -Level Information

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