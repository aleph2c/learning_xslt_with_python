<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/02/xpath-functions">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:variable name="data" as="element(data)">
    <data>1234.56 -2 -2.1 -2.1E-1 +2.222e+3 "abc"</data>
  </xsl:variable>
  
    <xsl:template match="/">
    <tokens>
       <xsl:apply-templates select="$data"/>
    </tokens>
    
    </xsl:template>
    
  <xsl:template match="text()">
    <xsl:analyze-string select="." regex='[\-+]?\d\.\d+\s*[eE][\-+]?\d+ |
                                                                [\-+]?\d+\.\d+                       | 
                                                                [\-+]?\d+                              |
                                                                "[^"]*?"                                ' 
                                                     flags="x">
      <xsl:matching-substring>
        <xsl:choose>
          <xsl:when test="matches(.,'[\-+]?\d\.\d+\s*[eE][\-+]?\d+')">
            <scientific><xsl:value-of select="."/></scientific>          
            </xsl:when>
          <xsl:when test="matches(.,'[\-+]?\d+\.\d+')">
            <decimal><xsl:value-of select="."/> </decimal>
          </xsl:when>
          <xsl:when test="matches(.,'[\-+]?\d+')">
            <integer><xsl:value-of select="."/> </integer>
          </xsl:when>
          <xsl:when test='matches(.," "" [^""]*? "" ", "x")'>
            <string><xsl:value-of select="."/> </string>
          </xsl:when>
      </xsl:choose>
      </xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:template>
  
  
</xsl:stylesheet>
