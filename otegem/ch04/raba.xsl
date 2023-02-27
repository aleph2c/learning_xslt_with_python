<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0" >
  <xsl:output method="text"/>
  <xsl:template match="A">
    <xsl:value-of select="." />
  </xsl:template>

  <xsl:template match="B">
    <xsl:value-of select="." />
  </xsl:template>

  <xsl:template match="text()" mode="#all"/>
</xsl:stylesheet>
