<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:auto="http://www.cars.com"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" encoding="UTF-8" version="1.0" indent="no" />

<xsl:template match="/">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="auto:cars">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="auto:model">
  <xsl:value-of select="@manufacturer" />
  <xsl:text> </xsl:text>
  <xsl:value-of select="@model" />
  <xsl:text> (</xsl:text>
  <xsl:value-of select="@year" />
  <xsl:text>)</xsl:text>
</xsl:template>

</xsl:stylesheet>
