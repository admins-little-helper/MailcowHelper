function Set-MtaSts {
    <#
    .SYNOPSIS
        Updates the MTS-STS policy for one or more domains.

    .DESCRIPTION
        Updates the MTS-STS policy for one or more domains.
        There can only be one MTA-STS policy per domain.
        Refer to the mailcow documentation for more information.

    .PARAMETER Domain
        The name of the domain for which to update a MTA-STS policy.

    .PARAMETER Version
        The MTA-STS version. Only STSv1 is available.

    .PARAMETER Mode
        The MTA-STS mode to use. Valid options are:
        Enforce, Testing, None

    .PARAMETER MxServer
        The MxServer to use.

    .PARAMETER MaxAge
        Time in seconds that receiving mail servers may cache this policy until refetching.

    .EXAMPLE
        Set-MHMtaSts -Domain "example.com" -Mode Enforce -MxServer 1.2.3.4, 5.6.7.8

        Update the MTA-STS policy for domain "example.com" in enforce mode with two MX servers.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MtaSts.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The name of the domain for which to add a MTA-STS policy.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [Alias("Domain")]
        [System.String[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The STS version.")]
        [ValidateSet("STSv1")]
        [System.String]
        $Version = "STSv1",

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The MTA-STS mode to use.")]
        [ValidateSet("Enforce", "Testing", "None")]
        [System.String]
        $Mode = "Enforce",

        [Parameter(Position = 3, Mandatory = $true, HelpMessage = "The MxServer to use.")]
        [System.String[]]
        $MxServer,

        [Parameter(Position = 4, Mandatory = $true, HelpMessage = "Time in seconds that receiving mail servers may cache this policy until refetching.")]
        [ValidateRange(1, 31536000)]
        [System.Int32]
        $MaxAge = 86400 # 86400 seconds = 1 day
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/mta-sts"
    }

    process {
        # Prepare the request body.
        $Body = @{
            items = $Identity
            attr  = @{
                version = $Version.ToLower()
                mode    = $Mode.ToLower()
                mx      = $MxServer -join ","
                max_age = $MaxAge
            }
        }

        Write-MailcowHelperLog -Message "This function updates a MTA-STS policy. To enable or disable a policy you have to use the mailcow admin UI because it is not possible to do this via the API." -Level Warning

        if ($PSCmdlet.ShouldProcess("domain mta-sts [$($Identity -join ", ")].", "Update")) {
            Write-MailcowHelperLog -Message "Updating domain mta-sts [$($Identity -join ", ")]." -Level Information

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
