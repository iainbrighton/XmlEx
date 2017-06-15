[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingCmdletAliases', '')]
param()

#requires -Version 3

$moduleName = 'XmlEx';
$repoRoot = (Resolve-Path "$PSScriptRoot\..\..\..\..").Path;
Import-Module (Join-Path -Path $repoRoot -ChildPath "$moduleName.psm1") -Force;

Describe 'Src\Add-XmlExNamespace' {

    It 'Creates [System.Xml.XmlDocument] with a namespace' {
        $testNamespaceUri = 'http://virtualengine.co.uk/namespace';
        $expected = 'xmlns="{0}"' -f $testNamespaceUri;

        $result = XmlDocument {
            XmlNamespace -Uri $testNamespaceUri;
            XmlElement 'RequiredToAddNamespace';
        };

        $result.OuterXml | Should Match $expected;
    }

    It 'Creates [System.Xml.XmlDocument] with a prefixed namespace' {
        $testNamespaceUri = 'http://virtualengine.co.uk/namespace';
        $testNamespacePrefix = 've';
        $expected = 'xmlns:{0}="{1}"' -f $testNamespacePrefix, $testNamespaceUri;

        $result = XmlDocument {
            XmlNamespace -Prefix $testNamespacePrefix -Uri $testNamespaceUri;
            XmlElement 'RequiredToAddNamespace';
        };

        $result.OuterXml | Should Match $expected;
    }

    It 'throws when calling "XmlNamespace" outside of "XmlDocument" script block' {
        $testNamespaceUri = 'http://virtualengine.co.uk/namespace';
        $xmlDocument = XmlDocument { };

        { XmlNamespace -Uri 'http://virtualengine.co.uk/namespace' -XmlDocument $xmlDocument } |
            Should Throw "You cannot call 'XmlNamespace' outside the 'XmlDocument' scope.";
    }

} #end describe Src\Add-XmlExNamespace
