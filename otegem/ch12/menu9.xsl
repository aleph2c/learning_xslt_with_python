<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  try
  -d otegem/ch12
  ex
  -x menu9.xml \
  -l menu9.xsl \
  -o menu9_output.txt
  -v
-->

<xsl:output method="text" encoding="UTF-8" />
<xsl:strip-space elements="*" />

<xsl:template match="/">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="menu">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="appetizers|entrees|desserts">
  <xsl:value-of select="@title || '&#xA;'" />
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="dish">
  <xsl:text> </xsl:text>
  <!--
    <xsl:number level="multiple" count="dish|menu/*" />
    <xsl:number level="multiple" count="*" from="menu/*" />
  -->

  <xsl:number level="multiple" count="*" from="menu/*" format="1.i"/>
  <xsl:text> </xsl:text>
  <xsl:value-of select="." />
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<!-- remove default behavior -->
<xsl:template match="*">
  <xsl:message terminate="no">
    WARNING: Unmatched element: <xsl:value-of select="name()"/>
  </xsl:message>
  <xsl:apply-templates/>
</xsl:template>
</xsl:stylesheet>
