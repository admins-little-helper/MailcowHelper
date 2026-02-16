function Get-Ratelimit {
    <#
    .SYNOPSIS
        Get the rate limit for one or more mailboxes or domains.

    .DESCRIPTION
        Get the rate limit for one or more mailboxes or domains.

    .PARAMETER Mailbox
        The mail address for which to get rate-limit information.

    .PARAMETER AllMailboxes
        If specified, get rate-limit information for all mailboxes.

    .PARAMETER Domain
        The name of the domain for which to get rate-limit information.

    .PARAMETER AllDomains
        If specified, get rate-limit information for all domains.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHRatelimit

        By default, the rate-limit settings for all mailboxes are returned.

    .EXAMPLE
        Get-MHRatelimit -AllMailboxes

        Returns the rate limit settings for all mailboxes for which a rate-limit is set.

    .EXAMPLE
        Get-MHRatelimit -Domain "example.com"

        Returns the rate-limit settings for the domain "example.com".

    .EXAMPLE
        Get-MHRatelimit -AllDomains

        Returns the rate limit for all domains for which a rate-limit is set.

    .INPUTS
        System.Net.Mail.MailAddress[]
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Ratelimit.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName = "Mailbox", Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address for which to get rate-limit information.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Mailbox,

        [Parameter(ParameterSetName = "AllMailboxes", Position = 0, Mandatory = $false, ValueFromPipeline = $false, HelpMessage = "If specified, get rate-limit information for all mailboxes.")]
        [System.Management.Automation.SwitchParameter]
        $AllMailboxes,

        [Parameter(ParameterSetName = "Domain", Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The name of the domain for which to get rate-limit information.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String[]]
        $Domain,

        [Parameter(ParameterSetName = "AllDomains", Position = 0, Mandatory = $false, ValueFromPipeline = $false, HelpMessage = "If specified, get rate-limit information for all domains.")]
        [System.Management.Automation.SwitchParameter]
        $AllDomains,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        switch ($PSCmdlet.ParameterSetName) {
            "Mailbox" {
                # Prepare the base Uri path for mailbox based rate-limit.
                $UriPath = "get/rl-mbox/"
                $RequestedMailbox = foreach ($MailboxItem in $Mailbox) {
                    # The the mail address as string.
                    $MailboxItem.Address
                }
                break
            }
            "AllMailboxes" {
                if ($AllMailboxes.IsPresent) {
                    # Prepare the base Uri path for mailbox based rate-limit.
                    $UriPath = "get/rl-mbox/"
                    $RequestedMailbox = "all"
                }
                break
            }
            "Domain" {
                # Prepare the base Uri path for domain based rate-limit.
                $UriPath = "get/rl-domain/"
                if ($Domain -contains "all") {
                    # If the domain parameter was specified and one of the specified parameters is "all", then ignore all other specified values, in case there are some.
                    # This is just to prevent multiple API calls in case somebody specifies "all" together with individual domain names, which makes no sense.
                    $Domain = "all"
                }
                break
            }
            "AllDomains" {
                if ($AllDomains.IsPresent) {
                    # Prepare the base Uri path for domain based rate-limit.
                    $UriPath = "get/rl-domain/"
                    $Domain = "all"
                }
                break
            }
            default {
                # Should never reach this point.
                Write-MailcowHelperLog -Message "Error - invalid parameter set name!" -Level Error
            }
        }
    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            { $_ -eq "Mailbox" -or $_ -eq "AllMailboxes" } {
                foreach ($RequestedMailboxItem in $RequestedMailbox) {
                    # Build full Uri.
                    $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($RequestedMailboxItem.ToLower())

                    # Execute the API call.
                    $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

                    # Return result.
                    if ($Raw.IsPresent) {
                        # Return the result in raw format.
                        $Result
                    }
                    else {
                        # Prepare the result in a custom format.
                        $ConvertedResult = foreach ($ResultItem in $Result) {
                            $ConvertedItem = [PSCustomObject]@{
                                Mailbox = $RequestedMailboxItem # there is no attribute mailbox in the result, if a specific mailbox is queried.
                                Value   = $ResultItem.value
                                Frame   = $ResultItem.frame
                            }
                            if ($null -ne $ResultItem.mailbox) {
                                # If the value for parameter mailbox is $null then the requested mailboxitem will be set to "all".
                                # In that case the result contains an attribute "mailbox" with the email address of the mailbox.
                                $ConvertedItem.Mailbox = $ResultItem.mailbox
                            }
                            $ConvertedItem.PSObject.TypeNames.Insert(0, "MHRatelimitMailbox")
                            $ConvertedItem
                        }
                        # Return the result in custom format.
                        $ConvertedResult
                    }
                }
                break
            }
            { $_ -eq "Domain" -or $_ -eq "AllDomains" } {
                foreach ($DomainItem in $Domain) {
                    # Build full Uri.
                    $RequestUriPath = $UriPath + $($DomainItem.ToLower())

                    # Execute the API call.
                    $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

                    # Return result.
                    if ($Raw.IsPresent) {
                        # Return the result in raw format.
                        $Result
                    }
                    else {
                        # Prepare the result in a custom format.
                        $ConvertedResult = foreach ($ResultItem in $Result) {
                            $ConvertedItem = [PSCustomObject]@{
                                Domain = $DomainItem
                                Value  = $ResultItem.value
                                Frame  = $ResultItem.frame
                            }
                            if ($null -ne $ResultItem.mailbox) {
                                # If the value for parameter domain is $null then the requested domainitem will be set to "all".
                                # In that case the result contains an attribute "domain" with the domain name..
                                $ConvertedItem.Domain = $ResultItem.domain
                            }
                            $ConvertedItem.PSObject.TypeNames.Insert(0, "MHRatelimitDomain")
                            $ConvertedItem
                        }
                        # Return the result in custom format.
                        $ConvertedResult
                    }
                }
                break
            }
            default {
                # Should never reach this point.
                Write-MailcowHelperLog -Message "Error - invalid parameter set name!" -Level Error
            }
        }
    }
}
