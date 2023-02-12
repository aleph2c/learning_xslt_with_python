<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes">

<xsl:output method="text"/>
  
  
<xsl:template match="/">
  <xsl:variable name="input" 
       select=" '---this --is-- the way we normalize non-whitespace---' "/>
 <xsl:value-of select="replace(replace($input,'-+','-'),'^-+|-+$','')"/>
</xsl:template>

</xsl:stylesheet>
