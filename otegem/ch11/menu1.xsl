<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  try -d otegem/ch10 \
  ex \
    -x menu1.xml \
    -l menu1.xsl \
    /-/-params "week=6,unused=4" \
    -o menu1_output.txt -v
-->

<xsl:output method="text" encoding="UTF-8" />

<xsl:param name="week" as="xs:string">1</xsl:param>
<xsl:variable name="_week" select="number($week)" />

<xsl:param name="unused" as="xs:string">13</xsl:param>
<xsl:variable name="_unused" select="number($unused)" />

<xsl:template match="/">
  <xsl:variable name="weekmenu">
    <xsl:call-template name="getmenu">
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="$weekmenu/dish[1]" />
  <xsl:text>, </xsl:text>
  <xsl:value-of select="$weekmenu/dish[2]" />
  <xsl:text> and </xsl:text>
  <xsl:value-of select="$weekmenu/dish[3]" />
  <xsl:text> only $27.95</xsl:text>

</xsl:template>

<xsl:template name="getmenu">
    <xsl:copy-of select="/menu/appetizers/dish[position() =
        ((($_week - 1) mod count(/menu/appetizers/dish)) + 1)]" />
    <xsl:copy-of select="/menu/entrees/dish[position() =
        ((($_week - 1) mod count(/menu/entrees/dish)) + 1)]" />
    <xsl:copy-of select="/menu/desserts/dish[position() =
        ((($_week - 1) mod count(/menu/desserts/dish)) + 1)]" />
</xsl:template>

</xsl:stylesheet>
