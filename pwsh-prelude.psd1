﻿@{
  ModuleVersion = '0.0.52'
  RootModule = 'pwsh-prelude.psm1'
  GUID = '5af3199a-e01b-4ed6-87ad-fdea39aa7e77'
  CompanyName = 'Wohlgemuth Technology Foundation'
  Author = 'Jason Wohlgemuth'
  Copyright = '(c) 2020 Jason Wohlgemuth. All rights reserved.'
  Description = 'A "standard" library for PowerShell inspired by the preludes of other languages'
  PowerShellVersion = '5.0'
  FileList = @()
  CmdletsToExport = @()
  VariablesToExport = @()
  FormatsToProcess = @(
    'formats/Matrix.Format.ps1xml'
  )
  TypesToProcess = @(
    'types\Int.Types.ps1xml'
    'types\String.Types.ps1xml'
    'types\Array.Types.ps1xml'
    'types\Hashtable.Types.ps1xml'
    'types\Matrix.Types.ps1xml'
    'types\FileInfo.Types.ps1xml'
  )
  AliasesToExport = @(
    '~'
    'basicauth'
    'chunk'
    'covariance'
    'dip'
    'dra'
    'drai'
    'dropWhile'
    'equal'
    'flatten'
    'fromPair'
    'input'
    'insert'
    'invert'
    'irc'
    'listenFor'
    'listenTo'
    'matrix'
    'max'
    'mean'
    'median'
    'menu'
    'merge'
    'method'
    'min'
    'money'
    'on'
    'op'
    'partition'
    'plain'
    'permute'
    'prop'
    'reduce'
    'remove'
    'repeat'
    'rf'
    'say'
    'sigmoid'
    'tap'
    'takeWhile'
    'title'
    'touch'
    'tpl'
    'toDegree'
    'toPair'
    'toRadian'
    'transform'
    'trigger'
    'screenshot'
    'variance'
    'unzip'
    'zip'
    'zipWith'
  )
  FunctionsToExport = @(
    'ConvertFrom-ByteArray'
    'ConvertFrom-Html'
    'ConvertFrom-Pair'
    'ConvertFrom-QueryString'
    'ConvertTo-AbstractSyntaxTree'
    'ConvertTo-Degree'
    'ConvertTo-PowershellSyntax'
    'ConvertTo-Iso8601'
    'ConvertTo-Pair'
    'ConvertTo-PlainText'
    'ConvertTo-QueryString'
    'ConvertTo-Radian'
    'Enable-Remoting'
    'Find-Duplicate'
    'Find-FirstIndex'
    'Format-MoneyValue'
    'Get-ArcHaversine'
    'Get-Covariance'
    'Get-EarthRadius'
    'Get-Extremum'
    'Get-Factorial'
    'Get-File'
    'Get-GithubOAuthToken'
    'Get-Haversine'
    'Get-HaversineDistance'
    'Get-HostsContent'
    'Get-LogisticSigmoid'
    'Get-Maximum'
    'Get-Mean'
    'Get-Minimum'
    'Get-Permutation'
    'Get-Property'
    'Get-Screenshot'
    'Get-State'
    'Get-Variance'
    'Home'
    'Import-Excel'
    'Import-Html'
    'Install-SshServer'
    'Invoke-Chunk'
    'Invoke-DockerInspectAddress'
    'Invoke-DockerRemoveAll'
    'Invoke-DockerRemoveAllImage'
    'Invoke-DropWhile'
    'Invoke-Flatten'
    'Invoke-FireEvent'
    'Invoke-GitCommand'
    'Invoke-GitCommit'
    'Invoke-GitDiff'
    'Invoke-GitPushMaster'
    'Invoke-GitStatus'
    'Invoke-GitRebase'
    'Invoke-GitLog'
    'Invoke-Input'
    'Invoke-InsertString'
    'Invoke-ListenTo'
    'Invoke-ListenForWord'
    'Invoke-Menu'
    'Invoke-Method'
    'Invoke-ObjectInvert'
    'Invoke-ObjectMerge'
    'Invoke-Once'
    'Invoke-Operator'
    'Invoke-Partition'
    'Invoke-PropertyTransform'
    'Invoke-Reduce'
    'Invoke-RemoteCommand'
    'Invoke-RunApplication'
    'Invoke-Speak'
    'Invoke-TakeWhile'
    'Invoke-Tap'
    'Invoke-Unzip'
    'Invoke-WebRequestBasicAuth'
    'Invoke-Zip'
    'Invoke-ZipWith'
    'Join-StringsWithGrammar'
    'New-ApplicationTemplate'
    'New-DailyShutdownJob'
    'New-File'
    'New-Matrix'
    'New-ProxyCommand'
    'New-SshKey'
    'New-Template'
    'Open-Session'
    'Out-Browser'
    'Remove-Character'
    'Remove-DailyShutdownJob'
    'Remove-DirectoryForce'
    'Remove-Indent'
    'Rename-FileExtension'
    'Save-State'
    'Take'
    'Test-Admin'
    'Test-DiagonalMatrix'
    'Test-Empty'
    'Test-Equal'
    'Test-Installed'
    'Test-SquareMatrix'
    'Test-SymmetricMatrix'
    'Update-HostsFile'
    'Use-Grammar'
    'Use-Speech'
    'Use-Web'
    'Write-BarChart'
    'Write-Color'
    'Write-Label'
    'Write-Repeat'
    'Write-Title'
  )
  PrivateData = @{
    PSData = @{
      Tags = @('dev', 'helpers', 'git', 'docker', 'fp', 'cli', 'app', 'scrapp')
      LicenseUri = 'https://github.com/jhwohlgemuth/pwsh-prelude/blob/master/LICENSE'
      ProjectUri = 'https://github.com/jhwohlgemuth/pwsh-prelude'
    }
  }
}
