<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" encoding="UTF-8" version="1.0" indent="no" />
<xsl:strip-space elements="*" />

<xsl:template match="/">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="menu">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="appetizers|entrees|desserts">
  <xsl:value-of select="@title || '&#xA;'" />
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="dish">
  <xsl:text> </xsl:text>
  <xsl:number level="any" />
  <xsl:text> </xsl:text>
  <xsl:value-of select="." />
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

</xsl:stylesheet>
