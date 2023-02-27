<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" />

<xsl:template match="/">
  <xsl:apply-templates />
</xsl:template>

<!--
  cars, will skip @* and apply templates to car
  car, will land with @* and skip the next apply
-->
<xsl:template match="*">
  <xsl:element name="{name()}">
    <xsl:apply-templates select="@*" />
    <xsl:apply-templates />
  </xsl:element>
</xsl:template>

<!--
  cars will be skipped
  car with it's attributes will land, the @ being turned into an element
  and the value of the attribute becoming the text
-->
<xsl:template match="@*">
  <xsl:element name="{name()}">
    <xsl:value-of select="." />
  </xsl:element>
</xsl:template>

</xsl:stylesheet>
