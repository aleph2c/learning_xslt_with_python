<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/directory">
    <grouped-files>
      <xsl:for-each-group select="file" group-by="@type">
        <group type="{current-grouping-key()}">
          <xsl:for-each select="current-group()">
            <file name="{@name}" ext="{@ext}"/>
          </xsl:for-each>
        </group>
      </xsl:for-each-group>
    </grouped-files>
  </xsl:template>
</xsl:stylesheet>
