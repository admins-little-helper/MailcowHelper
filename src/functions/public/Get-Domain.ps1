function Get-Domain {
    <#
    .SYNOPSIS
        Get information about one or more domains registered on the mailcow server.

    .DESCRIPTION
        Get information about one or more domains registered on the mailcow server.

    .PARAMETER Identity
        The name of the domain for which to get information.
        By default, information for all domains are returned.

    .PARAMETER Tag
        A tag to filter the result on.
        This is only relevant if parameter "Identity" is not specified or if it is set to value "All" to return all domains.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHDomain

        Return information for all domains.

    .EXAMPLE
        Get-MHDomain -Domain "example.com"

        Returns information for domain "example.com".

    .EXAMPLE
        Get-MHDomain -Tag "MyTag"

        Returns information for all domais tagged with "MyTag".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author: Dieter Koch
        Email: diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Domain.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The name of the domain for which to request information.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [Alias("Domain")]
        [System.String[]]
        $Identity = "All",

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "A tag to filter the result on.")]
        [System.String[]]
        $Tag,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/domain/"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath + "$($IdentityItem.ToLower())"

            # If specified, append the UrlEncoded tag values as comma separated list.
            if (-not [System.String]::IsNullOrEmpty($Tag)) {
                $RequestUriPath += "?tags=" + [System.Web.HttpUtility]::UrlEncode($Tag -join ",")
            }

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    # Get the rate limit and show it in a nicer way.
                    if ($Item.rl.value) {
                        $RateLimit = "$($Item.rl.value) msgs/$($Item.rl.frame)"
                    }
                    else {
                        $RateLimit = "Unlimited"
                    }

                    # Get name of relayhost.
                    $RelayHostName = (Get-RoutingRelayHost -Id $Item.relayhost).Hostname

                    $ConvertedItem = [PSCustomObject]@{
                        DomainName            = $Item.domain_name
                        DomainHName           = $Item.domain_h_name
                        Description           = $Item.description
                        MaxNewMailboxQuota    = $Item.max_new_mailbox_quota
                        DefNewMailboxQuota    = $Item.def_new_mailbox_quota
                        QuotaUsedInDomain     = $Item.quota_used_in_domain
                        BytesTotal            = $Item.bytes_total
                        MsgsTotal             = $Item.msgs_total
                        MboxCount             = $Item.mboxes_in_domain
                        MboxesLeft            = $Item.mboxes_left
                        MaxNumAliases         = $Item.max_num_aliases_for_domain
                        MaxNumMboxes          = $Item.max_num_mboxes_for_domain
                        DefQuotaForMbox       = $Item.def_quota_for_mbox
                        MaxQuotaForMbox       = $Item.max_quota_for_mbox
                        MaxQuotaForDomain     = $Item.max_quota_for_domain
                        Relayhost             = $RelayHostName
                        AliasCount            = $Item.aliases_in_domain
                        AliasesLeft           = $Item.aliases_left
                        DomainAdmins          = $Item.domain_admins
                        BackupM               = [System.Boolean][System.Int32]$Item.backupmx
                        BackupMXInt           = [System.Boolean][System.Int32]$Item.backupmx_int
                        Gal                   = [System.Boolean][System.Int32]$Item.gal
                        GalInt                = [System.Boolean][System.Int32]$Item.gal_int
                        Active                = [System.Boolean][System.Int32]$Item.active
                        ActiveInt             = [System.Boolean][System.Int32]$Item.active_int
                        RelayAllRecipients    = [System.Boolean][System.Int32]$Item.relay_all_recipients
                        RelayAllRecipientsInt = [System.Boolean][System.Int32]$Item.relay_all_recipients_int
                        RelayUnknownOnly      = [System.Boolean][System.Int32]$Item.relay_unknown_only
                        RelayUnknownOnlyInt   = [System.Boolean][System.Int32]$Item.relay_unknown_only_int
                        RateLimit             = $RateLimit
                        WhenCreated           = if ($Item.created) { (Get-Date -Date $Item.created) }
                        WhenModified          = if ($Item.modified) { (Get-Date -Date $Item.modified) }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHDomain")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}
