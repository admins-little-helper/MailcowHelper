function Remove-AliasMail {
    <#
    .SYNOPSIS
        Removes one or more mail aliases.

    .DESCRIPTION
        Removes one or more mail aliases.

    .PARAMETER Identity
        The alias mail address to remove.

    .EXAMPLE
        Remove-MHMailAlias -Identity alias@example.com

        Removes alias@example.com.

    .EXAMPLE
        Get-MHMailAlias -Identity "alias@example.com" | Remove-MHMailAlias

        Removes alias@example.com by piping the output of Get-AliasMail to Remove-MHMailAlias.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-AliasMail.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The alias mail address to remove.")]
        [MailcowHelperArgumentCompleter("Alias")]
        [Alias("Alias")]
        [System.Net.Mail.MailAddress[]]
        $Identity
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/alias"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath

            # Get the id value of each individual alias. This allows to check if the alias exists and show warning in case it does not.
            $AliasId = Get-AliasMail -Identity $IdentityItem.Address
            if ($null -eq $AliasId) {
                Write-MailcowHelperLog -Message "[$($IdentityItem.Address)] Alias not found!" -Level Warning
            }
            else {
                Write-MailcowHelperLog -Message "[$($IdentityItem.Address)] Deleting alias with id [$($AliasId.id)]."
            }

            # Prepare the request body.
            $Body = $AliasId.id

            if ($PSCmdlet.ShouldProcess("alias [$($IdentityItem.Address)].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting alias [$($IdentityItem.Address)]." -Level Warning

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $RequestUriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams
            }
            # Return the result.
            $Result
        }
    }
}
