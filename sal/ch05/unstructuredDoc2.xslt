<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/10/xpath-functions" xmlns:xdt="http://www.w3.org/2004/10/xpath-datatypes" exclude-result-prefixes="xs fn xdt">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  
<xsl:template match="/doc">
  <xsl:copy>
	  <xsl:for-each-group select="*" group-starting-with="heading">
      <group>
        <xsl:apply-templates select="current-group()[self::para]"/> 
      </group>               
	  </xsl:for-each-group>             
  </xsl:copy>
</xsl:template>
  
  <xsl:template match="para">
   <copy>
     <xsl:apply-templates/>
   </copy>
  </xsl:template>
   
</xsl:stylesheet>
