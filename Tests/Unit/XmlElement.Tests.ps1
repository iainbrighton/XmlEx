[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingCmdletAliases', '')]
param()

#requires -Version 3

$moduleName = 'XmlEx';
$repoRoot = (Resolve-Path "$PSScriptRoot\..\..").Path;
Import-Module (Join-Path -Path $repoRoot -ChildPath "$moduleName.psm1") -Force;

Describe 'Src\XmlElement' {

    It 'returns [System.Xml.XmlElement] object type' {

        $testElement = 'TestElement';
        $xmlDocument = XmlDocument { };

        $result = XmlElement $testElement -XmlDocument $xmlDocument -PassThru;

        $result -is [System.Xml.XmlElement] | Should Be $true;
    }

    It 'creates an element' {

        $testElement = 'TestElement';
        $testComment = 'RequiredToCoerceAcceleratorToXmlElement';
        $expected = '<{0}><!--{1}--></{0}' -f $testElement, $testComment;
        $result = XmlDocument {
            XmlElement $testElement {
                XmlComment $testComment
            }
        }

        $result.OuterXml | Should Match $expected;
    }

    It 'calls nested "ScriptBlock"' {

        $testRootElement = 'TestRootElement';
        $testNestedElement = 'TestNestedElement';
        $testComment = 'RequiredToCoerceAcceleratorToXmlElement';
        $expected = '<{0}><{1}><!--{2}--></{1}></{0}' -f $testRootElement, $testNestedElement, $testComment;

        $result = XmlDocument {
            XmlElement $testRootElement {
                XmlElement -Name $testNestedElement {
                    XmlComment $testComment
                }
            }
        }

        $result.OuterXml | Should Match $expected;
    }

    It 'creates an element with a namespace' {

        $testElement = 'TestElement';
        $testNamespaceUri = 'http://virtualengine.co.uk/namespace';
        $expected = '<{0} xmlns="{1}" />' -f $testElement, $testNamespaceUri;
        $result = XmlDocument {
            XmlElement $testElement -Namespace $testNamespaceUri
        }

        $result.OuterXml | Should Match $expected;
    }

    It 'creates an element with a prefixed namespace' {

        $testElement = 'TestElement';
        $testNamespaceUri = 'http://virtualengine.co.uk/namespace';
        $testNamespacePrefix = 'v';
        $expected = '<{0}:{1} xmlns:{0}="{2}" />' -f $testNamespacePrefix, $testElement, $testNamespaceUri;
        $result = XmlDocument {
            XmlElement $testElement -Prefix $testNamespacePrefix -Namespace $testNamespaceUri
        }

        $result.OuterXml | Should Match $expected;
    }

    It 'adds an element to an existing [XmlElement]' {
        $testRootElement = 'TestRootElement';
        $testNestedElement = 'TestNestedElement';
        $testComment = 'RequiredToCoerceAcceleratorToXmlElement';
        $expected = '<{0}><!--{1}--><{2} /></{0}>' -f $testRootElement, $testComment, $testNestedElement;
        $xmlDocument = XmlDocument {
            XmlElement $testRootElement {
                XmlComment $testComment
            }
        }

        $result = XmlElement -Name $testNestedElement -XmlElement $xmlDocument.$testRootElement
        $xmlDocument.OuterXml | Should Match $expected;
    }

    <#    Expected: {<?xml version="1.0" encoding="utf-8" standalone="yes"?><TestRootElement><!--RequiredToCoerceAcceleratorToXmlElement--><TestNestedEl
ement /></TestRootElement>} to match the expression {<TestRootElement><TestNestedElement><!--RequiredToCoerceAcceleratorToXmlElement--></TestNest
edElement></TestRootElement}

    } #>



} #end describe Src\XmlElement
