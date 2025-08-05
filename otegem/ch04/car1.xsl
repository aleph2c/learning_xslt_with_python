<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" encoding="UTF-8"/>

<xsl:template match="/">
  <xsl:apply-templates select="*|@*" />
</xsl:template>

<xsl:template match="car">
  <!-- must provide an @* argument to the default
       * wildcard, or the processor won't check the attribute
  nodes for a match with the templates -->
  <xsl:apply-templates select="*|@*" />
</xsl:template>


<xsl:template match="model|@model">
  Model:  <xsl:value-of select="." />
</xsl:template>

<xsl:template match="Manufacturer|@manufacturer">
  Manufacturer:  <xsl:value-of select="." />
</xsl:template>

<xsl:template match="year|@year">
  Year:   <xsl:value-of select="." />
</xsl:template>

</xsl:stylesheet>
