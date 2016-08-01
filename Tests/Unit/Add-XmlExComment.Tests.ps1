[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingCmdletAliases', '')]
param()

#requires -Version 3

$moduleName = 'XmlEx';
$repoRoot = (Resolve-Path "$PSScriptRoot\..\..").Path;
Import-Module (Join-Path -Path $repoRoot -ChildPath "$moduleName.psm1") -Force;

Describe 'Src\Add-XmlExComment' {

    It 'returns [System.Xml.XmlComment] object type' {

        $testComment = 'Test Comment';
        $xmlDocument = XmlDocument {
            XmlElement -Name 'TestElement' {
                XmlAttribute -Name 'RequiredToCoerceElementAsXmlElement' -Value 'OtherwiseReturnedAsString'
            }
        };

        $result = XmlComment -Comment $testComment -XmlElement $xmlDocument.TestElement -PassThru;

        $result -is [System.Xml.XmlComment] | Should Be $true;
    }

    It 'creates "<!--{0}-->" comment' {

        $testComment = 'Test Comment';
        $expected = '<!--{0}-->' -f $testComment;

        $result = XmlDocument {
            XmlComment $testComment
        };

        $result.OuterXml | Should Match $expected;

    }

} #end describe Src\Add-XmlExComment
