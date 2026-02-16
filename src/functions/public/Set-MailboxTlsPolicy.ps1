function Set-MailboxTlsPolicy {
    <#
    .SYNOPSIS
        Updates the TLS policy for incoming and outgoing connections for one or more mailboxes.

    .DESCRIPTION
        Updates the TLS policy for incoming and outgoing connections for one or more mailboxes.

    .PARAMETER Identity
        The mail address of the mailbox for which to set the TLS policy.

    .PARAMETER EnforceTlsIn
        Enforce TLS for incoming connections.

    .PARAMETER EnforceTlsOut
        Enforce TLS for outgoing connections.

    .EXAMPLE
        Set-MHMailboxTlsPolicy -Identity "user123@example.com" -EnforceTlsIn -EnforceTlsOut

        Enable TLS policy for incoming and outgoing connections for the mailbox of the user "user123@example.com".

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxQuarantineNotification.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to set the TLS policy.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Enforce TLS for incoming connections for this mailbox.")]
        [System.Management.Automation.SwitchParameter]
        $EnforceTlsIn,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Enforce TLS for outgoing connections from this mailbox.")]
        [System.Management.Automation.SwitchParameter]
        $EnforceTlsOut
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/tls_policy"
    }

    process {
        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        # Prepare a string that will be used for logging.
        $LogIdString = if ($Identity.Count -gt 1) {
            "$($Identity.Count) mailboxes"
        }
        else {
            foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
        }

        # Prepare the request body.
        $Body = @{
            # Assign all mail addresses to the "items" attribute.
            items = foreach ($IdentityItem in $Identity) {
                $IdentityItem.Address
            }
            attr  = @{}
        }

        if ($PSBoundParameters.ContainsKey("EnforceTlsIn")) {
            $Body.attr.tls_enforce_in = if ($EnforceTlsIn.IsPresent) {
                Write-MailcowHelperLog -Message "[$LogIdString] Enable enforcing TLS for incoming connections for the mailbox."
                "1"
            }
            else {
                Write-MailcowHelperLog -Message "[$LogIdString] Disable enforcing TLS for incoming connections for the mailbox."
                "0"
            }
        }
        if ($PSBoundParameters.ContainsKey("EnforceTlsOut")) {
            $Body.attr.tls_enforce_out = if ($EnforceTlsOut.IsPresent) {
                Write-MailcowHelperLog -Message "[$LogIdString] Enable enforcing TLS for Outgoing connections for the mailbox."
                "1"
            }
            else {
                Write-MailcowHelperLog -Message "[$LogIdString] Disable enforcing TLS for Outgoing connections for the mailbox."
                "0"
            }
        }

        if ($PSCmdlet.ShouldProcess("mailbox TLS policy [$LogIdString].", "Update")) {
            Write-MailcowHelperLog -Message "Updating mailbox TLS policy [$LogIdString]." -Level Information

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
