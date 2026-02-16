function Remove-DomainTag {
    <#
    .SYNOPSIS
        Remove one or more tags from one or more domains.

    .DESCRIPTION
        Remove one or more tags from one or more domains.

    .PARAMETER Identity
        The domain name from where to remove a tag.

    .PARAMETER Tag
        The tag to remove.

    .EXAMPLE
        Remove-MHDomainTag -Identity "example.com" -Tag "MyTag"

        Removes the tag "MyTag" from domain "example.com".

    .EXAMPLE
        Get-MHDomain -Tag "MyTag" | Remove-MHDomainTag -Tag "MyTag"

        Gets all domains tagged with "MyTag" and removes that tag.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-DomainTag.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The domain name from where to remove a tag.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [Alias("Domain")]
        [System.String[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The tag to remove.")]
        [System.String[]]
        $Tag
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/domain/tag/"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath + "$($IdentityItem.ToLower())"

            # Prepare the request body.
            $Body = $Tag

            if ($PSCmdlet.ShouldProcess("domain tag [$($Tag -join ',')]", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting domain tag [$($Tag -join ',')] from domain [$DomainItem]." -Level Warning

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
