function Get-DomainTemplate {
    <#
    .SYNOPSIS
        Get information about domain templates.

    .DESCRIPTION
        Get information about domain templates.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHDomainTemplate

        Return all domain templates.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-DomainTemplate.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    # Build full Uri.
    $UriPath = "get/domain/template"

    # Execute the API call.
    $Result = Invoke-MailcowApiRequest -UriPath $UriPath

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
                $RateLimit = "$($Item.attributes.rl.value) msgs/$($Item.attributes.rl.frame)"
            }
            else {
                $RateLimit = "Unlimited"
            }

            $ConvertedItem = [PSCustomObject]@{
                Id                 = $Item.id
                Name               = $Item.template
                Type               = $Item.type
                # Attributes         = $Item.attributes
                MaxNumAliases      = $Item.attributes.max_num_aliases_for_domain
                MaxNumMboxes       = $Item.attributes.max_num_mboxes_for_domain
                DefQuotaForMbox    = $Item.attributes.def_quota_for_mbox
                MaxQuotaForMbox    = $Item.attributes.max_quota_for_mbox
                MaxQuotaForDomain  = $Item.attributes.max_quota_for_domain
                Active             = [System.Boolean][System.Int32]$Item.attributes.active
                Gal                = [System.Boolean][System.Int32]$Item.attributes.gal
                BackupM            = [System.Boolean][System.Int32]$Item.attributes.backupmx
                RelayAllRecipients = [System.Boolean][System.Int32]$Item.attributes.relay_all_recipients
                RelayUnknownOnly   = [System.Boolean][System.Int32]$Item.attributes.relay_unknown_only
                RateLimit          = $RateLimit
                DkimSelector       = $Item.attributes.dkim_selector
                DkimKeySize        = $Item.attributes.key_size
                WhenCreated        = if ($Item.created) { (Get-Date -Date $Item.created) }
                WhenModified       = if ($Item.modified) { (Get-Date -Date $Item.modified) }
            }
            $ConvertedItem.PSObject.TypeNames.Insert(0, "MHDomainTemplate")
            $ConvertedItem
        }
        # Return the result in custom format.
        $ConvertedResult
    }
}