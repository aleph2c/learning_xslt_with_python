<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/10/xpath-functions" xmlns:xdt="http://www.w3.org/2004/10/xpath-datatypes">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>


  <xsl:function name="ckbk:factorial" as="xs:decimal">
     <xsl:param name="n" as="xs:integer"/>
     <xsl:sequence select="if ($n eq 0) then 1 
                           else $n * ckbk:factorial($n - 1)"/> 
  </xsl:function>


  <xsl:function name="ckbk:decodeColor" as="xs:string">
     <xsl:param name="colorCode" as="xs:integer"/>
     <xsl:variable name="colorLookup" select="('black','red','orange','yellow','green','blue','indigo','violet','white')"/>
     <xsl:sequence select="if ($colorCode ge 0 and $colorCode lt count($colorLookup)) 
                           then $colorLookup[$colorCode - 1] 
                           else 'no color'"/>
  </xsl:function>


</xsl:stylesheet>
