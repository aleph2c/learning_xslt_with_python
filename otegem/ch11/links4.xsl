<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" encoding="UTF-8" version="5.0" indent="no" />

<xsl:template match="/">
  <html>
    <body>
      <xsl:apply-templates />
    </body>
  </html>
</xsl:template>

<xsl:template match="link">
  <a>
    <xsl:attribute name="href">
      <xsl:if test="not(starts-with(@href, 'http://'))">
        <xsl:text>http://</xsl:text>
      </xsl:if>
      <xsl:value-of select="@href" />
    </xsl:attribute>
    <xsl:value-of select="." />
  </a><br />
</xsl:template>
</xsl:stylesheet>
