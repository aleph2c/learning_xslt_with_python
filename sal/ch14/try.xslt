<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:saxon="http://saxon.sf.net/" exclude-result-prefixes="saxon">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:template match="/">
  <test>
    <xsl:value-of select="saxon:try(*[0], 'Index out of bounds')"/>
    </test>
  </xsl:template>
  
</xsl:stylesheet>
