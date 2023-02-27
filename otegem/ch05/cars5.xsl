<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" />

<xsl:template match="/">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="cars">
  <xsl:copy>
    <xsl:apply-templates />
  </xsl:copy>
</xsl:template>

<xsl:template match="car">
  <xsl:copy />
</xsl:template>

</xsl:stylesheet>
