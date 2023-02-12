<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/02/xpath-functions" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes">

<!-- By default, copy the SVG to the output -->
<xsl:import href="../ch08/copy.xslt"/>
      
<!-- The data file names is pased as a paramter -->
<xsl:param name="data-file"/>
   
<!--We define the output type  be an SVG file and reference the SVG DTD -->
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" 
  doctype-public="-//W3C//DTD SVG 1.0/EN"
  doctype-system="http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd"/>
   
<!-- We load all the data values into a node set variable for -->     
<!-- easy access -->
<xsl:variable name="bar-values" select="document($data-file)/*/*/sales" as="xs:double*"/>
   
<!-- We load all the data names of each bar into a node set variable for easy access 
-->     
<xsl:variable name="bar-names" select="document($data-file)/*/*/@name" as="xs:string*"/>
   
<!--We find the max data value -->
<xsl:variable name="max-data" select="max($bar-values)" as="xs:double"/>
   
<!-- For purely aethetic reason we scale the graph so the maxium value -->
<!-- that can be plotted is 10% greater than the true data maximum. -->
<xsl:variable name="max-bar" select="$max-data + $max-data div 10" as="xs:double"/>
   
<!-- Since we gave each component of the graph a named group, -->
<!-- we can easily structure the stylesheet to match each -->
<!-- group and perform the appropriate transformation. -->
   
<!-- We copy the scale group and replace the text values with values -->
<!-- that refelect the range of our data. We use the numeric part -->
<!-- of each id to create the correct multiple of 0.25 -->
   
<xsl:template match="g[@id='scale']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:for-each select="text">
      <xsl:copy>
      <xsl:copy-of select="@*"/>
            <xsl:variable name="factor" 
            select="number(substring-after(@id,'scale')) * 0.25" as="xs:double"/>
            <xsl:value-of select="$factor * $max-bar"/>
        </xsl:copy>
    </xsl:for-each>
  </xsl:copy>
</xsl:template>
   
<!--For the key component we simply replace the text values -->
<xsl:template match="g[@id='key']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates select="rect"/>
    <xsl:for-each select="text">
    <xsl:variable name="pos" select="position( )" as="xs:integer"/>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="$bar-names[$pos]"/>
    </xsl:copy>      
    </xsl:for-each>
  </xsl:copy>
</xsl:template>
   
<!--We replace the title with a description extracted from the data.  -->
<!--We might also have allowed the title to be passed in as a parameter-->
<xsl:template match="g[@id='title']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:for-each select="text">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:value-of select="document($data-file)/*/@description"/>
      </xsl:copy>
    </xsl:for-each>
  </xsl:copy>
</xsl:template>
   
<!-- The bars are created by -->
<!-- 1) replacing the transform attribute with one that scales based on the value of 
$max-bar -->
<!-- 2) Loads the data value into the height of the bar -->
<xsl:template match="g[@id='bars']">
<xsl:copy>
  <xsl:copy-of select="@id"/>
  <xsl:attribute name="transform" select="concat('translate(60 479) scale(1 ', 
    string(-430 div $max-bar),')')"/>
  <xsl:for-each select="rect">
    <xsl:variable name="pos" select="position()"/>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="height" select="$bar-values[$pos]"/>
    </xsl:copy>
  </xsl:for-each>
 </xsl:copy>
</xsl:template>














</xsl:stylesheet>
