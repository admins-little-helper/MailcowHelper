function New-DomainAntiSpamPolicy {
    <#
    .SYNOPSIS
        Add a blacklist or whitelist policy for a domain.

    .DESCRIPTION
        Add a blacklist or whitelist policy for a domain.

    .PARAMETER Domain
        The name of the domain for which to create the AntiSpam policy.
        Allows to specify multiple domain names.

    .PARAMETER From
        The from email address or domain.

    .PARAMETER ListType
        Add the specified from address either to the whitelist or blacklist.

    .EXAMPLE
        New-MHDomainAntiSpamPolicy -Domain "example.com" -From "spamexample.com" -ListType Blacklist

        Adds a blacklist entry for domain "example.com" for mails coming from "spamexample.com".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-DomainAntiSpamPolicy.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The domain name to get information for.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String[]]
        $Domain,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The from email address or domain.")]
        [System.String]
        $From,

        [Parameter(Position = 2, Mandatory = $true, HelpMessage = "Add the specified from address either to the whitelist or blacklist.")]
        [ValidateSet("Whitelist", "Blacklist")]
        [System.String]
        $ListType
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/domain-policy/"
    }

    process {
        foreach ($DomainItem in $Domain) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath

            $Body = @{
                domain      = $DomainItem
                object_from = $From
                object_list = switch ($ListType) {
                    "Whitelist" {
                        Write-MailcowHelperLog -Message "[$DomainItem] Adding address record to whitelist."
                        "wl"
                        break
                    }
                    "Blacklist" {
                        Write-MailcowHelperLog -Message "[$DomainItem] Adding address record to blacklist."
                        "bl"
                        break
                    }
                    default {
                        # Should never reach this point.
                        Write-MailcowHelperLog -Message "Unknown value for parameter "List"." -Level Error
                    }
                }
            }

            if ($PSCmdlet.ShouldProcess("domain anti-spam policy for domain [$DomainItem].", "Add")) {
                Write-MailcowHelperLog -Message "Adding domain anti-spam policy for domain [$DomainItem]." -Level Information

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
