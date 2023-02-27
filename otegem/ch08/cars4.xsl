<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" encoding="UTF-8" version="5.0" indent="yes" />

<xsl:template match="/">
  <html>
    <body>
      <h1>Auto show</h1>
      <xsl:apply-templates select="/cars/manufacturers" />
    </body>
  </html>
</xsl:template>

<xsl:template match="manufacturers">
  <xsl:for-each select="manufacturer">
    <h2><xsl:value-of select="@name" /></h2>
    <p><i>Country: <xsl:value-of select="@country" /></i></p>
    <xsl:variable name="mfc" select="." />
    <xsl:for-each select="/cars/models/model[@manufacturer = $mfc/@id]">
      <ul>
        <li>
          <xsl:value-of select="@name" />
          <xsl:text> (</xsl:text>
          <xsl:value-of select="@year" />
          <xsl:text>)</xsl:text>
        </li>
      </ul>
    </xsl:for-each>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
