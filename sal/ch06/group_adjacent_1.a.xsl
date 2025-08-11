<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>

  <!--
    # Group adjacent actions usually follow a sort process
    #
    # for the 1_{a.b.c} example we create a pipeline of xsl that
    # act on their respective xml files, where the final xml file
    # (group_adjacent_1.c.xml) is our desired result.
    #
    # We are showing a pipeline so that each step can be understood.
    # To see how this can be done in one step see group_adjascent_2.xsl

    try -d sal/ch06 ex -x
    group_adjacent_1.a.xml -l
    group_adjacent_1.a.xsl
    -o group_adjacent_1.b.xml -v
  -->

  <xsl:template match="/directory">
    <directory>
      <xsl:for-each select="file">
        <xsl:sort select="category"/>
        <xsl:copy-of select="."/>
      </xsl:for-each>
    </directory>
  </xsl:template>

  <xsl:template match="*">
    <xsl:message terminate="no">
      WARNING: Unmatched element: <xsl:value-of select="name()"/>
    </xsl:message>
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
