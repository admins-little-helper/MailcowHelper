# Release Notes

## Table of Contents

- [Release Notes](#release-notes)
  - [Table of Contents](#table-of-contents)
  - [Version 1.2.1 (2026-04-02)](#version-121-2026-04-02)
  - [Version 1.2.0 (2026-04-02)](#version-120-2026-04-02)
  - [Version 1.1.1 (2026-03-07)](#version-111-2026-03-07)
  - [Version 1.1.0 (2026-02-18)](#version-110-2026-02-18)
  - [Version 1.0.2 (2026-02-17)](#version-102-2026-02-17)
  - [Version 1.0.1 (2026-02-17)](#version-101-2026-02-17)
  - [Version 1.0.0 (2026-02-16)](#version-100-2026-02-16)

See [README](README.md) for general information.

## Version 1.2.1 (2026-04-02)

- Fix: Sort order of Get-MHLog is now really as intended.

## Version 1.2.0 (2026-04-02)

- Features
  - Get-MHLog: Changed default sort order of log output to ascending by DateTime.
  - Get-MHLog: Added parameter 'SortDescending' to allow specifying the sort order.
  - Get-MHLog: Showing log priority in color based on priority for Dovecot, Netfilter, Postfix and Sogo log output.

## Version 1.1.1 (2026-03-07)

- Fixes
  - Fixed Set-MHFail2BanConfig: Changes were not set.
  - Added missing confirm option for several Remove-* functions.
  - Removed table column "DomainHName" from default output in 'Get-MHDomain'.
  - Added missing parameter to set a relay host in 'Set-MHDomain'.

## Version 1.1.0 (2026-02-18)

- Fixes
  -  New-MHAlias: Corrected variable name.

- Features
  - New-/Set-MHAlias: Added parameter "AllowSendAs".

## Version 1.0.2 (2026-02-17)

Cosmetic version number increase because ProjectUri and ReleaseUri was added for publishing the module to PowerShellGallery.

## Version 1.0.1 (2026-02-17)

Bugfixes.

- Import-Module failed on Linux due to wrong case in path for format files.
- Fixed ArgumentCompleter.
- Minor fixes.

## Version 1.0.0 (2026-02-16)

This is the initial release of this PowerShell module.

[↑ back to top](#table-of-contents)
