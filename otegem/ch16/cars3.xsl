<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:car="http://www.cars.com"
  xmlns:m="http://www.manufacturer.com"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" encoding="UTF-8" version="1.0" indent="no" />

<xsl:key name="mfc" match="m:manufacturer" use="@m:id" />
<!-- to use: key('mfc', @m:id) -->

<xsl:template match="/">
  <xsl:apply-templates select="/car:cars/car:models" />
</xsl:template>

<xsl:template match="car:models">
  <xsl:for-each select="car:model">
    <xsl:value-of select="key('mfc', @m:id)/@m:name" />
    <xsl:text> </xsl:text>
    <xsl:value-of select="@car:name" />
    <xsl:text> (</xsl:text>
    <xsl:value-of select="@car:year" />
    <xsl:text>)&#xA;</xsl:text>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
