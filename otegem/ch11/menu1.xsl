<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  try -d otegem/ch11 \
  ex \
    -x menu1.xml \
    -l menu1.xsl \
    -a "week=6,unused=4" \
    -o menu1_output.txt -v
-->
  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:param name="week" as="xs:string">1</xsl:param>
  <xsl:param name="unused" as="xs:string">13</xsl:param>
  <xsl:template match="/">
    <xsl:variable name="_week" select="number($week)"/>
    <xsl:variable name="weekmenu">
      <xsl:call-template name="getmenu">
        <xsl:with-param name="week" select="$_week"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:call-template name="displaymenu">
      <xsl:with-param name="menu" select="$weekmenu"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="getmenu">
    <xsl:param name="week" as="xs:double">1</xsl:param>
    <xsl:copy-of select="/menu/appetizers/dish[position() = ((($week - 1) mod count(/menu/appetizers/dish)) + 1)]"/>
    <xsl:copy-of select="/menu/entrees/dish[position() = ((($week - 1) mod count(/menu/entrees/dish)) + 1)]"/>
    <xsl:copy-of select="/menu/desserts/dish[position() = ((($week - 1) mod count(/menu/desserts/dish)) + 1)]"/>
  </xsl:template>
  <xsl:template name="displaymenu">
    <xsl:param name="menu"/>
    <xsl:if test="$menu">
      <xsl:text>This week's menu:&#xA;</xsl:text>
      <xsl:for-each select="$menu/dish">
        <xsl:text>- </xsl:text><xsl:value-of select="."/>
        <xsl:text> $</xsl:text><xsl:value-of select="@price"/>
        <xsl:text>&#xA;</xsl:text>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>

