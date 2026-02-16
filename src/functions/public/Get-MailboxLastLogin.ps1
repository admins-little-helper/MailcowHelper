function Get-MailboxLastLogin {
    <#
    .SYNOPSIS
        Return information about the last login to one or more mailboxes.

    .DESCRIPTION
        Return information about the last login to one or more mailboxes.

    .PARAMETER Identity
        The mail address for which to get information.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHMailboxLastLogin -Identity "user123@example.com"

        Return the last login information for the user mailbox "user123@example.com".

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailboxLastLogin.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address for which to get information.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Build full Uri.
        $UriPath = "get/last-login/"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdentityItem.Address)

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result.sasl) {
                    $ConvertedItem = [PSCustomObject]@{
                        DateTime        = if ($Item.datetime) { (Get-Date -Date $Item.datetime) }
                        Service         = $Item.service
                        RealIP          = $Item.real_rip
                        AppPasswordUsed = [System.Boolean][System.Int32]$Item.app_password
                        AppPasswordName = $Item.app_password_name
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHMailboxLastLogin")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}