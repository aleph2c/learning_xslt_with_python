<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
<!--
  This missing document to make the saxonche 12.1.0 documentation make sense
-->
<xsl:output method="text" encoding="UTF-8" />

<xsl:strip-space elements="*" />
<xsl:mode on-no-match="shallow-skip" />

<xsl:template match="doc">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="item">
  <xsl:value-of select="." />
  <xsl:text>&#xA;</xsl:text>
</xsl:template>
</xsl:stylesheet>
