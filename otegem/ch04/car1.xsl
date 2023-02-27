<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text">
<xsl:template match="/">
  <xsl:apply-templates select="*|@*" />
</xsl:template>

<xsl:template match="model|@model ">
  Model:  <xsl:value-of select="." />
</xsl:template>

<xsl:template match="Manufacturer|@manufacturer">
  Manufacturer:  <xsl:value-of select="." />
</xsl:template>

<xsl:template match="year|@year">
  Year:   <xsl:value-of select="." />
</xsl:template>

</xsl:stylesheet>
