<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
 <!-- Default output format is XML -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
 <!-- Another named output format for HTML -->
  <xsl:output method="html" encoding="UTF-8" indent="yes" name="html-out"/>

<xsl:template match="/">
  <xsl:apply-templates/>
  <xsl:result-document href="result.html" format="html-out"> 
    <xsl:apply-templates mode="html"/>
  </xsl:result-document>
</xsl:template>

<!-- Other templates here -->
  
</xsl:stylesheet>
