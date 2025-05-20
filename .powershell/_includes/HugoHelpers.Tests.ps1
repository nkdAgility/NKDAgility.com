Import-Module Pester

Describe "Update-FieldPosition Function Tests" {

    BeforeEach {
        $data = [ordered]@{
            "first"  = "value1"
            "second" = "value2"
            "third"  = "value3"
            "fourth" = "value4"
        }
    }

    It "Inserts field at specific index using addAt" {
        Update-FieldPosition -data $data -fieldName "third" -addAt 1

        $data.Keys | Should -BeExactly @("first", "third", "second", "fourth")
    }

    It "Inserts field after specific field using addAfter" {
        Update-FieldPosition -data $data -fieldName "first" -addAfter "third"

        $data.Keys | Should -BeExactly @("second", "third", "first", "fourth")
    }

    It "Inserts field before specific field using addBefore" {
        Update-FieldPosition -data $data -fieldName "fourth" -addBefore "second"

        $data.Keys | Should -BeExactly @("first", "fourth", "second", "third")
    }

    It "Moves field to end if no parameters specified" {
        Update-FieldPosition -data $data -fieldName "second"

        $data.Keys | Should -BeExactly @("first", "third", "fourth", "second")
    }

    It "Does nothing if field not present" {
        Update-FieldPosition -data $data -fieldName "nonexistent"

        $data.Keys | Should -BeExactly @("first", "second", "third", "fourth")
    }

    It "Handles addAt index out of bounds gracefully" {
        Update-FieldPosition -data $data -fieldName "first" -addAt 10

        $data.Keys | Should -BeExactly @("second", "third", "fourth", "first")
    }
}
