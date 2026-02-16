function Remove-DomainTemplate {
    <#
    .SYNOPSIS
        Remove one or more domain templates.

    .DESCRIPTION
        Remove one or more domain templates.

    .PARAMETER Id
        The id of the domain template to delete.

    .EXAMPLE
        Remove-MHDomainTemplate -Id 17

        Deletes domain template with id 17.

    .EXAMPLE
        (Get-MHDomainTemplate | Where-Object {$_.Name -eq "test"}).Id | Remove-MHDomainTemplate

        Get the domain template with name "test" and delete it.

    .INPUTS
        System.Int64[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-DomainTemplate.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The id of the domain template to delete.")]
        [System.Int64[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/domain/template/"
    }

    process {
        # Make an API call for each ID.
        # The API shouuld be able to handle multiple IDs in "$Body.ids" as an array. But this seems not to work correctly.
        foreach ($IdItem in $Id) {
            # Prepare the request body.
            $Body = @{
                ids = $IdItem.ToSTring()
            }

            if ($PSCmdlet.ShouldProcess("domain template [$IdItem].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting domain template [$IdItem]." -Level Warning

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
