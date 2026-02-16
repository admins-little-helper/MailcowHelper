function Remove-AliasTimeLimited {
    <#
    .SYNOPSIS
        Removes one or more time-limited alias (spamalias).

    .DESCRIPTION
        Removes one or more time-limited alias (spamalias).

    .PARAMETER Identity
        The time-limited alias addresss to delete.

    .EXAMPLE
        Remove-MHAliasTimeLimited -Identity "alias@example.com"

        Deletes the alias "alias@example.com"

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-AliasTimeLimited.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = " The time-limited alias addresss to delete.")]
        [Alias("Alias")]
        [System.Net.Mail.MailAddress[]]
        $Identity
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/time_limited_alias"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = $IdentityItem.Address

            if ($PSCmdlet.ShouldProcess("time-limited alias [$($IdentityItem.Address)].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting time-limited alias [$($IdentityItem.Address)] ."

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
