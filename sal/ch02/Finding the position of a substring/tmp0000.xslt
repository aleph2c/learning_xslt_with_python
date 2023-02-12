<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes"
xmlns:ckbk="http://www.oreilly.com/catalog/xsltckbk">

  <xsl:output method="text"/>


  <xsl:template match="/">

    <xsl:if test="ckbk:reverse-alt('abcdefg') ne 'gfedcba'">
      <xsl:message terminate="yes">
        <xsl:value-of select="ckbk:reverse-alt('abcdefg')"/> ne 'gfedcba'
      </xsl:message>
    </xsl:if>
    
    <xsl:if test="ckbk:reverse('a') ne 'a'">
      <xsl:message terminate="yes">
          <xsl:value-of select="ckbk:reverse('a')"/> ne 'a'
      </xsl:message>
    </xsl:if>

    <xsl:if test="ckbk:reverse('') ne ''">
      <xsl:message terminate="yes">
          <xsl:value-of select="ckbk:reverse('')"/> ne ''
      </xsl:message>
    </xsl:if>
  
  </xsl:template>
  
  <xsl:function name="ckbk:reverse">
    <xsl:param name="input" as="xs:string"/>
    <xsl:sequence select="codepoints-to-string(reverse(string-to-codepoints($input)))"/>
  </xsl:function>

  <xsl:function name="ckbk:reverse-alt">
    <xsl:param name="input" as="xs:string"/>
    <xsl:sequence select="string-join(reverse(tokenize($input,'.')),'')"/>
  </xsl:function>

</xsl:stylesheet>
