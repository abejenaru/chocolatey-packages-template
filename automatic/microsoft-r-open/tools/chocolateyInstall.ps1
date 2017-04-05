﻿$ErrorActionPreference = 'Stop';

$packageName    = '{{PackageName}}'
$packageVersion = '{{PackageVersion}}'
$url            = '{{DownloadUrl}}'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$osBitness      = Get-ProcessorBits

# check OS bitness
if (!([Environment]::Is64BitOperatingSystem)) {
  Write-Error "Microsoft R Open requires 64bit operating system"
  exit
}

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url64         = $url

  softwareName  = 'Microsoft R Open*'

  checksum64    = '{{Checksum}}'
  checksumType64= 'sha256'

  silentArgs    = "/s /full /install"
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

# Create desktop shortcut
$desktop = $([System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::DesktopDirectory))
$installDir = "$env:ProgramFiles\Microsoft\MRO-$packageVersion"
$link = Join-Path $desktop "Microsoft R Open.lnk"
if (!(Test-Path $link)) {
    Install-ChocolateyShortcut -ShortcutFilePath "$link" -TargetPath "$installDir\bin\x$osBitness\rgui.exe"
}
