<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/02/xpath-functions" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:template match="/">
    <xsl:variable name="x" select="foo/bar"/>
    <xsl:variable name="y" select="foo/bar/bat"/>
    <xsl:variable name="z" select="foo/bang"/>
    
    <results>
      <r><xsl:value-of select="$x = $y/ancestor::node()"/></r>
      <r><xsl:value-of select="$x = $z/ancestor::node()"/></r>
    </results>
    
  </xsl:template>
  
</xsl:stylesheet>
