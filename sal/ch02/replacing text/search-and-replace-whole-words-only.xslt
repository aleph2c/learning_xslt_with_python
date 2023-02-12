<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xs="http://www.w3.org/2001/XMLSchema" 
xmlns:fn="http://www.w3.org/2004/07/xpath-functions" 
xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes" 
xmlns:ckbk="http://www.oreilly.com/catalog/xsltckbk">
  
  <xsl:output method="text"/>


<xsl:template match="/">
  <xsl:value-of select="ckbk:search-and-replace-whole-words-only('The rain in spain falls mainly in the plain.','in','IN')"/>
  <xsl:text>&#xa;</xsl:text>
  <xsl:value-of select="ckbk:search-and-replace-whole-words-only('the there the','the','THE')"/>
</xsl:template>
  
<xsl:function name="ckbk:search-and-replace-whole-words-only">
	<xsl:param name="input" as="xs:string"/>
	<xsl:param name="search-string" as="xs:string"/>
	<xsl:param name="replace-string" as="xs:string"/>
	<xsl:sequence select="replace($input, concat('(^|\W)',$search-string,'(\W|$)'), concat('$1',$replace-string,'$2'))"/>
</xsl:function>

  
</xsl:stylesheet>
