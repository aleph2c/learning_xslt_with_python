<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text" encoding="UTF-8" />
  <xsl:strip-space elements="*" />

  <xsl:template match="/">
    <!--
    <xsl:apply-templates select="menu/*" />
    -->
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="menu/*">
    <!--
    <xsl:value-of select="concat(@title,'&#xA;')" />
    -->
    <xsl:value-of select="@title || '&#xA;'" />
    <xsl:apply-templates />
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="dish">
    <xsl:if test="string-length() + string-length(@price) lt 19">
      <xsl:value-of select="." />  $<xsl:value-of select="@price" />
      <xsl:text>&#xA;</xsl:text>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
