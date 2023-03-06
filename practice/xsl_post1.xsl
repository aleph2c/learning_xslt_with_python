<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 version="3.0">
   <xsl:output method="text" encoding="UTF-8"/>
   <!-- try \
        -d patterns \
        ex \
        -x xml1.xml  \
        -l xsl_post1.xml \
        -o out1.txt
        -v -->
   <xsl:strip-space elements="*"/>
   <xsl:mode on-no-match="shallow-skip"/>
   <xsl:template match="/">
      <xsl:apply-templates select="//item[@Young]/item[@Rex]"/>
   </xsl:template>
   <xsl:template match="//item[@Young]/item[@Rex]">
      <xsl:variable name="level" select="count(./ancestor::*)"/>
      <xsl:for-each select="1 to $level">
         <xsl:text> </xsl:text>
      </xsl:for-each>
      <xsl:value-of select="."/>
      <xsl:text/>
   </xsl:template>
</xsl:stylesheet>
