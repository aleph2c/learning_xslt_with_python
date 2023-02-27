<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" encoding="UTF-8" version="5.0" indent="yes" />

<xsl:variable name="bgcolor">
  <body>#cccccc</body>
  <table>#ffff01</table>
  <row>#ccccf</row>
  <altrow>#ffff03</altrow>
</xsl:variable>

<xsl:template match="/">
  <html>
    <body bgcolor="{$bgcolor/body}">
      <xsl:apply-templates />
    </body>
  </html>
</xsl:template>

<xsl:template match="cars">
  <table bgcolor="{bgcolor/table}" width="75%">
    <xsl:for-each select="car">
      <tr>
        <xsl:attribute name="bgcolor">
          <xsl:choose>
            <xsl:when test="position() mod 2 = 0">
              <xsl:value-of select="$bgcolor/altrow" />
            </xsl:when>
            <xsl:when test="position() mod 2 = 1">
              <xsl:value-of select="$bgcolor/row" />
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
