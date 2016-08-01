[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingCmdletAliases', '')]
param()

#requires -Version 3

$moduleName = 'XmlEx';
$repoRoot = (Resolve-Path "$PSScriptRoot\..\..").Path;
Import-Module (Join-Path -Path $repoRoot -ChildPath "$moduleName.psm1") -Force;

Describe 'Src\XmlTextNode' {

    It 'returns [System.Xml.XmlText] object type' {

        $testText = 'Test text';
        $testElement = 'TestElement';
        $xmlDocument = XmlDocument {
            XmlElement -Name testElement {
                XmlAttribute -Name 'RequiredToCoerceElementAsXmlElement' -Value 'OtherwiseReturnedAsString'
            }
        };

        $result = XmlText -Text $testText -XmlElement $xmlDocument.$testElement -PassThru;

        $result -is [System.Xml.XmlText] | Should Be $true;
    }

    It 'creates element text node' {

        $testText = 'Test text';
        $testElement = 'TestElement';
        $expected = '<{0}>{1}</{0}>' -f $testElement, $testText;

        $result = XmlDocument {
            XmlElement $testElement {
                XmlText $testText
            }
        };

        $result.OuterXml | Should Match $expected;

    }

    It 'throws when adding text to the document root' {

        $testText = 'Test text';

        {
            XmlDocument {
                XmlText $testText
            }
        } | Should Throw "You cannot call 'XmlText' from within the 'XmlDocument' scope"
    }

} #end describe Src\XmlComment
