function Set-PasswordPolicy {
    <#
    .SYNOPSIS
        Updates the mailcow password policy.

    .DESCRIPTION
        Updates the mailcow password policy.

    .PARAMETER MinimumLength
        The minimum password length.

    .PARAMETER MustContainChar
        If specified, a password must contain at least one character.

    .PARAMETER MustContainSpecialChar
        If specified, a password must contain at least one special character.

    .PARAMETER MustContainLowerUpperCase
        If specified, a password must contain at least one upper and lower case character.

    .PARAMETER MustContainNumber
        If specified, a password must contain at least one number.

    .EXAMPLE
        Set-MHPasswordPolicy

        Returns the mailcow server password policy.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-PasswordPolicy.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The minimum password length.")]
        [ValidateRange(6, 64)]
        [System.Int32]
        $MinimumLength,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "If specified, a password must contain at least one character.")]
        [System.Management.Automation.SwitchParameter]
        $MustContainChar,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "If specified, a password must contain at least one special character.")]
        [System.Management.Automation.SwitchParameter]
        $MustContainSpecialChar,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "If specified, a password must contain at least one upper and lower case character.")]
        [System.Management.Automation.SwitchParameter]
        $MustContainLowerUpperCase,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "If specified, a password must contain at least one number.")]
        [System.Management.Automation.SwitchParameter]
        $MustContainNumber
    )

    begin {
        $UriPath = "edit/passwordpolicy"
    }

    process {
        # Prepare the request body.
        $Body = @{
            attr = @{
                length = $MinimumLength.ToString()
            }
        }
        if ($PSBoundParameters.ContainsKey("MustContainChar")) {
            $Body.attr.chars = if ($MustContainChar.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("MustContainSpecialChar")) {
            $Body.attr.special_chars = if ($MustContainSpecialChar.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("MustContainLowerUpperCase")) {
            $Body.attr.lowerupper = if ($MustContainLowerUpperCase.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("MustContainNumber")) {
            $Body.attr.numbers = if ($MustContainNumber.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("password policy", "Update")) {
            Write-MailcowHelperLog -Message "Updating password policy." -Level Information

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
