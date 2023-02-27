<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:car="http://www.example.com/xmlns/car"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" encoding="UTF-8" indent="yes" />
<xsl:strip-space elements="*" />

<xsl:template match="/">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="cars">
  <car:cars>
    <xsl:apply-templates />
  </car:cars>
</xsl:template>

<xsl:template match="car">
  <car:car>
    <xsl:apply-templates select="@*" />
  </car:car>
</xsl:template>

<xsl:template match="@*">
  <xsl:attribute name="car:{name()}">
    <xsl:value-of select="." />
  </xsl:attribute>
</xsl:template>





</xsl:stylesheet>
