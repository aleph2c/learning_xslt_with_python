<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" encoding="UTF-8" version="1.0" indent="no" />

<xsl:template match="/">
  <xsl:apply-templates select="names/name" />
</xsl:template>

<xsl:template match="name">
  <xsl:call-template name="initial">
    <xsl:with-param name="fullname" select="normalize-space()" />
  </xsl:call-template>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="initial">
  <xsl:param name="fullname" />
  <xsl:choose>
    <xsl:when test="contains($fullname, ' ')">
      <xsl:value-of select="substring($fullname, 1, 1)" />
      <xsl:text>. </xsl:text>
      <xsl:call-template name="initial">
        <xsl:with-param name="fullname" select="substring-after($fullname, ' ')" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$fullname" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
