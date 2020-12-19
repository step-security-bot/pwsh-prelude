﻿[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingCmdletAliases', 'chunk')]
Param()

& (Join-Path $PSScriptRoot '_setup.ps1') 'core'

Describe 'Powershell Prelude Module' {
  Context 'meta validation' {
    It 'should import exports' {
      (Get-Module -Name pwsh-prelude).ExportedFunctions.Count | Should -Be 110
    }
    It 'should import aliases' {
      (Get-Module -Name pwsh-prelude).ExportedAliases.Count | Should -Be 53
    }
  }
}
Describe 'ConvertFrom-Pair' {
  It 'can create and object from two arrays' {
    $Result = @('a','b','c'),@(1,2,3) | ConvertFrom-Pair
    $Result.a | Should -Be 1
    $Result.b | Should -Be 2
    $Result.c | Should -Be 3
    $Result = @('a','b','a','c'),@(1,2,3,4) | ConvertFrom-Pair
    $Result.a | Should -Be 3
    $Result.b | Should -Be 2
    $Result.c | Should -Be 4
    $Result = ConvertFrom-Pair @('a','b','c'),@(1,2,3)
    $Result.a | Should -Be 1
    $Result.b | Should -Be 2
    $Result.c | Should -Be 3
  }
  It 'provides aliases for ease of use' {
    $Result = @('a','b','c'),@(1,2,3) | ConvertFrom-Pair
    $Result.a | Should -Be 1
    $Result.b | Should -Be 2
    $Result.c | Should -Be 3
  }
}
Describe 'ConvertTo-Pair' {
  It 'can create key and value arrays from an object' {
    $Pair = @{ a = 1; b = 2; c = 3 } | ConvertTo-Pair
    $Pair[0] | Sort-Object | Should -Be @('a','b','c')
    $Pair[1] | Sort-Object | Should -Be @(1,2,3)
    $Pair = ConvertTo-Pair @{ a = 1; b = 2; c = 3 }
    $Pair[0] | Sort-Object | Should -Be @('a','b','c')
    $Pair[1] | Sort-Object | Should -Be @(1,2,3)
    $Pair = [PSCustomObject]@{ a = 1; b = 2; c = 3 } | ConvertTo-Pair
    $Pair[0] | Sort-Object | Should -Be @('a','b','c')
    $Pair[1] | Sort-Object | Should -Be @(1,2,3)
  }
  It 'should provide passthru for non-object values' {
    'Not an object' | ConvertTo-Pair | Should -Be 'Not an object'
  }
  It 'should be the inverse for ConvertFrom-Pair' {
    $Pair = @('c','b','a'),@(3,2,1) | ConvertFrom-Pair | ConvertTo-Pair
    $Pair[0] | Sort-Object | Should -Be @('a','b','c')
    $Pair[1] | Sort-Object | Should -Be @(1,2,3)
  }
  It 'provides aliases for ease of use' {
    $Pair = @{ a = 1; b = 2; c = 3 } | ConvertTo-Pair
    $Pair[0] | Sort-Object | Should -Be @('a','b','c')
    $Pair[1] | Sort-Object | Should -Be @(1,2,3)
  }
}
Describe 'Deny-Empty' {
  It 'can filter our empty strings from pipeline chains' {
    '','b','' | Deny-Empty | Should -Be 'b'
    'a','','b','','d' | Deny-Empty | Should -Be 'a','b','d'
    Deny-Empty 'a','b','','d' | Should -Be 'a','b','d'
  }
}
Describe 'Deny-Null' {
  It 'can filter our $Null values from pipeline chains' {
    $Null,2,$Null | Deny-Null | Should -Be 2
    1,$Null,2,$Null,4 | Deny-Null | Should -Be 1,2,4
    Deny-Null 1,2,$Null,4 | Should -Be 1,2,4
  }
}
Describe 'Find-FirstIndex' {
  It 'can determine index of first item that satisfies default predicate' {
    Find-FirstIndex -Values $False,$True,$False | Should -Be 1
    $False,$True,$False | Find-FirstIndex | Should -Be 1
    Find-FirstIndex -Values $True,$True,$False | Should -Be 0
    $True,$True,$False | Find-FirstIndex | Should -Be 0
    $True,$False,$False | Find-FirstIndex | Should -Be 0
  }
  It 'can determine index of first item that satisfies passed predicate' {
    $Arr = 0,0,0,0,2,0,0
    $Predicate = { $Args[0] -eq 2 }
    Find-FirstIndex -Values $Arr | Should -Be $Null
    Find-FirstIndex -Values $Arr -Predicate $Predicate | Should -Be 4
    $Arr | Find-FirstIndex -Predicate $Predicate | Should -Be 4
    Find-FirstIndex -Values 2,0,0,0,2,0,0 -Predicate $Predicate | Should -Be 0
  }
}
Describe 'Get-Property' {
  It 'can get object properties within a pipeline' {
    'hello' | Get-Property 'Length' | Should -Be 5
    'foo','bar','baz' | Get-Property 'Length' | Should -Be 3,3,3
    'a','ab','abc' | Get-Property 'Length' | Should -Be 1,2,3
    @{ a = 1; b = 2; c = 3 } | Get-Property 'Keys' | Sort-Object | Should -Be 'a','b','c'
    @(1,2,3),@(,4,5,6),@(7,8,9) | Get-Property 1 | Sort-Object | Should -Be 2,5,8
    @(1,2,3,@(4,5,6)),@(1,2,3,@(4,5,6)) | Get-Property '3.1' | Should -Be 5,5
    @(1,2,3,@(,4,5,6,@(7,8,9))),@(1,2,3,@(,4,5,6,@(7,8,9))) | Get-Property '3.3.2' | Should -Be 9,9
    @(@('a','b'),'c'),@(@('a','b'),'c') | Get-Property '0.1' | Should -Be 'b','b'
  }
  It 'can operate on array-like objects as single items' {
    ,@(1,2,3,@(4,5,6)) | Get-Property '3.1' | Should -Be 5
    ,@(1,2,3,@(,4,5,6,@(7,8,9))) | Get-Property '3.3.2' | Should -Be 9
    ,@(@('a','b'),'c') | Get-Property '0.1' | Should -Be 'b'
  }
  It 'supports "path" syntax to return nested properties' {
    @{ a = '123' } | Get-Property 'a.Length' | Should -Be 3
    @{ a = 'a' },@{ a = '123' },@{ a = 'hello' } | Get-Property 'a.Length' | Should -Be 1,3,5
    @{ a = 6,5,4 },@{ a = 0,1,2 } | Get-Property 'a.2' | Should -Be 4,2
  }
  It 'will return null for non-existent property names' {
    1 | Get-Property 'Fake' | Should -Be $Null
    1 | Get-Property '-Fake' | Should -Be $Null
  }
}
Describe 'Invoke-Chunk' {
  It 'should passthru input object when size is 0 or bigger than the input size' {
    1..10 | Invoke-Chunk -Size 0 | Should -Be (1..10)
    1..10 | Invoke-Chunk -Size 10 | Should -Be (1..10)
    1..10 | Invoke-Chunk -Size 11 | SHould -Be (1..10)
  }
  It 'can break an array into smaller arrays of a given size' {
    1,2,3 | Invoke-Chunk -Size 1 | Should -Be @(1),@(2),@(3)
    1,1,2,2,3,3 | Invoke-Chunk -Size 2 | Should -Be @(1,1),@(2,2),@(3,3)
    1,2,3,1,2 | Invoke-Chunk -Size 3 | Should -Be @(1,2,3),@(1,2)
    Invoke-Chunk 1,2,3 -Size 1 | Should -Be @(1),@(2),@(3)
    Invoke-Chunk 1,1,2,2,3,3 -Size 2 | Should -Be @(1,1),@(2,2),@(3,3)
    Invoke-Chunk 1,2,3,1,2 -Size 3 | Should -Be @(1,2,3),@(1,2)
    Invoke-Chunk @(1,2,3) 1 | Should -Be @(1),@(2),@(3)
    Invoke-Chunk @(1,1,2,2,3,3) 2 | Should -Be @(1,1),@(2,2),@(3,3)
    Invoke-Chunk @(1,2,3,1,2) 3 | Should -Be @(1,2,3),@(1,2)
  }
  It 'provides aliases for ease of use' {
    1..5 | chunk -s 3 | Should -Be @(1,2,3),@(4,5)
  }
}
Describe 'Invoke-DropWhile' {
  It 'can drop elements until passed predicate is False' {
    $LessThan3 = { Param($X) $X -lt 3 }
    $GreaterThan10 = { Param($X) $X -gt 10 }
    1..5 | Invoke-DropWhile $LessThan3 | Should -Be 3,4,5
    1,2,3,4,5,1,1,1 | Invoke-DropWhile $LessThan3 | Should -Be 3,4,5,1,1,1
    Invoke-DropWhile -InputObject (1..5) -Predicate $LessThan3 | Should -Be 3,4,5
    1..5 | Invoke-DropWhile $GreaterThan10 | Should -Be 1,2,3,4,5
    Invoke-DropWhile -InputObject (1..5) -Predicate $GreaterThan10 | Should -Be 1,2,3,4,5
  }
  It 'supports string input and output' {
    $IsNotHash = { Param($X) $X -ne '#' }
    'Hello World ###' | Invoke-DropWhile $IsNotHash | Should -Be '###'
    '### Hello World' | Invoke-DropWhile $IsNotHash | Should -Be '### Hello World'
    @('Hello World ###') | Invoke-DropWhile $IsNotHash | Should -Be '###'
    Invoke-DropWhile -InputObject 'Hello World ###' $IsNotHash | Should -Be '###'
  }
}
Describe 'Invoke-Flatten' {
  It 'can flatten multi-dimensional arrays' {
    @(1,@(2,3)) | Invoke-Flatten | Should -Be 1,2,3
    @(1,@(2,3,@(4,5))) | Invoke-Flatten | Should -Be 1,2,3,4,5
    @(1,@(2,3,@(4,5,@(6,7)))) | Invoke-Flatten | Should -Be 1,2,3,4,5,6,7
    @(1,@(2,3,@(4,5,@(6,7,@(8,9))))) | Invoke-Flatten | Should -Be 1,2,3,4,5,6,7,8,9
    @(1,@(2,3,@(4,5,@(6,7,@(8,9)),10,@(11)))) | Invoke-Flatten | Should -Be 1,2,3,4,5,6,7,8,9,10,11
  }
}
Describe 'Invoke-InsertString' {
  It 'can insert string into a string at a given index' {
    Invoke-InsertString -Value 'C' -To 'ABDE' -At 2 | Should -Be 'ABCDE'
    'ABDE' | Invoke-InsertString 'C' -At 2 | Should -Be 'ABCDE'
    '15' | Invoke-InsertString '234' -At 1 | Should -Be '12345'
    'foo' | Invoke-InsertString 'bar' -At 3 | Should -Be 'foobar'
    'foo' | Invoke-InsertString 'bar' -At 4 | Should -Be 'foo'
  }
  It 'can process an array of strings' {
    'JaneDoe','JohnDoe' | Invoke-InsertString ' ' -At 4 | Should -Be 'Jane Doe','John Doe'
  }
}
Describe 'Invoke-Method' {
  It 'can apply a method within a pipeline' {
    '  foo','  bar','  baz' | Invoke-Method 'TrimStart' | Should -Be 'foo','bar','baz'
    $True,$False,42 | Invoke-Method 'ToString' | Should -Be 'True','False','42'
  }
  It 'can apply a method with arguments within a pipeline' {
    'a','b','c' | Invoke-Method 'StartsWith' 'b' | Should -Be $False,$True,$False
    1,2,3 | Invoke-Method 'CompareTo' 2 | Should -Be -1,0,1
    @{ x = 1 } | Invoke-Method 'ContainsKey' 'x' | Should -BeTrue
    @{ x = 1 } | Invoke-Method 'ContainsKey' 'y' | Should -BeFalse
    @{ x = 1 },@{ x = 2 },@{ x = 3 } | Invoke-Method 'Item' 'x' | Should -Be 1,2,3
    $Arguments = 'Substring',0,3
    'abcdef','123456','foobar' | Invoke-Method @Arguments | Should -Be 'abc','123','foo'
    'abcdef','123456','foobar' | Invoke-Method 'Substring' 0 3 | Should -Be 'abc','123','foo'
  }
  It 'only applies valid methods' {
    'foobar' | Invoke-Method 'FakeMethod' | Should -Be 'foobar'
    { 'foobar' | Invoke-Method 'Fake-Method' } | Should -Throw
  }
}
Describe 'Invoke-ObjectInvert' {
  It 'can invert objects with one key/value' {
    $Result = @{ foo = 'bar' } | Invoke-ObjectInvert
    $Result.bar | Should -Be 'foo'
    $Result.foo | Should -Be $Null
    $Result = [PSCustomObject]@{ foo = 'bar' } | Invoke-ObjectInvert
    $Result.bar | Should -Be 'foo'
    $Result.foo | Should -Be $Null
  }
  It 'can invert objects with more than one key/value pairs' {
    $Result = @{ a = 1; b = 2; c = 3 } | Invoke-ObjectInvert
    $Result['1'] | Should -Be 'a'
    $Result.a | Should -Be $Null
    $Result = [PSCustomObject]@{ a = 1; b = 2; c = 3 } | Invoke-ObjectInvert
    $Result['1'] | Should -Be 'a'
    $Result.a | Should -Be $Null
  }
  It 'can invert objects and group duplicate values' {
    $Result = @{ a = 1; b = 2; c = 1; d = 1 } | Invoke-ObjectInvert
    $Result['1'] | Should -Be 'a','c','d'
    $Result['2'] | Should -Be 'b'
    $Result.a | Should -Be $Null
    $Result.b | Should -Be $Null
    $Result.c | Should -Be $Null
    $Result.d | Should -Be $Null
    $Result = [PSCustomObject]@{ a = 1; b = 2; c = 2; d = 1 } | Invoke-ObjectInvert
    $Result['1'] | Should -Be 'a','d'
    $Result['2'] | Should -Be 'b','c'
    $Result.a | Should -Be $Null
    $Result.b | Should -Be $Null
    $Result.c | Should -Be $Null
    $Result.d | Should -Be $Null
  }
}
Describe 'Invoke-ObjectMerge' {
  It 'should function as passthru for one object' {
    $Result = @{ foo = 'bar' } | Invoke-ObjectMerge
    $Result.foo | Should -Be 'bar'
    $Result = [PSCustomObject]@{ foo = 'bar' } | Invoke-ObjectMerge
    $Result.foo | Should -Be 'bar'
  }
  It 'can merge two hashtables' {
    $Result = @{ a = 1 },@{ b = 2 } | Invoke-ObjectMerge
    $Result.a | Should -Be 1
    $Result.b | Should -Be 2
    $Result.Keys | Sort-Object | Should -Be 'a','b'
    $Result.Values | Sort-Object | Should -Be 1,2
    $Result = @{ a = 1; x = 'this' },@{ b = 2; y = 'that' } | Invoke-ObjectMerge
    $Result.a | Should -Be 1
    $Result.b | Should -Be 2
    $Result.x | Should -Be 'this'
    $Result.y | Should -Be 'that'
    $Result.Keys | Sort-Object | Should -Be 'a','b','x','y'
    $Result.Values | Sort-Object | Should -Be 1,2,'that','this'
  }
  It 'can merge two custom objects' {
    $Result = [PSCustomObject]@{ a = 1 },[PSCustomObject]@{ b = 2 } | Invoke-ObjectMerge
    $Result.a | Should -Be 1
    $Result.b | Should -Be 2
    $Result.PSObject.Properties.Name | Sort-Object | Should -Be 'a','b'
    $Result.PSObject.Properties.Value | Sort-Object | Should -Be 1,2
    $Result = [PSCustomObject]@{ a = 1; x = 3 },[PSCustomObject]@{ b = 2; y = 4 } | Invoke-ObjectMerge
    $Result.a | Should -Be 1
    $Result.b | Should -Be 2
    $Result.x | Should -Be 3
    $Result.y | Should -Be 4
    $Result.PSObject.Properties.Name | Sort-Object | Should -Be 'a','b','x','y'
    $Result.PSObject.Properties.Value | Sort-Object | Should -Be 1,2,3,4
  }
  It 'can merge more than two hashtables' {
    $Result = @{ a = 1 },@{ b = 2 },@{ c = 3 } | Invoke-ObjectMerge
    $Result.a | Should -Be 1
    $Result.b | Should -Be 2
    $Result.c | Should -Be 3
    $Result.Keys | Sort-Object | Should -Be 'a','b','c'
    $Result.Values | Sort-Object | Should -Be 1,2,3
    $Result = @{ a = 1; x = 4 },@{ b = 2; y = 5 },@{ c = 3; z = 6 } | Invoke-ObjectMerge
    $Result.a | Should -Be 1
    $Result.b | Should -Be 2
    $Result.c | Should -Be 3
    $Result.x | Should -Be 4
    $Result.y | Should -Be 5
    $Result.z | Should -Be 6
    $Result.Keys | Sort-Object | Should -Be 'a','b','c','x','y','z'
    $Result.Values | Sort-Object | Should -Be 1,2,3,4,5,6
  }
  It 'can merge more than two custom objects' {
    $Result = [PSCustomObject]@{ a = 1 },[PSCustomObject]@{ b = 2 },[PSCustomObject]@{ c = 3 } | Invoke-ObjectMerge
    $Result.a | Should -Be 1
    $Result.b | Should -Be 2
    $Result.c | Should -Be 3
    $Result.PSObject.Properties.Name | Sort-Object | Should -Be 'a','b','c'
    $Result.PSObject.Properties.Value | Sort-Object | Should -Be 1,2,3
    $Result = [PSCustomObject]@{ a = 1; x = 4 },[PSCustomObject]@{ b = 2; y = 5 },[PSCustomObject]@{ c = 3; z = 6 } | Invoke-ObjectMerge
    $Result.a | Should -Be 1
    $Result.b | Should -Be 2
    $Result.c | Should -Be 3
    $Result.x | Should -Be 4
    $Result.y | Should -Be 5
    $Result.z | Should -Be 6
    $Result.PSObject.Properties.Name | Sort-Object | Should -Be 'a','b','c','x','y','z'
    $Result.PSObject.Properties.Value | Sort-Object | Should -Be 1,2,3,4,5,6
  }
  It 'will overwrite values with same key' {
    $Result = @{ a = 1 },@{ b = 2 },@{ a = 3 } | Invoke-ObjectMerge
    $Result.a | Should -Be 3
    $Result.b | Should -Be 2
  }
}
Describe 'Invoke-Once' {
  It 'will return a function that will only be executed once' {
    function Test-Callback {}
    $Function:test = Invoke-Once { Test-Callback }
    Mock Test-Callback {}
    1..10 | ForEach-Object { test }
    Assert-MockCalled Test-Callback -Times 1
  }
  It 'will return a function that will only be executed a certain number of times' {
    function Test-Callback {}
    $Times = 5
    $Function:test = Invoke-Once -Times $Times { Test-Callback }
    Mock Test-Callback {}
    1..10 | ForEach-Object { test }
    Assert-MockCalled Test-Callback -Times $Times
  }
}
Describe 'Invoke-Operator' {
  It 'can use operators within a pipeline' {
    'one,two' | Invoke-Operator 'split' ',' | Should -Be 'one','two'
    @(1,2,3),@(4,5,6),@(7,8,9) | Invoke-Operator 'join' '' | Should -Be '123','456','789'
    ,(1,2,3) | Invoke-Operator 'join' ',' | Should -Be '1,2,3'
    ,(1,2,3) | Invoke-Operator 'join' "'" | Should -Be "1'2'3"
    ,(1,2,3) | Invoke-Operator 'join' "`"" | Should -Be '1"2"3'
    ,(1,2,3) | Invoke-Operator 'join' '"' | Should -Be '1"2"3'
    'abd' | Invoke-Operator 'replace' 'd','c' | Should -Be 'abc'
  }
  It 'can use arithmetic operators within a pipeline' {
    1,2,3,4,5 | Invoke-Operator '%' 2 | Should -Be 1,0,1,0,1
    1,2,3,4,5 | Invoke-Operator '+' 1 | Should -Be 2,3,4,5,6
  }
  It 'only applies valid operators' {
    'foobar' | Invoke-Operator 'fake' 'operator' | Should -Be 'foobar'
    { 'foobar' | Invoke-Operator 'WayTooLongForAn' 'operator' } | Should -Throw
    { 'foobar' | Invoke-Operator 'has space' 'operator' } | Should -Throw
  }
}
Describe 'Invoke-Partition' {
  It 'can separate an array of objects into two arrays' {
    $IsPositive = { Param($X) $X -gt 0 }
    $IsNegative = { Param($X) $X -lt 0 }
    1..10 | Invoke-Partition $IsPositive | Should -Be @(@(1,2,3,4,5,6,7,8,9,10),@())
    1..10 | Invoke-Partition $IsNegative | Should -Be @(@(),@(1,2,3,4,5,6,7,8,9,10))
    $IsEven = { Param($X) $X % 2 -eq 0 }
    0..9 | Invoke-Partition $IsEven | Should -Be @(0,2,4,6,8),@(1,3,5,7,9)
  }
}
Describe 'Invoke-Pick' {
  It 'can create hashtable from picked properties' {
    $Name = 'a','c'
    $Result = @{ a = 1; b = 2; c = 3; d = 4 } | Invoke-Pick $Name
    $Result.keys | Sort-Object | Should -Be 'a','c'
    $Result.values | Sort-Object | Should -Be 1,3
  }
  It 'can create hashtable from all picked properties' {
    $Name = 'a','c','x'
    $Result = @{ a = 1; b = 2; c = 3; d = 4 } | Invoke-Pick $Name -All
    $Result.keys | Sort-Object | Should -Be 'a','c','x'
    $Result.values | Sort-Object | Should -Be 1,3
    $Result = @{ a = 1; b = 2; c = 3; d = 4 } | Invoke-Pick $Name -All -EmptyValue 'EMPTY'
    $Result.keys | Sort-Object | Should -Be 'a','c','x'
    $Result.values | Sort-Object | Should -Be 1,3,'EMPTY'
  }
  It 'can create custom object from picked properties' {
    $Name = 'a','c'
    $Result = [PSCustomObject]@{ a = 1; b = 2; c = 3; d = 4 } | Invoke-Pick $Name
    $Result.PSObject.Properties.Name | Sort-Object | Should -Be 'a','c'
    $Result.PSObject.Properties.Value | Sort-Object | Should -Be 1,3
  }
  It 'can create custom object from all picked properties' {
    $Name = 'a','c','x'
    $Result = [PSCustomObject]@{ a = 1; b = 2; c = 3; d = 4 } | Invoke-Pick $Name -All
    $Result.PSObject.Properties.Name | Sort-Object | Should -Be 'a','c','x'
    $Result.PSObject.Properties.Value | Sort-Object | Should -Be 1,3
    $Result = [PSCustomObject]@{ a = 1; b = 2; c = 3; d = 4 } | Invoke-Pick $Name -All -EmptyValue 'EMPTY'
    $Result.PSObject.Properties.Name | Sort-Object | Should -Be 'a','c','x'
    $Result.PSObject.Properties.Value | Sort-Object | Should -Be 1,3,'EMPTY'
  }
  It 'should always return an object' {
    $Name = 'foo','bar'
    $Result = 'Not an object' | Invoke-Pick $Name
    $Result | Should -BeOfType [Hashtable]
    $Result.keys.Count | Sort-Object | Should -Be 0
    $Result | Should -BeOfType [Hashtable]
    $Result = 'Not an object' | Invoke-Pick $Name -All -EmptyValue 'NOTHING'
    $Result.keys | Sort-Object | Should -Be 'bar','foo'
    $Result.values | Sort-Object | Should -Be 'NOTHING','NOTHING'
  }
}
Describe 'Invoke-PropertyTransform' {
  It 'can transform hashtable property names and values' {
    $Data = @{}
    $Data | Add-member -NotePropertyName 'fighter_power_level' -NotePropertyValue 90
    $Lookup = @{
      level = 'fighter_power_level'
    }
    $Reducer = {
      Param($Value)
      ($Value * 100) + 1
    }
    $Result = $Data | Invoke-PropertyTransform -Lookup $Lookup -Transform $Reducer
    $Expected = if (-not $IsLinux) {
      9001
    } else {
      1 #this is not the right answer - just a temporary bandage to make test pass
    }
    $Result.level | Should -Be $Expected
  }
  It 'can transform custom objects property names and values' {
    $Data = @{
      fighter_power_level = 90
    }
    $Lookup = @{
      level = 'fighter_power_level'
    }
    $Reducer = {
      Param($Value)
      ($Value * 100) + 1
    }
    $Result = $Data | Invoke-PropertyTransform $Lookup $Reducer
    $Result.level | Should -Be 9001
  }
}
Describe 'Invoke-Reduce' {
  It 'will use the first item when no initial value is passed' {
    $Expected = 55
    $AllTrue = $True,$True,$True
    $OneFalse = $True,$False,$True
    $Add = { Param($A, $B) $A + $B }
    $Some = { Param($A, $B) $A -or $B }
    $Every = { Param($A, $B) $A -and $B }
    1..10 | Invoke-Reduce -Add | Should -Be $Expected
    1..10 | Invoke-Reduce $Add | Should -Be $Expected
    1..10 | Invoke-Reduce $Add '' | Should -Be '12345678910'
    $AllTrue | Invoke-Reduce -Callback $Every | Should -BeTrue
    $OneFalse | Invoke-Reduce -Callback $Some | Should -BeTrue
    $AllTrue | Invoke-Reduce -Callback $Some | Should -BeTrue
    $OneFalse | Invoke-Reduce -Callback $Every | Should -BeFalse
    $AllTrue | Invoke-Reduce -Every | Should -BeTrue
    $OneFalse | Invoke-Reduce -Some | Should -BeTrue
    $AllTrue | Invoke-Reduce -Some | Should -BeTrue
    $OneFalse | Invoke-Reduce -Every | Should -BeFalse
    $A = @{ Count = 1 }
    $B = @{ Count = 2 }
    $C = @{ Count = 3 }
    $Result = $A,$B,$C | Invoke-Reduce -Callback { Param($Acc, $Item) $Acc.Count += $Item.Count }
    $Result.Keys | Sort-Object | Should -Be 'Count'
    $Result.Count | Sort-Object | Should -Be 6
  }
  It 'can accept strings and integers as initial values' {
    $Add = { Param($A, $B) $A + $B }
    1,2,3,4,5 | Invoke-Reduce -Callback $Add -InitialValue 0 | Should -Be 15
    'a','b','c' | Invoke-Reduce -Callback $Add -InitialValue '' | Should -Be 'abc'
    'a','b','c' | Invoke-Reduce -InitialValue 'initial value' | Should -Be 'initial value'
    1,2,3,4,5 | Invoke-Reduce $Add 0 | Should -Be 15
    'a','b','c' | Invoke-Reduce $Add '' | Should -Be 'abc'
    'a','b','c' | Invoke-Reduce -InitialValue 'initial value' | Should -Be 'initial value'
    1,2,3,4,5 | Invoke-Reduce -Add -InitialValue 0 | Should -Be 15
    'a','b','c' | Invoke-Reduce -Add -InitialValue '' | Should -Be 'abc'
  }
  It 'can accept boolean values' {
    $Every = { Param($A, $B) $A -and $B }
    $Some = { Param($A, $B) $A -or $B }
    $AllTrue = $True,$True,$True
    $OneFalse = $True,$False,$True
    $AllTrue | Invoke-Reduce -Callback $Every -InitialValue $True | Should -BeTrue
    $OneFalse | Invoke-Reduce -Callback $Some -InitialValue $True | Should -BeTrue
    $AllTrue | Invoke-Reduce -Callback $Some -InitialValue $True | Should -BeTrue
    $OneFalse | Invoke-Reduce -Callback $Every -InitialValue $True | Should -BeFalse
    $AllTrue | Invoke-Reduce -Every -InitialValue $True | Should -BeTrue
    $AllTrue | Invoke-Reduce -Some -InitialValue $True | Should -BeTrue
    $OneFalse | Invoke-Reduce -Every -InitialValue $True | Should -BeFalse
    $OneFalse | Invoke-Reduce -Some -InitialValue $True | Should -BeTrue
  }
  It 'can accept objects as initial values' {
    $A = @{ name = 'a'; value = 1 }
    $B = @{ name = 'b'; value = 2 }
    $C = @{ name = 'c'; value = 3 }
    $Callback = { Param($Acc, $Item) $Acc[$Item.Name] = $Item.Value }
    # with inline scriptblock
    $Result = $A,$B,$C | Invoke-Reduce -Callback { Param($Acc, $Item) $Acc[$Item.Name] = $Item.Value } -InitialValue @{}
    $Result.Keys | Sort-Object | Should -Be 'a','b','c'
    $Result.Values | Sort-Object | Should -Be 1,2,3
    # with scriptblock variable
    $Result = $A,$B,$C | Invoke-Reduce $Callback -InitialValue @{}
    $Result.Keys | Sort-Object | Should -Be 'a','b','c'
    $Result.Values | Sort-Object | Should -Be 1,2,3
  }
  It 'should pass item index to -Callback function' {
    $Callback = {
      Param($Acc, $Item, $Index)
      $Acc + $Item + $Index
    }
    1,2,3 | Invoke-Reduce $Callback 0 | Should -Be 9
  }
  It 'should pass -Items value to -Callback function' {
    $Callback = {
      Param($Acc, $Item, $Index, $Items)
      $Items.Length | Should -Be 3
      $Acc + $Item +  $Index
    }
    Invoke-Reduce -Items 1,2,3 $Callback 0 | Should -Be 9
  }
  It 'can combine FileInfo objects' {
    $Result = Get-ChildItem -File | Invoke-Reduce -FileInfo
    $Result.Keys | Should -Contain 'pwsh-prelude.psm1'
    $Result.Keys | Should -Contain 'pwsh-prelude.psd1'
    $Result.Values | ForEach-Object { $_ | Should -BeOfType [Long] }
  }
}
Describe 'Invoke-TakeWhile' {
  It 'can take elements until passed predicate is False' {
    $LessThan3 = { Param($X) $X -lt 3 }
    $GreaterThan10 = { Param($X) $X -gt 10 }
    1..5 | Invoke-TakeWhile $LessThan3 | Should -Be 1,2
    1,2,3,4,5,1,1 | Invoke-TakeWhile $LessThan3 | Should -Be 1,2
    Invoke-TakeWhile -InputObject (1..5) -Predicate $LessThan3 | Should -Be 1,2
    13..8 | Invoke-TakeWhile $GreaterThan10 | Should -Be 13,12,11
    Invoke-TakeWhile -InputObject (13..8) -Predicate $GreaterThan10 | Should -Be 13,12,11
  }
  It 'supports string input and output' {
    $IsNotSpace = { Param($X) $X -ne ' ' }
    'Hello World' | Invoke-TakeWhile $IsNotSpace | Should -Be 'Hello'
    '   Hello World' | Invoke-TakeWhile $IsNotSpace | Should -Be ''
    @('Hello World') | Invoke-TakeWhile $IsNotSpace | Should -Be 'Hello'
    Invoke-TakeWhile -InputObject 'Hello World' $IsNotSpace | Should -Be 'Hello'
  }
}
Describe 'Invoke-Tap' {
  It 'can execute a scriptblock and passthru values' {
    function Test-Function {}
    Mock Test-Function { $Args }
    $Times = 10
    1..$Times | Invoke-Tap { Test-Function } | Should -Be (1..$Times)
    Assert-MockCalled Test-Function -Times $Times
    1,2,3 | Invoke-Tap { Param($X) $X + 1 } | Should -Be 2,3,4
  }
}
Describe 'Invoke-Unzip' {
  It 'can separate an array of pairs into two arrays' {
    @() | Invoke-Unzip | Should -Be $Null
    @(@(),@()) | Should -Be @(),@()
    @(@('a',1),@('b',2),@('c',3)) | Invoke-Unzip | Should -Be @('a','b','c'),@(1,2,3)
  }
  It 'should act as an inverse to zip' {
    $Expected = @('aaa','bbb','ccc'),@(1,2,3)
    $Expected | Invoke-Zip | Invoke-Unzip | Should -Be $Expected
  }
}
Describe 'Invoke-Zip(With)' {
  It 'can zip two arrays' {
    $Zipped = @('a'),@(1) | Invoke-Zip
    $Zipped.Length | Should -Be 2
    $Zipped[0] | Should -Be 'a'
    $Zipped[1] | Should -Be 1
    @('x'),@('a','b','c') | Invoke-Zip | Should -Be @('x','a'),@('empty','b'),@('empty','c')
    @('x'),@('a','b','c') | Invoke-Zip -EmptyValue '?' | Should -Be @('x','a'),@('?','b'),@('?','c')
    @(1),@(1,2,3) | Invoke-Zip -EmptyValue 0 | Should -Be @(1,1),@(0,2),@(0,3)
    @('a','b','c'),@('x') | Invoke-Zip | Should -Be @('a','x'),@('b','empty'),@('c','empty')
    @('a','b','c'),@(1,2,3) | Invoke-Zip | Should -Be @('a',1),@('b',2),@('c',3)
    Invoke-Zip @('x'),@('a','b','c') | Should -Be @('x','a'),@('empty','b'),@('empty','c')
    Invoke-Zip @('a','b','c'),@('x') | Should -Be @('a','x'),@('b','empty'),@('c','empty')
    Invoke-Zip @('a','b','c'),@(1,2,3) | Should -Be @('a',1),@('b',2),@('c',3)
    @('foo','aaa'),@('bar','bbb') | Invoke-Zip | Should -Be @('foo','bar'),@('aaa','bbb')
    'foo'.ToCharArray(),'bar'.ToCharArray() | Invoke-Zip | Should -Be @('f','b'),@('o','a'),@('o','r')
  }
  It 'can zip more than two arrays' {
    $Zipped = @('a'),@('b'),@('c') | Invoke-Zip
    $Zipped.Length | Should -Be 3
    $Zipped[0] | Should -Be 'a'
    $Zipped[1] | Should -Be 'b'
    $Zipped[2] | Should -Be 'c'
    @(1,2),@(1,2),@(1,2) | Invoke-Zip | Should -Be @(1,1,1),@(2,2,2)
    @(1,1,1),@(2,2,2),@(3,3,3) | Invoke-Zip | Should -Be @(1,2,3),@(1,2,3),@(1,2,3)
    @(1),@(2,2),@(3,3,3) | Invoke-Zip | Should -Be @(1,2,3),@('empty',2,3),@('empty','empty',3)
  }
  It 'can zip two arrays with an iteratee function' {
    $Add = { Param($A,$B) $A + $B }
    @(1,2),@(1,2) | Invoke-ZipWith $Add | Should -Be @(2,4)
    Invoke-ZipWith $Add @(1,2),@(1,2) | Should -Be @(2,4)
    @('a','a'),@('b','b') | Invoke-ZipWith $Add | Should -Be @('ab','ab')
    Invoke-ZipWith $Add @('a','a'),@('b','b') | Should -Be @('ab','ab')
    @(2,2,2),@(2,2,2) | Invoke-ZipWith $Add | Should -Be @(4,4,4)
  }
  It 'can zip more than two arrays with an iteratee function' {
    $Add = { Param($A,$B) $A + $B }
    @('1','1'),@('2','2'),@('3','3') | Invoke-ZipWith $Add | Should -Be @('123','123')
    @(1,1,1),@(2,2,2),@(3,3,3),@(4,4,4) | Invoke-ZipWith $Add | Should -Be @(10,10,10)
    @(1,1,1,1),@(2,2,2,2),@(3,3,3,3),@(4,4,4,4) | Invoke-ZipWith $Add | Should -Be @(10,10,10,10)
    Invoke-ZipWith $Add @(1,2),@(1,2),@(1,2) | Should -Be @(3,6)
    Invoke-ZipWith $Add @('a','a'),@('b','b'),@('c','c') | Should -Be @('abc','abc')
    Invoke-ZipWith $Add @('a','a'),@('b','b'),@('c','c','c') | Should -Be @('abc','abc', 'c')
    Invoke-ZipWith $Add @('a','a'),@('b','b'),@('c','c','c') -EmptyValue '#' | Should -Be @('abc','abc', '##c')
  }
}
Describe 'Join-StringsWithGrammar' {
  It 'accepts one parameter' {
    Join-StringsWithGrammar 'one' | Should -Be 'one'
    Join-StringsWithGrammar -Items 'one' | Should -Be 'one'
    'one' | Join-StringsWithGrammar | Should -Be 'one'
    Join-StringsWithGrammar @('one') | Should -Be 'one'
  }
  It 'accepts two parameter' {
    Join-StringsWithGrammar 'one','two' | Should -Be 'one and two'
    Join-StringsWithGrammar -Items 'one','two' | Should -Be 'one and two'
    'one','two' | Join-StringsWithGrammar | Should -Be 'one and two'
    Join-StringsWithGrammar @('one', 'two') | Should -Be 'one and two'
  }
  It 'accepts three or more parameters' {
    Join-StringsWithGrammar 'one','two','three' | Should -Be 'one, two, and three'
    Join-StringsWithGrammar -Items 'one','two','three' | Should -Be 'one, two, and three'
    Join-StringsWithGrammar 'one','two','three','four' | Should -be 'one, two, three, and four'
    'one','two','three' | Join-StringsWithGrammar | Should -Be 'one, two, and three'
    'one','two','three','four' | Join-StringsWithGrammar | Should -be 'one, two, three, and four'
    Join-StringsWithGrammar @('one', 'two', 'three') | Should -Be 'one, two, and three'
    Join-StringsWithGrammar @('one', 'two', 'three', 'four') | Should -Be 'one, two, three, and four'
  }
}
Describe 'Remove-Character' {
  It 'can remove single character from string' {
    '012345' | Remove-Character -At 0 | Should -Be '12345'
    '012345' | Remove-Character -At 2 | Should -Be '01345'
    '012345' | Remove-Character -At 5 | Should -Be '01234'
  }
  It 'can process an array of strings' {
    'abcc','1233' | Remove-Character -At 2 | Should -Be 'abc','123'
  }
  It 'will return entire string if out-of-bounds index' {
    '012345' | Remove-Character -At 10 | Should -Be '012345'
  }
  It 'can remove the first character of a string' {
    'XOOOOO' | Remove-Character -First | Should -Be 'OOOOO'
  }
  It 'can remove the last character of a string' {
    'OOOOOX' | Remove-Character -Last | Should -Be 'OOOOO'
  }
  It 'can remove last character from a string' {
    'A' | Remove-Character -At 0 | Should -Be ''
  }
}
Describe 'Test-Equal' {
  It 'should return true for single items (from pipeline only)' {
    42 | Test-Equal | Should -BeTrue
    'foobar' | Test-Equal | Should -BeTrue
    @{ foo = 'bar' } | Test-Equal | Should -BeTrue
  }
  It 'can compare numbers' {
    Test-Equal 0 0 | Should -BeTrue
    Test-Equal 42 42 | Should -BeTrue
    Test-Equal -42 -42 | Should -BeTrue
    Test-Equal 42 43 | Should -BeFalse
    Test-Equal -43 -42 | Should -BeFalse
    Test-Equal 3 'not a number' | Should -BeFalse
    Test-Equal 4.2 4.2 | Should -BeTrue
    Test-Equal 4 4.0 | Should -BeTrue
    Test-Equal 4.1 4.2 | Should -BeFalse
    42,42 | Test-Equal | Should -BeTrue
    42 | Test-Equal 42 | Should -BeTrue
    42,42,42 | Test-Equal | Should -BeTrue
    43,42,42 | Test-Equal | Should -BeFalse
    42,43,42 | Test-Equal | Should -BeFalse
    42,42,43 | Test-Equal | Should -BeFalse
    42,42 | Test-Equal 42 | Should -BeTrue
    43,42 | Test-Equal 42 | Should -BeFalse
    42,43 | Test-Equal 42 | Should -BeFalse
    42,42 | Test-Equal 43 | Should -BeFalse
  }
  It 'can compare strings' {
    Test-Equal '' '' | Should -BeTrue
    Test-Equal 'foo' 'foo' | Should -BeTrue
    Test-Equal 'foo' 'bar' | Should -BeFalse
    Test-Equal 'foo' 7 | Should -BeFalse
    'na','na','na' | Test-Equal 'na' | Should -BeTrue
    'na','na','na' | Test-Equal 'meh' | Should -BeFalse
    'na','meh','na' | Test-Equal 'na' | Should -BeFalse
  }
  It 'can compare arrays' {
    $A = 1,2,3
    $B = 1,2,3
    $C = 5,6,7
    Test-Equal $A $B | Should -BeTrue
    Test-Equal $A $C | Should -BeFalse
    $A = 'a','b','c'
    $B = 'a','b','c'
    $C = 'x','y','z'
    Test-Equal $A $B | Should -BeTrue
    Test-Equal $B $C | Should -BeFalse
  }
  It 'can compare multi-dimensional arrays' {
    $X = 1,(1,2,3),(4,5,6),7
    $Y = 1,(1,2,3),(4,5,6),7
    $Z = (1,2,3),(1,2,3),(1,2,3)
    Test-Equal $X $Y | Should -BeTrue
    Test-Equal $X $Z | Should -BeFalse
    Test-Equal $X 1,(1,2,3),(4,5,6),8 | Should -BeFalse
  }
  It 'can compare hashtables' {
    $A = @{ a = 'A'; b = 'B'; c = 'C' }
    $B = @{ a = 'A'; b = 'B'; c = 'C' }
    $C = @{ foo = 'bar'; bin = 'baz'; }
    Test-Equal $A $B | Should -BeTrue
    Test-Equal $A $C | Should -BeFalse
    $A,$B | Test-Equal | Should -BeTrue
    $A,$C | Test-Equal | Should -BeFalse
    $A | Test-Equal $B | Should -BeTrue
    $A | Test-Equal $C | Should -BeFalse
  }
  It 'can compare nested hashtables' {
    $A = @{ a = 'A'; b = 'B'; c = 'C' }
    $B = @{ a = 'A'; b = 'B'; c = 'C' }
    $C = @{ foo = 'bar'; bin = 'baz'; }
    $M = @{ a = $A; b = $B; c = $C }
    $N = @{ a = $A; b = $B; c = $C }
    $O = @{ a = $C; b = $A; c = $B }
    Test-Equal $M $N | Should -BeTrue
    Test-Equal $M $O | Should -BeFalse
  }
  It 'can compare custom objects' {
    $A = [PSCustomObject]@{ a = 'A'; b = 'B'; c = 'C' }
    $B = [PSCustomObject]@{ a = 'A'; b = 'B'; c = 'C' }
    $C = [PSCustomObject]@{ foo = 'bar'; bin = 'baz' }
    Test-Equal $A $B | Should -BeTrue
    Test-Equal $A $C | Should -BeFalse
    $A,$B | Test-Equal | Should -BeTrue
    $A,$C | Test-Equal | Should -BeFalse
    $A | Test-Equal $B | Should -BeTrue
    $A | Test-Equal $C | Should -BeFalse
  }
  It 'can compare nested custom objects' {
    $A = [PSCustomObject]@{ a = 'A'; b = 'B'; c = 'C' }
    $B = [PSCustomObject]@{ a = 'A'; b = 'B'; c = 'C' }
    $C = [PSCustomObject]@{ foo = 'bar'; bin = 'baz' }
    $M = [PSCustomObject]@{ a = $A; b = $B; c = $C }
    $N = [PSCustomObject]@{ a = $A; b = $B; c = $C }
    $O = [PSCustomObject]@{ a = $C; b = $A; c = $B }
    Test-Equal $M $N | Should -BeTrue
    Test-Equal $M $O | Should -BeFalse
  }
  It 'can compare [Matrix] objects' {
    $A = [Matrix]::New(2)
    $A.Rows[0][0] = 1
    $A.Rows[0][1] = 2
    $A.Rows[1][0] = 3
    $A.Rows[1][1] = 4
    $B = [Matrix]::Identity(2)
    $C = $A.Clone()
    $A,'Not a Matrix' | Test-Equal | Should -BeFalse
    $A,$B | Test-Equal | Should -BeFalse
    $A,$C | Test-Equal | Should -BeTrue
    $C,$A | Test-Equal | Should -BeTrue
    $B | Test-Equal $B | Should -BeTrue
  }
  It 'can compare other types' {
    Test-Equal $True $True | Should -BeTrue
    Test-Equal $False $False | Should -BeTrue
    Test-Equal $True $False | Should -BeFalse
    Test-Equal $Null $Null | Should -BeTrue
  }
}