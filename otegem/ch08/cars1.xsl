<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" encoding="UTF-8" version="5.0" indent="yes" />

<xsl:variable name="bgcolor">#cccccc</xsl:variable>
<xsl:variable name="altbgcolor">#ffff10</xsl:variable>

<xsl:template match="/">
  <html>
    <body bgcolor="{$bgcolor}">
      <xsl:apply-templates />
    </body>
  </html>
</xsl:template>

<xsl:template match="cars">
  <table bgcolor="{$altbgcolor}" width="75%">
    <xsl:for-each select="car">
      <tr>
        <xsl:attribute name="bgcolor">
          <xsl:choose>
            <xsl:when test="position() mod 2 = 0">
              <xsl:value-of select="$altbgcolor" />
            </xsl:when>
            <xsl:when test="position() mod 2 = 1">
              <xsl:value-of select="$bgcolor" />
            </xsl:when>
          </xsl:choose>
        </xsl:attribute>
        <xsl:call-template name="car" />
      </tr>
    </xsl:for-each>
  </table>
</xsl:template>

<xsl:template name="car">
  <td><xsl:value-of select="@model" /></td>
  <td><xsl:value-of select="@manufacturer" /></td>
  <td><xsl:value-of select="@year" /></td>
</xsl:template>


</xsl:stylesheet>
