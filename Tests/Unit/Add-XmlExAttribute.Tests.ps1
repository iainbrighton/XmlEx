[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingCmdletAliases', '')]
param()

#requires -Version 3

$moduleName = 'XmlEx';
$repoRoot = (Resolve-Path "$PSScriptRoot\..\..").Path;
Import-Module (Join-Path -Path $repoRoot -ChildPath "$moduleName.psm1") -Force;

Describe 'Src\Add-XmlExAttribute' {

    It 'returns [System.Xml.XmlAttribute] object type' {

        $testAttributeName = 'TestAttribute';
        $testAttributeValue = 'TestAttributeValue';
        $testComment = 'RequiredToCoerceElementAsXmlElementOtherwiseReturnedAsString';
        $testElement = 'TestElement';
        $xmlDocument = XmlDocument {
            XmlElement -Name $testElement {
                XmlComment -Comment $testComment
            }
        };

        $result = XmlAttribute -Name $testAttributeName -Value $testAttributeValue -XmlElement $xmlDocument.$testElement -PassThru;

        $result -is [System.Xml.XmlAttribute] | Should Be $true;
    }

    It 'adds attribute to existing element' {

        $testAttributeName = 'TestAttribute';
        $testAttributeValue = 'TestAttributeValue';
        $testComment = 'RequiredToCoerceElementAsXmlElementOtherwiseReturnedAsString';
        $testElement = 'TestElement';
        $expected = '<{0} {1}="{2}"><!--{3}--></{0}>' -f $testElement, $testAttributeName, $testAttributeValue, $testComment;

        $xmlDocument = XmlDocument {
            XmlElement -Name $testElement {
                XmlComment -Comment $testComment
            }
        };
        XmlAttribute -Name $testAttributeName -Value $testAttributeValue -XmlElement $xmlDocument.$testElement;

        $xmlDocument.OuterXml | Should Match $expected;
    }

    It 'adds attribute in a new document' {

        $testAttributeName = 'TestAttribute';
        $testAttributeValue = 'TestAttributeValue';
        $testElement = 'TestElement';
        $expected = '<{0} {1}="{2}" />' -f $testElement, $testAttributeName, $testAttributeValue;

        $xmlDocument = XmlDocument {
            XmlElement -Name $testElement {
                 XmlAttribute -Name $testAttributeName -Value $testAttributeValue
            }
        };

        $xmlDocument.OuterXml | Should Match $expected;
    }

    It 'adds attribute with a namespace' {

        $testAttributeName = 'TestAttribute';
        $testAttributeValue = 'TestAttributeValue';
        $testElement = 'TestElement';
        $testNamespaceUri = 'http://virtualengine.co.uk/namespace'

        $expectedAttribute = 'd1p1:{0}="{1}"' -f $testAttributeName, $testAttributeValue;
        $expectedNamespace = 'xmlns:d1p1="{0}"' -f $testNamespaceUri;

        $xmlDocument = XmlDocument {
            XmlElement -Name $testElement {
                 XmlAttribute -Name $testAttributeName -Value $testAttributeValue -Namespace $testNamespaceUri;
            }
        };

        $xmlDocument.OuterXml | Should Match $expectedAttribute;
        $xmlDocument.OuterXml | Should Match $expectedNamespace;
    }

    It 'adds attribute with a prefixed namespace' {

        $testAttributeName = 'TestAttribute';
        $testAttributeValue = 'TestAttributeValue';
        $testElement = 'TestElement';
        $testNamespaceUri = 'http://virtualengine.co.uk/namespace'
        $testNamespacePrefix = 'v'

        $expectedAttribute = '{0}:{1}="{2}"' -f $testNamespacePrefix, $testAttributeName, $testAttributeValue;
        $expectedNamespace = 'xmlns:{0}="{1}"' -f $testNamespacePrefix, $testNamespaceUri;

        $xmlDocument = XmlDocument {
            XmlElement -Name $testElement {
                 XmlAttribute -Name $testAttributeName -Value $testAttributeValue -Prefix $testNamespacePrefix -Namespace $testNamespaceUri;
            }
        };

        $xmlDocument.OuterXml | Should Match $expectedAttribute;
        $xmlDocument.OuterXml | Should Match $expectedNamespace;
    }

    It 'throws when adding attribute when document contains no root element' {

        $testAttributeName = 'TestAttribute';
        $testAttributeValue = 'TestAttributeValue';
        {
            XmlDocument {
                XmlAttribute -Name $testAttributeName -Value $testAttributeValue
            }
        } | Should Throw "Cannot add a 'XmlAttribute' to a document without a root element";
    }

} #end describe Src\Add-XmlExAttribute
