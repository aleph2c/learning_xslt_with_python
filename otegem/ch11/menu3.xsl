<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  try
  -d otegem/ch10
  ex
  -x menu3.xml \
  -l menu3.xsl \
  -a "week=6" \
  -o menu3_output.txt
  -v
-->
<xsl:param name="week">1</xsl:param>

<xsl:output method="text" encoding="UTF-8" />
<xsl:strip-space elements="*" />

<xsl:template match="/">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="menu/*">
  <xsl:value-of select="concat(@title, '&#xA;')" />
  <xsl:apply-templates />
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="dish">
  <xsl:if test="not(contains(., 'Salmon') or 
                    contains(., 'Sea') or
                    contains(., 'Crab') or
                    contains(., 'Prawn'))
  ">
    <xsl:value-of select="." /> $<xsl:value-of select="@price" />
    <xsl:text>&#xA;</xsl:text>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
