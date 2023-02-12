<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/10/xpath-functions" xmlns:xdt="http://www.w3.org/2004/10/xpath-datatypes" xmlns:csv="http://www.ora.com/XSLTCookbook/namespaces/csv">
   
<xsl:import href="toCSV.xslt"/>
   
<!--Defines the mapping from attributes to columns -->
<xsl:variable name="columns" select="'Name', 'Age', 'Gender', 'Smoker'" as="xs:string*"/>
<xsl:variable name="nodeNames" select="'name', 'age', 'sex', 'smoker'" as="xs:string*"/>


<xsl:template match="group" mode="csv:map-row">
<xsl:value-of select="@name,'&#xa;'"/>
<xsl:apply-templates mode="#current"/>
</xsl:template>

<!-- Switch default processing from elements to attributes -->
<xsl:template match="/*/*/*" mode="csv:map-row">
  <xsl:call-template name="csv:map-row">
    <xsl:with-param name="elemOrAttr" select=" 'attr' "/>
  </xsl:call-template>
</xsl:template>

<!-- Handle custom attribute mappings -->
   
<xsl:template match="@sex" mode="csv:map-value">
  <xsl:choose>
    <xsl:when test=".='m'">male</xsl:when>
    <xsl:when test=".='f'">female</xsl:when>
    <xsl:otherwise>error</xsl:otherwise>
  </xsl:choose>
</xsl:template>
   
</xsl:stylesheet>


