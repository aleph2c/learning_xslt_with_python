<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes" 
xmlns:ckbk="http://www.oreilly.com/catalog/xsltckbk">

<xsl:output method="text"/>

<xsl:template match="/">
  <xsl:if test="ckbk:string-index-of('abcd', 'bc') != 2">
    <xsl:message terminate="yes">ckbk:string-index-of('abcd', 'bc') != 2</xsl:message>
  </xsl:if>
  <xsl:if test="ckbk:string-index-of('abcd', 'e') != 0">
    <xsl:message terminate="yes">ckbk:string-index-of('abcd', 'e') != 0</xsl:message>
  </xsl:if>
  <xsl:if test="ckbk:string-index-of('', 'e') != 0">
    <xsl:message terminate="yes">ckbk:string-index-of('', 'e') != 0</xsl:message>
  </xsl:if>
  <xsl:if test="ckbk:string-index-of('abcd', '') != 1">
    <xsl:message terminate="yes">ckbk:string-index-of('abcd', '') != 1</xsl:message>
  </xsl:if>
</xsl:template>

<xsl:function name="ckbk:string-index-of">
  <xsl:param name="input"/>
  <xsl:param name="substr"/>
  <xsl:sequence select="if (contains($input, $substr)) 
                        then string-length(substring-before($input, $substr))+1 
                        else 0"/>
</xsl:function>

</xsl:stylesheet>
