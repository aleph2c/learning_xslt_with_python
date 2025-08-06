<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text"/>
  <xsl:template match="/">
    <xsl:variable name="week">7</xsl:variable>
    <xsl:variable name="weekappetizer" select="/menu/appetizers/dish[position() = ((($week - 1) mod count(/menu/appetizers/dish)) + 1)]"/>
    <xsl:variable name="weekentree" select="/menu/entrees/dish[position() = ((($week - 1) mod count(/menu/entrees/dish)) + 1)]"/>
    <xsl:variable name="weekdessert" select="/menu/desserts/dish[position() = ((($week - 1) mod count(/menu/desserts/dish)) + 1)]"/>
    <xsl:text>This week's menu:&#xA;</xsl:text>
    <xsl:text>- </xsl:text><xsl:value-of select="$weekappetizer/text()"/><xsl:text> $</xsl:text><xsl:value-of select="$weekappetizer/@price"/><xsl:text>&#xA;</xsl:text>
    <xsl:text>- </xsl:text><xsl:value-of select="$weekentree/text()"/><xsl:text> $</xsl:text><xsl:value-of select="$weekentree/@price"/><xsl:text>&#xA;</xsl:text>
    <xsl:text>- </xsl:text><xsl:value-of select="$weekdessert/text()"/><xsl:text> $</xsl:text><xsl:value-of select="$weekdessert/@price"/>
  </xsl:template>
</xsl:stylesheet>
