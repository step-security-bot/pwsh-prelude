﻿@{
  ModuleVersion = '1.0.7.24'
  RootModule = 'pwsh-handy-helpers.psm1'
  GUID = '5af3199a-e01b-4ed6-87ad-fdea39aa7e77'
  CompanyName = 'MyBusiness'
  Author = 'Jason Wohlgemuth'
  Copyright = '(c) 2020 Jason Wohlgemuth. All rights reserved.'
  Description = 'Helper functions, aliases, application frameworks, and more'
  PowerShellVersion = '5.0'
  FileList = @()
  CmdletsToExport = @()
  VariablesToExport = @()
  AliasesToExport = @(
    '~'
    'basicauth'
    'dip'
    'dra'
    'drai'
    'dropWhile'
    'equal'
    'input'
    'insert'
    'irc'
    'listenFor'
    'listenTo'
    'max'
    'menu'
    'method'
    'min'
    'money'
    'on'
    'op'
    'prop'
    'reduce'
    'remove'
    'repeat'
    'rf'
    'say'
    'takeWhile'
    'title'
    'touch'
    'tpl'
    'transform'
    'trigger'
    'zip'
    'zipWhile'
  )
  FunctionsToExport = @(
    'ConvertFrom-ByteArray'
    'ConvertFrom-Html'
    'ConvertFrom-QueryString'
    'ConvertTo-PowershellSyntax'
    'ConvertTo-Iso8601'
    'ConvertTo-QueryString'
    'Enable-Remoting'
    'Find-Duplicate'
    'Find-FirstIndex'
    'Format-MoneyValue'
    'Get-Extremum'
    'Get-File'
    'Get-GithubOAuthToken'
    'Get-Maximum'
    'Get-Minimum'
    'Get-State'
    'Home'
    'Import-Html'
    'Install-SshServer'
    'Invoke-DockerInspectAddress'
    'Invoke-DockerRemoveAll'
    'Invoke-DockerRemoveAllImage'
    'Invoke-DropWhile'
    'Invoke-FireEvent'
    'Invoke-GetProperty'
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
    'Invoke-Once'
    'Invoke-Operator'
    'Invoke-PropertyTransform'
    'Invoke-Reduce'
    'Invoke-RemoteCommand'
    'Invoke-RunApplication'
    'Invoke-Speak'
    'Invoke-TakeWhile'
    'Invoke-WebRequestBasicAuth'
    'Invoke-Zip'
    'Invoke-ZipWith'
    'Join-StringsWithGrammar'
    'New-ApplicationTemplate'
    'New-DailyShutdownJob'
    'New-File'
    'New-ProxyCommand'
    'New-SshKey'
    'New-Template'
    'Open-Session'
    'Out-Default'
    'Remove-Character'
    'Remove-DailyShutdownJob'
    'Remove-DirectoryForce'
    'Remove-Indent'
    'Rename-FileExtension'
    'Save-State'
    'Show-BarChart'
    'Take'
    'Test-Admin'
    'Test-Empty'
    'Test-Equal'
    'Test-Installed'
    'Use-Grammar'
    'Use-Speech'
    'Use-Web'
    'Write-Color'
    'Write-Label'
    'Write-Repeat'
    'Write-Title'
  )
  PrivateData = @{
    PSData = @{
      Tags = @('dev', 'helpers', 'git', 'docker', 'fp', 'cli', 'app', 'scrapp')
      LicenseUri = 'https://github.com/jhwohlgemuth/pwsh-handy-helpers/blob/master/LICENSE'
      ProjectUri = 'https://github.com/jhwohlgemuth/pwsh-handy-helpers'
    }
  }
}
