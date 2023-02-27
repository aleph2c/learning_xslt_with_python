<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" encoding="UTF-8" version="1.0" indent="no" />
<xsl:strip-space elements="*" />

<xsl:variable name="dishes" select="document('menu3.xml')//dish" />

<xsl:template match="/">
  <xsl:apply-templates select="//order" />
  <xsl:text>&#xA;Total: $</xsl:text>
  <!--
  <xsl:call-template name="total">
    <xsl:with-param name="order" select="//order" />
    </xsl:call-template>
  -->

</xsl:template>

<xsl:template name="order">
  <xsl:value-of select="@quantity" />
  <!--
  <xsl:text> x </xsl:text>
  <xsl:value-of select="$dishes[@id = current()/@id]" />
  <xsl:text> ($</xsl:text>
  <xsl:value-of select="$dishes[@id = current()/@id]/price" />
  <xsl:text> = </xsl:text>
  <xsl:value-of select="format-number($dishes[@id = current()/@id]/@price * @quantity, '0.00')" />
    <xsl:text>&#xA;</xsl:text>
  -->
</xsl:template>

<xsl:template name="total">
  <xsl:param name="order" />
  <xsl:choose>
    <xsl:when test="$order">
      <xsl:variable name="subtotal">
        <xsl:call-template name="total">
          <xsl:with-param name="order" select="$order[position() != 1] "/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="price"
        select="$dishes[@id = $order[1]/@id]/@price" />
      <xsl:value-of select="$subtotal + $price * $order[1]/quantity" />
    </xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
