<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes" />

<xsl:template match="/">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="cars">
  <xsl:copy>
    <xsl:apply-templates select="car" />
  </xsl:copy>
</xsl:template>

<xsl:template match="car">
  <xsl:copy use-attribute-sets="years">
    <xsl:attribute name="model">Focus</xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:attribute-set name="years">
  <xsl:attribute name="year">1999</xsl:attribute>
</xsl:attribute-set>

</xsl:stylesheet>
