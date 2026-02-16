function Remove-AliasDomain {
    <#
    .SYNOPSIS
        Removes an alias domain.

    .DESCRIPTION
        Removes an alias domain.

    .PARAMETER Identity
        The alias domain name.

    .EXAMPLE
        Remove-MHAliasDomain -Identity "alias.example.com"

        Remove the alias domain "alias.example.com".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-AliasDomain.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The alias domain name.")]
        [MailcowHelperArgumentCompleter("AliasDomain")]
        [Alias("AliasDomain", "Domain")]
        [System.String[]]
        $Identity
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/alias-domain"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Check if the specified alias exists. Show warning in case it does not.
            $CurrentAliasDomain = Get-AliasDomain -Identity $IdentityItem

            if ($null -eq $CurrentAliasDomain) {
                # Show warning about non-existent alias-domain.
                Write-MailcowHelperLog -Message "[$($IdentityItem.Trim().ToLower())] Alias not found!" -Level Warning
            }
            else {
                # Prepare the request body.
                $Body = $IdentityItem.Trim().ToLower()

                if ($PSCmdlet.ShouldProcess("alias domain [$IdentityItem].", "Delete")) {
                    Write-MailcowHelperLog -Message "Deleting alias domain [$IdentityItem]."

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
}
