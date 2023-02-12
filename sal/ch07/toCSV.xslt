<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xs="http://www.w3.org/2001/XMLSchema" 
xmlns:fn="http://www.w3.org/2004/10/xpath-functions" 
xmlns:csv="http://www.ora.com/XSLTCookbook/namespaces/csv">
   
<xsl:param name="delimiter" select=" ',' "/>

<!--These should be overridden in importing stylesheet -->
<xsl:variable name="columns" select="()" as="xs:string*"/>
<xsl:variable name="nodeNames" select="$columns" as="xs:string*"/>
   
<xsl:output method="text" />
   
<xsl:strip-space elements="*"/>
     
<xsl:template match="/">
  <!--Here we use the new ability of value-of-->
  <xsl:value-of select="$columns" separator="{$delimiter}"/>
  <xsl:text>&#xa;</xsl:text>
  <xsl:apply-templates mode="csv:map-row"/>
</xsl:template>
   
<xsl:template match="/*/*" mode="csv:map-row" name="csv:map-row">

  <xsl:param name="elemOrAttr" select=" 'elem' " as="xs:string"/>
  
  <xsl:variable name="row" select="." as="node()"/>
  
  <xsl:for-each select="$nodeNames">
    <xsl:apply-templates select="if ($elemOrAttr eq 'elem') 
                                 then $row/*[local-name(.) eq current()] 
                                 else $row/@*[local-name(.) eq current()]" 
                         mode="csv:map-value"/>
    <xsl:value-of select="if (position() ne last()) then $delimiter else ()"/>
  </xsl:for-each>
   
  <xsl:text>&#xa;</xsl:text>
 
</xsl:template>
   
<xsl:template match="node()" mode="csv:map-value">
  <xsl:value-of select="."/>
</xsl:template>
   
</xsl:stylesheet>
