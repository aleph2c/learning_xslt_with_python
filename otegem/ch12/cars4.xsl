<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" encoding="UTF-8" />
<xsl:strip-space elements="*" />

<!--
  try -d otegem/ch12 \
  ex \
  -x cars4.xml \
  -l cars4.xsl \
  -a "sortkey1='model',sortkey2='manufacturer',order='ascending'" \
  -o cars4_output.txt
  -v
-->

<xsl:param name="sortkey1">manufacturer</xsl:param>
<xsl:param name="sortkey2">model</xsl:param>
<xsl:param name="order">descending</xsl:param>

<xsl:template match="/">
  <!--
  <xsl:value-of select="$sortkey1" />
  <xsl:text>&#xA;</xsl:text>
  <xsl:value-of select="$sortkey2" />
  <xsl:text>&#xA;</xsl:text>
  <xsl:value-of select="$order" />
  -->

  <!-- doesn't work
  <xsl:variable name="_path">
    <xsl:value-of select="root/meta/path" />
  </xsl:variable>
  <xsl:variable name="path_string" select="'root/' || $_path" />
  <xsl:value-of select="$path_string" />
  <xsl:variable name="path">
    <xsl:evaluate xpath="$path_string" context-item="." />
    </xsl:variable>
  <xsl:text>&#xA;</xsl:text>
  <xsl:value-of select="path" />
    <xsl:text>&#xA;</xsl:text>
  -->

  <xsl:for-each select="root/cars/car">
    <xsl:sort select="attribute::*[name() = $sortkey1]" order="{$order}" />
    <xsl:sort select="attribute::*[name() = $sortkey2]" />
    <xsl:value-of select="@manufacturer" />
    <xsl:text> </xsl:text>
    <xsl:value-of select="@model" />
    <xsl:text> </xsl:text>
    <xsl:value-of select="'(' || @year || ')'" />
    <xsl:text>&#xA;</xsl:text>
  </xsl:for-each>

</xsl:template>

</xsl:stylesheet>
