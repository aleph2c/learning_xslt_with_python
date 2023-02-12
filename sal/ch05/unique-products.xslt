<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:template match="/">
    <products>
      <xsl:for-each-group select="//product" group-by="@sku">
        <xsl:copy-of select="current-group()[1]"/>
      </xsl:for-each-group>
    </products>
  </xsl:template>
  
</xsl:stylesheet>
