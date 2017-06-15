[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingCmdletAliases', '')]
param()

#requires -Version 3

$moduleName = 'XmlEx';
$repoRoot = (Resolve-Path "$PSScriptRoot\..\..\..\..").Path;
Import-Module (Join-Path -Path $repoRoot -ChildPath "$moduleName.psm1") -Force;

Describe 'Src\New-XmlExDocument' {

    It 'creates a [System.Xml.XmlDocument] object type' {

        $result = XmlDocument;

        $result -is [System.Xml.XmlDocument] | Should Be $true;
    }

    It 'calls nested "ScriptBlock"' {

        $testComment = 'Test Comment'

        $result = XmlDocument { XmlComment $testComment };

        $result.OuterXml | Should Match $testComment;
    }

    It 'throws adding "XmlNamespace" to an empty "XmlDocument"' {

        { XmlDocument {
                XmlNamespace -Uri 'http://virtualengine.co.uk/namespace'
            }
        } | Should Throw "Cannot add a 'XmlNamespace' to a document without a root element.";

    }

} #end describe Src\New-XmlExDocument
