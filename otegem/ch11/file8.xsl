<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" encoding="UTF-8" />
<xsl:strip-space elements="*" />

<xsl:variable name="extensions">
  <ext ext="doc">Word Document</ext>
  <ext ext="dwg">AutoCad Drawing</ext>
  <ext ext="xml">XML Document</ext>
  <ext ext="xsl">XSLT Stylesheet</ext>
</xsl:variable>

<xsl:template match="/">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="folder">
  <xsl:value-of select="concat('&lt;',@name, '&gt;&#xA;')" />
  <!--
  <xsl:value-of select="'&lt;' || @name || '&gt;' || '&#xA;'" />
  -->
  <xsl:apply-templates />
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="file">
  <xsl:variable name="ext" select="substring-after(.,'.')" />
  <xsl:value-of select="concat(., '&#xA0;')" />
  <!--
  <xsl:value-of select=". || $space " />
  -->
  <xsl:if test="$extensions/ext[@ext=$ext]">
    <xsl:value-of select="'(' || $extensions/ext[@ext=$ext] || ')'" />
  </xsl:if>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

</xsl:stylesheet>
