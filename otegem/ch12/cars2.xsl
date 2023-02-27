<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" encoding="UTF-8" />
<xsl:strip-space elements="*" />

<xsl:template match="/">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="cars">
  <xsl:apply-templates>
    <xsl:sort select="@manufacturer" order="ascending" />
    <xsl:sort select="@model" order="ascending" />
    <xsl:sort select="@name" order="ascending" />
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="car">
  <xsl:value-of select="@manufacturer" />
  <xsl:text> </xsl:text>
  <xsl:value-of select="@model" />
  <xsl:text> </xsl:text>
  <xsl:value-of select="'(' || @year || ')'" />
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="model">
  <xsl:value-of select="@manufacturer" />
  <xsl:text> </xsl:text>
  <xsl:value-of select="@name" />
  <xsl:text> </xsl:text>
  <xsl:value-of select="'(' || @year || ')'" />
  <xsl:text>&#xA;</xsl:text>
  
</xsl:template>



</xsl:stylesheet>
