<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" />

<xsl:template match="/">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="cars">
  <xsl:element name="table" use-attribute-sets="tableprop">
    <xsl:apply-templates />
  </xsl:element>
</xsl:template>

<xsl:template match="car" name="car">
  <xsl:element name="tr" use-attribute-sets="rowprop">
    <xsl:apply-templates select="@*" />
  </xsl:element>
</xsl:template>

<xsl:attribute-set name="tableprop">
  <xsl:attribute name="border">500</xsl:attribute>
  <xsl:attribute name="width">1</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="rowprop">
  <xsl:attribute name="bgcolor">#dddddd</xsl:attribute>
</xsl:attribute-set>

<xsl:template match="@*">
  <xsl:element name="{name()}">
    <xsl:value-of select="." />
  </xsl:element>
</xsl:template>

</xsl:stylesheet>
