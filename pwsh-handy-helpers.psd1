﻿@{
  ModuleVersion = '1.0.7.12'
  RootModule = 'pwsh-handy-helpers.psm1'
  GUID = '5af3199a-e01b-4ed6-87ad-fdea39aa7e77'
  CompanyName = 'MyBusiness'
  Author = 'Jason Wohlgemuth'
  Copyright = '(c) 2020 Jason Wohlgemuth. All rights reserved.'
  Description = 'Helper functions, aliases and more'
  PowerShellVersion = '5.0'
  FileList = @()
  CmdletsToExport = @()
  VariablesToExport = @()
  AliasesToExport = @(
    '~'
    'dip'
    'dra'
    'drai'
    'equal'
    'input'
    'insert'
    'irc'
    'listenFor'
    'listenTo'
    'menu'
    'money'
    'on'
    'reduce'
    'remove'
    'repeat'
    'rf'
    'say'
    'title'
    'touch'
    'tpl'
    'transform'
    'trigger'
  )
  FunctionsToExport = @(
    'ConvertTo-PowershellSyntax'
    'Enable-Remoting'
    'Find-Duplicate'
    'Find-FirstIndex'
    'Format-MoneyValue'
    'Get-File'
    'Home'
    'Install-SshServer'
    'Invoke-DockerInspectAddress'
    'Invoke-DockerRemoveAll'
    'Invoke-DockerRemoveAllImage'
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
    'Invoke-Once'
    'Invoke-PropertyTransform'
    'Invoke-Reduce'
    'Invoke-RemoteCommand'
    'Invoke-RunApplication'
    'Invoke-Speak'
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
    'Show-BarChart'
    'Take'
    'Test-Admin'
    'Test-Empty'
    'Test-Equal'
    'Test-Installed'
    'Use-Grammar'
    'Use-Speech'
    'Write-Color'
    'Write-Label'
    'Write-Repeat'
    'Write-Title'
  )
  PrivateData = @{
    PSData = @{
      Tags = @('dev', 'helpers', 'git', 'docker')
      LicenseUri = 'https://github.com/jhwohlgemuth/pwsh-handy-helpers/blob/master/LICENSE'
      ProjectUri = 'https://github.com/jhwohlgemuth/pwsh-handy-helpers'
    }
  }
}
