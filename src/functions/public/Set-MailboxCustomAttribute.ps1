function Set-MailboxCustomAttribute {
    <#
    .SYNOPSIS
        Updates custom attributes for one or more mailboxes.

    .DESCRIPTION
        Updates custom attributes for one or more mailboxes.

    .PARAMETER Identity
        The mail address of the mailbox for which to update custom attributes.

    .PARAMETER AttributeValuePair
        The key value pair to set as custom attribute. Expects a hashtable.

    .EXAMPLE
        Set-MHMailboxCustomAttribute -Identity "user123@example.com" -AttributeValuePair @{VIPUser = "1"}

        Adds the custom attribute name "VIPuser" with value "1" on the mailbox of "user123@example.com".

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxCustomAttribute.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $true)]
        [System.Collections.Hashtable]
        $AttributeValuePair
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/mailbox/custom-attribute"
    }

    process {
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
            attr  = @{
                attribute = $AttributeValuePair.Keys
                value     = $AttributeValuePair.Values
            }
        }

        Write-Warning -Message "CAUTION: Setting custom attributes will overwrite any existing attributes for the specified mailbox!"

        if ($PSCmdlet.ShouldProcess("custom mailbox attributes for [$LogIdString].", "Update")) {
            Write-MailcowHelperLog -Message "Updating custom mailbox attributes for [$LogIdString]." -Level Information

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
