function Get-PasswordPolicy {
    <#
    .SYNOPSIS
        Return the password policy configured in mailcow.

    .DESCRIPTION
        Return the password policy configured in mailcow.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHPasswordPolicy

        Returns the mailcow server password policy.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-PasswordPolicy.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    # Prepare the base Uri path.
    $UriPath = "get/passwordpolicy"

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
            $ConvertedItem = [PSCustomObject]@{
                Length       = $Item.length
                Chars        = [System.Boolean][System.Int32]$Item.chars
                SpecialChars = [System.Boolean][System.Int32]$Item.special_chars
                LowerUpper   = [System.Boolean][System.Int32]$Item.lowerupper
                Numbers      = [System.Boolean][System.Int32]$Item.numbers
            }
            $ConvertedItem.PSObject.TypeNames.Insert(0, "MHPasswordPolicy")
            $ConvertedItem
        }
        # Return the result in custom format.
        $ConvertedResult
    }
}
