<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/10/xpath-functions" xmlns:xdt="http://www.w3.org/2004/10/xpath-datatypes" exclude-result-prefixes="xs fn xdt">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  
  <xsl:template match="/doc">
    <xsl:copy>
      <xsl:apply-templates select="heading"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="heading">
  <xsl:variable name="numFollowingPara" select="count(following-sibling::para)"/>
    <xsl:variable name="lastParaInHeading" 
                  select="$numFollowingPara -
                          count(following-sibling::heading[1]/following-sibling::para)"/>
    <group>
    <xsl:apply-templates 
      select="following-sibling::para[position() &lt;= $lastParaInHeading]"/>
    </group>               
  </xsl:template>

  <xsl:template match="para">
   <copy>
     <xsl:apply-templates/>
   </copy>
  </xsl:template>
   
</xsl:stylesheet>
