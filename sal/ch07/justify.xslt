<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xs="http://www.w3.org/2001/XMLSchema" 
xmlns:fn="http://www.w3.org/2004/10/xpath-functions" 
xmlns:text="http://www.ora.com/XSLTCookbook/namespaces/text">

 <xsl:function name="text:dup" as="xs:string">
	 <xsl:param name="input" as="xs:string"/>
	 <xsl:param name="count" as="xs:integer"/>
	 <xsl:sequence  select="string-join(for $i in 1 to $count return $input, '')"/>
 </xsl:function>

  <xsl:function name="text:justify" as="xs:string">
    <xsl:param name="value" as="xs:string"/> 
    <xsl:param name="width" as="xs:integer" />
    <xsl:sequence select="text:justify($value, $width, 'left')"/>
  </xsl:function>
  
  <xsl:function name="text:justify" as="xs:string">
    <xsl:param name="value" as="xs:string"/> 
    <xsl:param name="width" as="xs:integer" />
    <xsl:param name="align" as="xs:string" />
     
    <!-- Truncate if too long -->  
    <xsl:variable name="output" select="substring($value,1,$width)" as="xs:string"/>
    <xsl:variable name="offset" select="$width - string-length($output)" as="xs:integer"/>
    <xsl:choose>
      <xsl:when test="$align = 'left'">
        <xsl:value-of select="concat($output, text:dup(' ', $offset))"/>
      </xsl:when>
      <xsl:when test="$align = 'right'">
        <xsl:value-of select="concat(text:dup(' ', $offset), $output)"/>
      </xsl:when>
      <xsl:when test="$align = 'center'">
        <xsl:variable name="before" select="$offset idiv 2"/>
        <xsl:variable name="after" select="$before + $offset mod 2"/>
        <xsl:value-of select="concat(text:dup(' ', $before),$output,text:dup(' ', $after))"/>
      </xsl:when>
      <xsl:otherwise>INVALID ALIGN</xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
</xsl:stylesheet>