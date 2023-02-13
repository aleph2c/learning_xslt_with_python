<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:strip-space elements="*" />

<xsl:template match="document-node()">
  document:
  <xsl:apply-templates select="Test/parent" />
</xsl:template>

<xsl:template match="parent">
  <!--
    <xsl:value-of select="X/@id"></xsl:value-of>
  -->
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="X">
  <xsl:value-of select="."></xsl:value-of>
</xsl:template>

</xsl:stylesheet>
