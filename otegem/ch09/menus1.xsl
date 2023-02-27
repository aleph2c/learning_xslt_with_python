<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text" encoding="UTF-8" version="1.0" indent="no" />

  <xsl:template match="/">
    <xsl:variable name="weekmenu">
      <xsl:call-template name="getmenu">
        <xsl:with-param name="week">7</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:call-template name="displaymenu">
      <xsl:with-param name="menu" select="$weekmenu" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="getmenu">
    <xsl:param name="week">1</xsl:param>
    <xsl:copy-of select="/menu/appetizers/dish[position() =
        ((($week - 1) mod count(/menu/appetizers/dish)) + 1)]" />
    <xsl:copy-of select="/menu/entrees/dish[position() =
        ((($week - 1) mod count(/menu/entrees/dish)) + 1)]" />
    <xsl:copy-of select="/menu/desserts/dish[position() =
        ((($week - 1) mod count(/menu/desserts/dish)) + 1)]" />
  </xsl:template>

  <xsl:template name="displaymenu">
    <xsl:param name="menu" />
    <xsl:if test="$menu">
      <xsl:text>This week's menu:</xsl:text>
      <xsl:for-each select="$menu/dish">
        <xsl:text>&#xA;- </xsl:text><xsl:value-of select="." />
        <xsl:text> $</xsl:text><xsl:value-of select="@price" />
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
