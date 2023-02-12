<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:math="java:java.lang.Math" 
 exclude-result-prefixes="math">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:template match="/">
    <pi><xsl:value-of select="4 * math:atan(1.0)"/></pi>
  </xsl:template>
  
</xsl:stylesheet>
