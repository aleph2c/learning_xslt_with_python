<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" encoding="UTF-8" />
<xsl:strip-space elements="*" />

<xsl:template match="/">
  <xsl:text>&#xA;</xsl:text>
  <xsl:text>CARS:</xsl:text>
  <xsl:text>&#xA;</xsl:text>
  <xsl:for-each select="cars/car">
    <xsl:sort select="@manufacturer " order="ascending" />
    <xsl:sort select="@model" />
    <xsl:text>  </xsl:text>
    <xsl:value-of select="@model" />
    <xsl:text> </xsl:text>
    <xsl:value-of select="'(' || @year || ')'" />
    <xsl:text>&#xA;</xsl:text>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
