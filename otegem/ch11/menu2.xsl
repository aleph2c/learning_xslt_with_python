<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  try -d otegem/ch11 \
  ex \
    -x menu2.xml \
    -l menu2.xsl \
    -a "week=6,unused=4" \
    -o menu2_output.txt -v
-->

<xsl:output method="text" encoding="UTF-8" />

<xsl:param name="week" as="xs:string">1</xsl:param>
<xsl:param name="unused" as="xs:string">13</xsl:param>

<xsl:template match="/">
  <xsl:variable name="_week" select="number($week)"/>
  <xsl:variable name="weekmenu">
    <xsl:call-template name="getmenu">
      <xsl:with-param name="week" select="$_week"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="concat(
    $weekmenu/dish[1],', ',
    $weekmenu/dish[2],' and ',
  $weekmenu/dish[3],' only $27.95 ')" />
  <xsl:text>&#xA;</xsl:text>
  <!-- XPath 3.1 -->
  <xsl:value-of select="
    $weekmenu/dish[1]    || ', '
    || $weekmenu/dish[2] || ' and '
    || $weekmenu/dish[3] || ' only $27.95 '"
    />
</xsl:template>

<xsl:template name="getmenu">
    <xsl:param name="week"/>
    <xsl:copy-of select="/menu/appetizers/dish[position() =
        ((($week - 1) mod count(/menu/appetizers/dish)) + 1)]" />
    <xsl:copy-of select="/menu/entrees/dish[position() =
        ((($week - 1) mod count(/menu/entrees/dish)) + 1)]" />
    <xsl:copy-of select="/menu/desserts/dish[position() =
        ((($week - 1) mod count(/menu/desserts/dish)) + 1)]" />
</xsl:template>

</xsl:stylesheet>
