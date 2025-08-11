<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>

  <!--
    # Group adjacent actions usually follow a sort process, here
    # we don't use a pipeline of small files doing small transforms, we do it
    # all at once (to see a pipeline look at group_adjacent_1.{a,b,c}

    try -d sal/ch06 ex -x
    group_adjacent_2.xml -l
    group_adjacent_2.xsl
    -o group_adjacent2.xml -v
  -->

  <xsl:template match="/directory">
    <grouped-files>
      <xsl:for-each-group select="file" group-adjacent="category">
        <xsl:sort select="category"/>
        <group category="{current-grouping-key()}">
          <xsl:for-each select="current-group()">
            <file>
              <name><xsl:value-of select="name"/></name>
              <extension><xsl:value-of select="extension"/></extension>
            </file>
          </xsl:for-each>
        </group>
      </xsl:for-each-group>
    </grouped-files>
  </xsl:template>
  <xsl:template match="*">
    <xsl:message terminate="no">
      WARNING: Unmatched element: <xsl:value-of select="name()"/>
    </xsl:message>
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
