Import-Module ./pwsh-handy-helpers.psm1

Describe "ConvertTo-PowershellSyntax" {
    It "can act as pass-thru for normal strings" {
        $Expected = "normal string with not mustache templates"
        $Expected | ConvertTo-PowershellSyntax | Should -Be $Expected
    }
    It "can convert strings with single mustache template" {
        $InputString = 'Hello {{ world }}'
        $Expected = 'Hello $($Data.world)'
        $InputString | ConvertTo-PowershellSyntax | Should -Be $Expected
    }
    It "can convert strings with multiple mustache templates without regard to spaces" {
        $Expected = '$($Data.hello) $($Data.world)'
        '{{ hello }} {{ world }}' | ConvertTo-PowershellSyntax | Should -Be $Expected
        '{{ hello }} {{ world}}' | ConvertTo-PowershellSyntax | Should -Be $Expected
        '{{hello }} {{world}}' | ConvertTo-PowershellSyntax | Should -Be $Expected
    }
    It "will not convert mustache helper templates" {
        $Expected = 'The sky is {{#blue blue }}'
        $Expected | ConvertTo-PowershellSyntax | Should -Be $Expected
        $Expected = '{{#red greet }}, my name $($Data.foo) $($Data.foo) is $($Data.name)'
        '{{#red greet }}, my name {{foo }} {{foo}} is {{ name }}' | ConvertTo-PowershellSyntax | Should -Be $Expected
    }
}
Describe "Find-Duplicates" {
    It "can identify duplicate files" {
        # Under construction
    }
}
Describe "Find-FirstIndex" {
    It "can determine index of first item that satisfies default predicate" {
        Find-FirstIndex -Values $false,$true,$false | Should -Be 1
        ,($false, $true, $false) | Find-FirstIndex | Should -Be 1
    }
    It "can determine index of first item that satisfies passed predicate" {
        $Arr = 1,1,1,1,2,1,1
        $Predicate = { $args[0] -eq 2 }
        Find-FirstIndex -Values $Arr | Should -Be $null
        Find-FirstIndex -Values $Arr -Predicate $Predicate | Should -Be 4
        ,$Arr | Find-FirstIndex -Predicate $Predicate | Should -Be 4
    }
}
Describe "Invoke-InsertString" {
    It "can insert string into a string at a given index" {
        Invoke-InsertString -Value "C" -To "ABDE" -At 2 | Should -Be "ABCDE"
        "C" | Invoke-InsertString -To "ABDE" -At 2 | Should -Be "ABCDE"
        "234" | Invoke-InsertString -To "15" -At 1 | Should -Be "12345"
    }
}
Describe "Invoke-Reduce" {
    It "can accept strings and integers as initial values" {
        1,2,3,4,5 | Invoke-Reduce -Callback { $args[0] + $args[1] } -InitialValue 0 | Should -Be 15
        "a","b","c" | Invoke-Reduce -Callback { $args[0] + $args[1] } -InitialValue "" | Should -Be "abc"
        "a","b","c" | Invoke-Reduce -InitialValue "initial value" | Should -Be "initial value"
    }
    It "can accept objects as initial values" {
        $a = @{name = "a"; value = 1}
        $b = @{name = "b"; value = 2}
        $c = @{name = "c"; value = 3}
        $Callback = {
            Param($Acc, $Item)
            $Acc[$Item.Name] = $Item.Value
        }
        # with inline scriptblock
        $Result = $a,$b,$c | Invoke-Reduce -Callback { Param($Acc, $Item) $Acc[$Item.Name] = $Item.Value }
        $Result.Keys | Sort-Object | Should -Be "a","b","c"
        $Result.Values | Sort-Object | Should -Be 1,2,3
        # with scriptblock variable
        $Result = $a,$b,$c | Invoke-Reduce -Callback $Callback
        $Result.Keys | Sort-Object | Should -Be "a","b","c"
        $Result.Values | Sort-Object | Should -Be 1,2,3
    }
    It "can combine FileInfo objects" {
        $Result = Get-ChildItem -File | Invoke-Reduce -FileInfo
        $Result.Keys | Should -Contain "pwsh-handy-helpers.psm1"
        $Result.Keys | Should -Contain "pwsh-handy-helpers.psd1"
        $Result.Keys | Should -Contain "pwsh-handy-helpers.Tests.ps1"
        $Result.Values | ForEach-Object { $_ | Should -BeOfType [long] }
    }
}
Describe "Invoke-Speak (say)" {
    It "can passthru text without speaking" {
        $Text = "this should not be heard"
        Invoke-Speak $Text -Silent | Should -Be $null
        Invoke-Speak $Text -Silent -Output text | Should -Be $Text
    }
    It "can output SSML" {
        $Text = "this should not be heard either"
        Invoke-Speak $Text -Silent -Output ssml | Should -Match "<p>$Text</p>"
    }
    It "can output SSML with custom rate" {
        $Text = "this should not be heard either"
        $Rate = 10
        Invoke-Speak $Text -Silent -Output ssml -Rate $Rate | Should -Match "<p>$Text</p>"
        Invoke-Speak $Text -Silent -Output ssml -Rate $Rate | Should -Match "<prosody rate=`"$Rate`">"
    }
}
Describe "Join-StringsWithGrammar" {
    It "accepts one parameter" {
        Join-StringsWithGrammar @("one") | Should -Be "one"
    }
    It "accepts two parameter" {
        Join-StringsWithGrammar @("one", "two") | Should -Be "one and two"
    }
    It "accepts three or more parameters" {
        Join-StringsWithGrammar @("one", "two", "three") | Should -Be "one, two, and three"
        Join-StringsWithGrammar @("one", "two", "three", "four") | Should -be "one, two, three, and four"
    }
}
Describe "New-File (touch)" {
    AfterAll {
        Remove-Item -Path .\SomeFile
    }
    It "can create a file" {
        $Content = "testing"
        ".\SomeFile" | Should -Not -Exist
        New-File SomeFile
        Write-Output $Content >> .\SomeFile
        ".\SomeFile" | Should -FileContentMatch $Content
    }
}
Describe "New-Template" {
    Context "when passed an empty object" {
        $script:Expected = "<div>Hello </div>"
        It "can return function that accepts positional parameter" {
            $function:render = New-Template '<div>Hello {{ name }}</div>'
            render @{} | Should -Be $Expected
        }
        It "can return function when instantiated as function variable" {
            $function:render = New-Template -Template '<div>Hello {{ name }}</div>'
            render @{} | Should -Be $Expected
        }
        It "can return function when instantiated as normal variable" {
            $renderVariable = New-Template -Template '<div>Hello {{ name }}</div>'
            & $renderVariable @{} | Should -Be $Expected
        }
        It "can support default values" {
            $renderVariable = New-Template -Template '<div>Hello {{ name }}</div>' -DefaultValues @{ name = "Default" }
            & $renderVariable | Should -Be "<div>Hello Default</div>"
            & $renderVariable @{ name = "Not Default" } | Should -Be "<div>Hello Not Default</div>"
        }
    }
    It "can create function from template string using mustache notation" {
        $Expected = "<div>Hello World!</div>"
        $function:render = New-Template '<div>Hello {{ name }}!</div>'
        render @{ name = "World" } | Should -Be $Expected
        @{ name = "World" } | render | Should -Be $Expected
    }
    It "can create function from template string using Powershell syntax" {
        $Expected = "<div>Hello World!</div>"
        $function:render = New-Template '<div>Hello $($Data.name)!</div>'
        render @{ name = "World" } | Should -Be $Expected
        @{ name = "World" } | render | Should -Be $Expected
    }
    It "can be nested within other templates" {
        $Expected = "<section>
            <h1>Title</h1>
            <div>Hello World!</div>
        </section>"
        $div = New-Template -Template '<div>{{ text }}</div>'
        $section = New-Template "<section>
            <h1>{{ title }}</h1>
            $(& $div @{text = "Hello World!"})
        </section>"
        & $section @{ title = "Title" } | Should -Be $Expected
    }
    It "can be nested within other templates (with Powershell syntax)" {
        $Expected = "<section>
            <h1>Title</h1>
            <div>Hello World!</div>
        </section>"
        $div = New-Template -Template '<div>{{ text }}</div>'
        $section = New-Template "<section>
            <h1>`$(`$Data.title)</h1>
            $(& $div @{text = "Hello World!"})
        </section>"
        & $section @{ title = "Title" } | Should -Be $Expected
    }
}
Describe "Remove-Character" {
    It "can remove single character from string" {
        "012345" | Remove-Character -At 0 | Should -Be "12345"
        "012345" | Remove-Character -At 2 | Should -Be "01345"
        "012345" | Remove-Character -At 5 | Should -Be "01234"
    }
    It "will return entire string if out-of-bounds index" {
        "012345" | Remove-Character -At 10 | Should -Be "012345"
    }
    It "can remove the first character of a string" {
        "XOOOOO" | Remove-Character -First | Should -Be "OOOOO"
    }
    It "can remove the last character of a string" {
        "OOOOOX" | Remove-Character -Last | Should -Be "OOOOO"
    }
    It "can remove last character from a string" {
        "A" | Remove-Character -At 0 | Should -Be ""
    }
}
Describe "Remove-DirectoryForce (rf)" {
    It "can create a file" {
        New-File SomeFile
        ".\SomeFile" | Should -Exist
        Remove-DirectoryForce .\SomeFile
        ".\SomeFile" | Should -Not -Exist
    }
}
# Describe "Test-Admin" {
#     It "should return false if not Administrator" {
#         Test-Admin | Should -Be $false
#     }
# }
Describe "Test-Empty" {
    It "should return true for directories with no contents" {
        "TestDrive:\Foo" | Should -Not -Exist
        mkdir "TestDrive:\Foo"
        "TestDrive:\Foo" | Should -Exist
        Test-Empty "TestDrive:\Foo" | Should -Be $true
        mkdir "TestDrive:\Foo\Bar"
        mkdir "TestDrive:\Foo\Bar\Baz"
        Test-Empty "TestDrive:\Foo" | Should -Be $false
    }
}
Describe "Test-Installed" {
    It "should return true if passed module is installed" {
        Test-Installed Pester | Should -Be $true
        Test-Installed NotInstalledModule | Should -Be $false
    }
}