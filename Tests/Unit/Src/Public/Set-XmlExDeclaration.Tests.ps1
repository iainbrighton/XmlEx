[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingCmdletAliases', '')]
param()

#requires -Version 3

$moduleName = 'XmlEx';
$repoRoot = (Resolve-Path "$PSScriptRoot\..\..\..\..").Path;
Import-Module (Join-Path -Path $repoRoot -ChildPath "$moduleName.psm1") -Force;

Describe 'Src\Set-XmlExDeclaration' {

    It 'returns [System.Xml.XmlDeclaration] object type' {

        $xmlDocument = XmlDocument { }

        $result = XmlDeclaration -XmlDocument $xmlDocument -PassThru;

        $result -is [System.Xml.XmlDeclaration] | Should Be $true;
    }

    It 'adds version number by default' {

        $expected = 'version="1.0"';

        $result = XmlDocument {
            XmlDeclaration
        }

        $result.OuterXml | Should Match $expected;
    }

    It 'adds encoding declaration when specified' {

        $testEncoding = 'utf-8';
        $expected = 'encoding="{0}"' -f $testEncoding;

        $result = XmlDocument {
            XmlDeclaration -Encoding $testEncoding
        }

        $result.OuterXml | Should Match $expected;
    }

    It 'adds standalone declaration when specified' {

        $testStandalone = 'yes';
        $expected = 'standalone="{0}"' -f $testStandalone;

        $result = XmlDocument {
            XmlDeclaration -Standalone $testStandalone
        }

        $result.OuterXml | Should Match $expected;
    }

    It 'throws when called outside the XmlDocument scope' {

        {
            XmlDocument {
                XmlElement 'notallowed' {
                    XmlDeclaration
                }
            }
        } | Should Throw "You cannot call 'XmlDecalration' outside the 'XmlDocument' scope";
    }

} #end describe Src\Set-XmlExDeclaration
