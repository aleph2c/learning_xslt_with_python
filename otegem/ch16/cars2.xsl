<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:car="http://www.cars.com"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" encoding="UTF-8" version="1.0" indent="no" />

<xsl:template match="/">
<!--

  preceding-sibling -> look at graph it docs
  car:model -> to select the node type of car:model, ignore other node types
  /@manufacturer -> get this node's manufacturer attribute type

  <xsl:for-each select="//car:model[not(@manufacturer =
  preceding-sibling::car:model/@manufacturer)]/@manufacturer">

-->

<!--

  This is the modern way of getting distinct values

  <xsl:for-each select="distinct-values(//car:model/@manufacturer)">

-->

  <xsl:for-each select="//car:model[not(@manufacturer = preceding-sibling::*/@manufacturer)]/@manufacturer">
  <xsl:sort select="." order="ascending" />
  <xsl:value-of select=". || '&#xA;'" />
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>

<xsl:apply-templates />

