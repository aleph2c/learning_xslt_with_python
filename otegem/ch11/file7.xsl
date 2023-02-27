<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" encoding="UTF-8" />
<xsl:strip-space elements="*" />

<xsl:template match="/">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="folder">
  <xsl:value-of select="concat('&lt;', @name, '&gt;&#xA;')" />
  <xsl:apply-templates />
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="file">
  <xsl:variable name="len"
    select="string-length()" />
  <xsl:variable name="ext"
    select="substring(., $len - 2)" />
  <xsl:value-of select="concat(., '&#xA0;')" />
  <xsl:choose>
    <xsl:when test="$ext = 'doc'">
      <xsl:text>(Word document)</xsl:text>
    </xsl:when>
    <xsl:when test="$ext = 'dwg'">
      <xsl:text>(AutoCad drawing)</xsl:text>
    </xsl:when>
    <xsl:when test="$ext = 'xml'">
      <xsl:text>(XML document)</xsl:text>
    </xsl:when>
    <xsl:when test="$ext = 'xsl'">
      <xsl:text>(XSLT stylesheet)</xsl:text>
    </xsl:when>
  </xsl:choose>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>
</xsl:stylesheet>
