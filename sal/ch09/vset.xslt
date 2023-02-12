<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xs="http://www.w3.org/2001/XMLSchema" 
xmlns:fn="http://www.w3.org/2005/02/xpath-functions" 
xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes"
xmlns:vset="http:/www.ora.com/XSLTCookbook/namespaces/vset">

<!-- The default implementation of element equality. Override in the importing 
stylesheet as neccessary. -->
<xsl:function name="vset:element-equality" as="xs:boolean">
  <xsl:param name="item1" as="item()?"/>
  <xsl:param name="item2" as="item()?"/>
  <xsl:sequence select="$item1 = $item2"/>
</xsl:function>
   
<!-- The default set membership test uses element equality. You will rarely need to 
override this in the importing stylesheet. -->
<xsl:function name="vset:member-of" as="xs:boolean">
  <xsl:param name="set" as="item()*"/>
  <xsl:param name="elem" as="item()"/>
  <xsl:variable name="member-of" as="xs:boolean*" 
                       select="for $test in $set 
                                    return if (vset:element-equality($test, $elem)) 
                                               then true() else ()"/>
  <xsl:sequence select="not(empty($member-of))"/>
</xsl:function>
   
<!-- Compute the union of two sets using "by value" equality. -->
<xsl:function name="vset:union" as="item()*">
  <xsl:param name="nodes1" as="item()*"  />
  <xsl:param name="nodes2" as="item()*" />
 <xsl:sequence select="$nodes1, for $test in $nodes2 return if (vset:member-of($nodes1,$test)) then () else $test"/>  
  </xsl:function>
   
   
<!-- Compute the intersection of two sets using "by value" equality. -->
<xsl:function name="vset:intersection" as="item()*">
  <xsl:param name="nodes1" as="item()*" />
  <xsl:param name="nodes2" as="item()*" />
 <xsl:sequence select="for $test in $nodes1 return if (vset:member-of($nodes2,$test)) then $test else ()"/>  
</xsl:function>
   
<!-- Compute the differnce between two sets (node1 - nodes2) using "by value" 
equality. -->

<xsl:function name="vset:difference" as="item()*">
  <xsl:param name="nodes1" as="item()*" />
  <xsl:param name="nodes2" as="item()*" />
 <xsl:sequence select="for $test in $nodes1 return if (vset:member-of($nodes2,$test)) then () else $test"/>  
</xsl:function>


</xsl:stylesheet>
