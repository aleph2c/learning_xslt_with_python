<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" 

xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xs="http://www.w3.org/2001/XMLSchema" 
xmlns:fn="http://www.w3.org/2004/10/xpath-functions" 
xmlns:xdt="http://www.w3.org/2004/10/xpath-datatypes"
xmlns:text="http://www.ora.com/XSLTCookbook/namespaces/text">
  
<xsl:include href="justify.xslt"/>
   
<xsl:output method="text" />
   
<xsl:strip-space elements="*"/>
   
<xsl:template match="people">
Name                 Age    Sex   Smoker
--------------------|------|------|----------
<xsl:apply-templates/>
</xsl:template>
   
<xsl:template match="person">
  <xsl:value-of select="text:justify(@name,20),
                        text:justify(@age,6,'right'),
                        text:justify(@sex,6,'center'),
                        text:justify(@smoker,9,'right')" separator="|"/>
  <xsl:text>&#xa;</xsl:text>  
</xsl:template>
   
</xsl:stylesheet>


