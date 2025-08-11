<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/directory">
    <grouped-files>
      <xsl:for-each-group select="file" group-by="category">
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

  <!-- Catch-all template for unmatched nodes -->
  <xsl:template match="*">
    <xsl:message terminate="no">
      WARNING: Unmatched element: <xsl:value-of select="name()"/>
    </xsl:message>
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
