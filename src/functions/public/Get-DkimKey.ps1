function Get-DkimKey {
    <#
    .SYNOPSIS
        Get the DKIM key for a specific domain or for all domains.

    .DESCRIPTION
        Get the DKIM key for a specific domain or for all domains.

    .PARAMETER Identity
        Domain name to get DKIM key for.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHDkimKey

        Returns DKIM keys for all domains.

    .EXAMPLE
        Get-MHDkimKey -Domain "example.com"

        Returns DKIM key for the domain "example.com".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-DkimKey.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "Domain name to get DKIM key for.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [Alias("Domain")]
        [System.String[]]
        $Identity = "All",

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/dkim/"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            if ($IdentityItem -eq "All") {
                # Get all mailcow domains first.
                $MailcowDomains = Get-Domain -Identity "All" -Raw

                # Call the function recursively for each domain.
                foreach ($MailcowDomainItem in $MailcowDomains) {
                    $GetMailcowDKIMParam = @{
                        Identity = $MailcowDomainItem.domain_name
                    }
                    Get-DKIMKey @GetMailcowDKIMParam
                }
            }
            else {
                # Build full Uri.
                $RequestUriPath = $UriPath + "$($IdentityItem.ToLower())"

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
                        $ConvertedItem = [PSCustomObject]@{
                            Domain        = $IdentityItem.ToLower()
                            PublicKey     = $Item.pubkey
                            KeyLength     = $Item.length
                            DKIM_TXT      = $Item.dkim_txt
                            DKIM_Selector = $Item.dkim_selector
                            PrivateKey    = $Item.privkey
                        }
                        $ConvertedItem.PSObject.TypeNames.Insert(0, "MHDkimKey")
                        $ConvertedItem
                    }
                    # Return the result in custom format.
                    $ConvertedResult
                }
            }
        }
    }
}
