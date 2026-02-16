function Get-DomainAntiSpamPolicy {
    <#
    .SYNOPSIS
        Get blacklist or whitelist policies for a domain.

    .DESCRIPTION
        Get blacklist or whitelist policies for a domain.

    .PARAMETER Identity
        The name of the domain for which to get the AntiSpam policy.

    .PARAMETER ListType
        Either blacklist or whitelist.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHDomainAntiSpamPolicy -ListType Whitelist

        Returns whitelist policies for all domains.

    .EXAMPLE
        Get-MHDomainAntiSpamPolicy -Domain "example.com" -ListType Blacklist

        Returns blacklits policies for domain "example.com".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-DomainAntiSpamPolicy.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The domain name to get information for.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [Alias("Domain")]
        [System.String[]]
        $Identity = "All",

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "If specified, returns the blacklist records for the specified domain.")]
        [ValidateSet("Blacklist", "Whitelist")]
        [System.String]
        $ListType,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        switch ($ListType) {
            "Blacklist" {
                $UriPath = "get/policy_bl_domain/"
                break
            }
            "Whitelist" {
                $UriPath = "get/policy_wl_domain/"
                break
            }
            default {
                # Should not reach this point.
                throw "Error: Unknown listtype specified!"
            }
        }

        if ($Identity -eq "All") {
            # Get all domains.
            $MailcowDomains = (Get-Domain -Domain "All").DomainName
        }
        else {
            # Get the specified domain(s).
            $MailcowDomains = $Identity
        }
    }

    process {
        # Get specified list for each domain.
        foreach ($MailcowDomainItem in $MailcowDomains) {
            # Build full Uri.
            $RequestUriPath = $UriPath + $($MailcowDomainItem.ToLower())

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if (-not [System.String]::IsNullOrEmpty($Result)) {
                $ListCount = ($Result | Measure-Object).Count
                Write-MailcowHelperLog -Message "[$MailcowDomainItem] returned [$ListCount] policies."

                if ($Raw.IsPresent) {
                    # Return the result in raw format.
                    $Result
                }
                else {
                    # Prepare the result in a custom format.
                    $ConvertedResult = foreach ($Item in $Result) {
                        $ConvertedItem = [PSCustomObject]@{
                            Object = $Item.object
                            Value  = $Item.value
                            PrefId = $Item.prefid
                        }
                        $ConvertedItem.PSObject.TypeNames.Insert(0, "MHDomainAntiSpamPolicy")
                        $ConvertedItem
                    }
                    # Return the result in custom format.
                    $ConvertedResult
                }
            }
        }
    }
}
