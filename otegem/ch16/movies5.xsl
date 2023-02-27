<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- doesn't work -->

<xsl:output method="text" encoding="UTF-8" version="1.0" indent="no" />
<xsl:strip-space elements="*" />

<!-- to use: key('searchkey', @name) -->
<xsl:key name="searchkey" match="directory|actor" use="@name" />
<!-- to use: key('searchkey', @name) -->

<xsl:param name="search">Sidney Poitier</xsl:param>

<xsl:template match="/">
  <xsl:value-of select="$search" />
  <xsl:for-each select="key('searchkey', $search)">
    <xsl:value-of select="@name" />
    <xsl:text>&#xA;</xsl:text>
    <xsl:value-of select="name()" />
    <xsl:text> </xsl:text>
    <xsl:value-of select="../@title" />
    <xsl:text>&#xA;</xsl:text>
  </xsl:for-each>
</xsl:template>


</xsl:stylesheet>
