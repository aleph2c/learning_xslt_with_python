<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:template match="doc">
    <xsl:copy>
      <xsl:for-each-group select="*" group-adjacent="name()">
        <xsl:if test="self::para">
          <topic>
            <xsl:copy-of select="current-group()"/>
          </topic>
        </xsl:if>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
