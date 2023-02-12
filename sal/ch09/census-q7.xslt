<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xs="http://www.w3.org/2001/XMLSchema" 
xmlns:fn="http://www.w3.org/2005/02/xpath-functions" 
xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes"
xmlns:ckbk="http://www.ora.com/XSLTCkbk">

	<xsl:key name="person-key" match="person" use="@name"/>
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<!-- Question 7. List the names of all Joe's descendants. Show each descendant as an element with the descendant's name as content and his or her marital status and number of children as attributes. Sort the descendants in descending order by number of children and secondarily in alphabetical order by name: --> 

<xsl:variable name="everyone" select="//person" as="item()*"/>
   
<xsl:template match="census">
  <result>
    <xsl:apply-templates select="//person[@name='Joe']"/>
  </result>
</xsl:template>
   
<xsl:template match="person">
    
  <xsl:for-each select="ckbk:descendants(.,/)[current() != .]">
    <xsl:sort select="count(./* | $everyone[@name = current()/@spouse]/*)" 
    order="descending" data-type="number"/>
    <xsl:sort select="@name"/>
    <xsl:variable name="mstatus" select="if (@spouse) then 'Yes'   else 'No'"/>
    <person married="{$mstatus}" 
          nkids="{count(./* | key('person-key', @spouse)/*)}">
          <xsl:value-of select="@name"/>
     </person> 
  </xsl:for-each>
</xsl:template>
   
<xsl:function  name="ckbk:descendants">
  <xsl:param name="nodes" as="item()*"/>
  <xsl:param name="doc"/>
  <xsl:sequence select="$nodes, for $person in $nodes return ckbk:descendants( ($person/person, key('person-key', $person/@spouse,$doc)/person), $doc)"/>
</xsl:function>


</xsl:stylesheet>
