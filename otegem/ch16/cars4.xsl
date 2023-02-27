<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:car="http://www.cars.com"
  xmlns:m="http://www.manufacturer.com"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" encoding="UTF-8" version="5.0" indent="yes" />

<xsl:key name="cars" match="car:model" use="@m.id" />
<!-- to use: key('cars', @m.id) -->

<xsl:template match="/">
  <html>
    <body>
      <h1>Auto Show</h1>
      <xsl:apply-templates select="car:cars/m:manufacturers" />
    </body>
  </html>
</xsl:template>

<xsl:template match="m:manufacturers">
  <xsl:for-each select="m:manufacturer">
    <h2><xsl:value-of select="@m:name" /></h2>
    <p><i>Country: <xsl:value-of select="@m:country" /></i></p>
    <xsl:for-each select="key('cars', @m:id)">
      <ul>
        <li>
          <xsl:value-of select="@car:name" />
          <xsl:text> (</xsl:text>
          <xsl:value-of select="@car:year" />
          <xsl:text>)</xsl:text>
        </li>
      </ul>
    </xsl:for-each>
  </xsl:for-each>
</xsl:template>
</xsl:stylesheet>
