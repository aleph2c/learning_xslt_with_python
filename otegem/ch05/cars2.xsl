<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" />

<xsl:template match="/">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="cars">
  <table border='1' width="500">
    <xsl:call-template name="tableprop" />
    <xsl:apply-templates />
  </table>
</xsl:template>

<xsl:template match="car">
  <tr bgcolor="#dddddd">
    <xsl:apply-templates select="@*" />
  </tr>
</xsl:template>

<xsl:template name="tableprop">
  <xsl:attribute name="border">1</xsl:attribute>
  <xsl:attribute name="width">500</xsl:attribute>
</xsl:template>



</xsl:stylesheet>
