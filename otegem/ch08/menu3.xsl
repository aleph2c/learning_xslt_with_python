<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text"/>
  <xsl:variable name="week">7</xsl:variable>

  <xsl:template match="/">
    <!--
      count the dishes: 4
      adjust the week for 0-based for modulo ($week-1)
      modulo cycle ($week - 1) mod count( ... ): 6 mod 4 = 2 (remainder, cycles through 0-3)
      add 1 for 1-based indexing used by XPath, 2+1 = 3
      position filter (position() = ...) selects the dish at position 3
    -->
    <xsl:variable name="weekappetizer" select="/menu/appetizers/dish[position() = ((($week - 1) mod count(/menu/appetizers/dish)) + 1)]"/>
    <xsl:variable name="weekentree" select="/menu/entrees/dish[position() = ((($week - 1) mod count(/menu/entrees/dish)) + 1)]"/>
    <xsl:variable name="weekdessert" select="/menu/desserts/dish[position() = ((($week - 1) mod count(/menu/desserts/dish)) + 1)]"/>

    <xsl:text>This week's menu:&#xA;</xsl:text>
    <xsl:text>- </xsl:text><xsl:value-of select="$weekappetizer/text()"/><xsl:text> $</xsl:text><xsl:value-of select="$weekappetizer/@price"/><xsl:text>&#xA;</xsl:text>
    <xsl:text>- </xsl:text><xsl:value-of select="$weekentree/text()"/><xsl:text> $</xsl:text><xsl:value-of select="$weekentree/@price"/><xsl:text>&#xA;</xsl:text>
    <xsl:text>- </xsl:text><xsl:value-of select="$weekdessert/text()"/><xsl:text> $</xsl:text><xsl:value-of select="$weekdessert/@price"/>
  </xsl:template>
</xsl:stylesheet>
