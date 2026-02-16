function Write-MailcowHelperLog {
    [CmdletBinding()]
    <#
    .SYNOPSIS
        Adds the current date/time and the calling function"s name to the specified message and writes it to the specified stream.

    .DESCRIPTION
        Adds the current date/time and the calling function"s name to the specified message and writes it to the specified stream.

    .PARAMETER Message
        The message to write.

    .PARAMETER Level
        Specify to which stream the message should be written.

    .EXAMPLE
        Write-MailcowHelperLog -Message "This works!" -Level Information

        Write the string "This works!" to the information stream.

    .EXAMPLE
        Write-MailcowHelperLog -Message "You have been warned!" -Level Warning

        Write the string "You have been warned!" to the warning stream.

    .INPUTS
        Nothing

    .OUTPUTS
        [System.String[]]

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Write-MailcowHelperLog.md
    #>

    param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The message to write.")]
        [System.String]
        $Message,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Specify to which stream the message should be written.")]
        [ValidateSet("Debug", "Verbose", "Information", "Warning", "Error")]
        [System.String]
        $Level = "Verbose"
    )

    # Prepand date/time and calling function name.
    $DateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
    $Message = "[$DateTime] [$(((Get-PSCallStack)[1]).Command)] $Message"

    switch ($Level) {
        "Debug" {
            Write-Debug -Message $Message
            break
        }
        "Verbose" {
            Write-Verbose -Message $Message
            break
        }
        "Information" {
            Write-Information -MessageData $Message -InformationAction Continue
            break
        }
        "Warning" {
            Write-Warning -Message $Message
            break
        }
        "Error" {
            Write-Error -Message $Message
            break
        }
        default {
            #tbd
        }
    }
}