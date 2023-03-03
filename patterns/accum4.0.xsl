<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
     xmlns:xs="http://www.w3.org/2001/XMLSchema" 
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     exclude-result-prefixes="#all">

   <xsl:accumulator name="figNum" as="xs:integer" initial-value="0">
      <xsl:accumulator-rule match="chapter" select="0"/>
      <xsl:accumulator-rule match="figure" select="$value+1"/>
   </xsl:accumulator>

   <xsl:mode use-accumulators="figNum"/>

   <xsl:template match="chapter">
     <xsl:apply-templates/>
     <p>Figures <xsl:value-of select="accumulator-after('figNum')" />
     </p>
   </xsl:template>

</xsl:stylesheet>
