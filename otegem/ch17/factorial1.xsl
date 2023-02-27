<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" encoding="UTF-8" version="1.0" indent="no" />
<xsl:strip-space elements="*" />

<xsl:template match="/">
  <xsl:variable name="input">
    <xsl:value-of select="factorial-of" />
  </xsl:variable>
  <xsl:message>calculating <xsl:value-of select="normalize-space($input)" />!</xsl:message>
  <xsl:call-template name="factorial">
    <xsl:with-param name="input" select="$input" />
  </xsl:call-template>
</xsl:template>
<xsl:template name="factorial">
  <xsl:param name="input">1</xsl:param>

  <xsl:choose>
    <!-- basecase -->
    <xsl:when test="$input = 1">
      <xsl:message><xsl:value-of select="$input" />! = <xsl:value-of select="$input" /></xsl:message>
      <xsl:value-of select="$input" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="result">
        <xsl:call-template name="factorial">
          <xsl:with-param name="input" select="$input - 1" />
        </xsl:call-template>
      </xsl:variable>
      <xsl:message><xsl:value-of select="normalize-space(string($input))" />! = <xsl:value-of select="$result * $input" /></xsl:message>
      <xsl:value-of select="$result * $input" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
