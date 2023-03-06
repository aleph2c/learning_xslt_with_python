<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
     xmlns:xs="http://www.w3.org/2001/XMLSchema" 
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     expand-text="yes"
     exclude-result-prefixes="#all">

   <xsl:accumulator name="chapterNum" as="xs:integer" initial-value="0">
      <xsl:accumulator-rule match="chapter" select="$value+1"/>
   </xsl:accumulator>

   <xsl:accumulator name="figNum" as="xs:integer" initial-value="0">
      <xsl:accumulator-rule match="chapter" select="0"/>
      <xsl:accumulator-rule match="figure" select="$value+1"/>
   </xsl:accumulator>

   <xsl:mode on-no-match="shallow-copy" use-accumulators="#all"/>

   <xsl:template match="figure ">
     <xsl:comment>{local-name()} {accumulator-before('figNum')} in
        {local-name(..)} {accumulator-before('chapterNum')}</xsl:comment>
     <xsl:next-match/>
   </xsl:template> 

   <xsl:template match="chapter">
     <xsl:comment>{local-name()} {accumulator-before('chapterNum')}</xsl:comment>
     <xsl:next-match/>
     <p>Figures in {local-name()} {accumulator-before('chapterNum')}: {accumulator-after('figNum')}</p>
   </xsl:template> 

   <xsl:output indent="yes"/>

</xsl:stylesheet>
