<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes"
xmlns:ckbk="http://www.oreilly.com/catalog/xsltckbk">

  <xsl:output method="text"/>


  <xsl:template match="/">
    <xsl:if test="ckbk:dup('a') ne 'aa'">
      <xsl:message terminate="yes">
        <xsl:value-of select="ckbk:dup('a')"/> ne 'aa'
      </xsl:message>
    </xsl:if>
    
    <xsl:if test="ckbk:dup('a',5) ne 'aaaaa'">
      <xsl:message terminate="yes">
          <xsl:value-of select="ckbk:dup('a',5)"/> ne 'aaaaa'
      </xsl:message>
    </xsl:if>
  
  </xsl:template>
  
  <xsl:function name="ckbk:dup">
    <xsl:param name="input" as="xs:string"/>
    <xsl:sequence select="ckbk:dup($input,2)"/>
  </xsl:function>

  <xsl:function name="ckbk:dup">
    <xsl:param name="input" as="xs:string"/>
    <xsl:param name="count" as="xs:integer"/>
    <xsl:sequence select="string-join(for $i in 1 to $count return $input,'')"/>
  </xsl:function>

</xsl:stylesheet>
