<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>


  <!--
    # Group adjacent actions usually follow after sort process
    # (use group_adjacent_1.a.xsl to sort)

    try -d sal/ch06 ex -x
    group_adjacent_1.b.xml -l
    group_adjacent_1.b.xsl
    -o group_adjacent_1.c.xml -v

  -->

  <xsl:template match="/directory">
    <grouped-files>
      <xsl:for-each-group select="file" group-adjacent="category">
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
