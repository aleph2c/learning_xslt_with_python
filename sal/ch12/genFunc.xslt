<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xs="http://www.w3.org/2001/XMLSchema" 
xmlns:fn="http://www.w3.org/2005/02/xpath-functions" 
xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes"
xmlns:ckbk="http://www.ora.com/xsltckbk">
	
	<xsl:output method="text"/>

<xsl:template match="/">
	<xsl:value-of select="ckbk:function-decl('func1', 'int', ('a','b'),  ('int','string'),  ('','') )"/>
</xsl:template>	
	
	<xsl:function name="ckbk:function-decl" as="xs:string*">
		<xsl:param name="name" as="xs:string"/>
		<xsl:param name="returnType" as="xs:string"/>
		<xsl:param name="argNames" as="xs:string*"/>
		<xsl:param name="argTypesPre" as="xs:string*"/>
		<xsl:param name="argTypesPost" as="xs:string*"/>
		<xsl:variable name="c" select="count($argNames)"/>
		<xsl:sequence select="$returnType,
		                                   $name,
		                                   '(', 
		                                   for $i in 1 to $c return ($argTypesPre[$i], $argNames[$i], $argTypesPost[$i], if ($i ne $c) then ',' else ''), 
		                                   ');' "/> 
	</xsl:function>
	 
</xsl:stylesheet>
