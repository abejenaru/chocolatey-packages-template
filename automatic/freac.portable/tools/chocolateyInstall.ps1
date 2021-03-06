﻿$packageName    = '{{PackageName}}'
$packageVersion = '{{PackageVersion}}'
$url            = '{{DownloadUrl}}'
$checksum       = '{{Checksum}}'
$checksumType   = 'sha256'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"


Install-ChocolateyZipPackage -PackageName "$packageName" -UnzipLocation "$toolsDir" -Url "$url" -Checksum "$checksum" -ChecksumType "$checksumType"

Rename-Item "$toolsDir\freac-$packageVersion-bin" "$toolsDir\bin"

$files = get-childitem "$toolsDir" -include *.exe -exclude freac*.exe -recurse
foreach ($file in $files) {
  New-Item "$file.ignore" -type file -force | Out-Null
}
