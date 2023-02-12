<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xs="http://www.w3.org/2001/XMLSchema" 
xmlns:fn="http://www.w3.org/2005/02/xpath-functions" 
xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes"
xmlns:vset="http:/www.ora.com/XSLTCookbook/namespaces/vset" exclude-result-prefixes="xs fn xdt vset">

<xsl:import href="vset.xslt"/>

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	   
<xsl:template match="/">
<people>
  <people-union>
	 <xsl:sequence select="vset:union(//person, doc('people2.xml')//person)"/>
   </people-union>
  <people-intersect>
	 <xsl:sequence select="vset:intersection(//person, doc('people2.xml')//person)"/>
   </people-intersect>
  <people-diff1>
	 <xsl:sequence select="vset:difference(//person, doc('people2.xml')//person)"/>
   </people-diff1>
  <people-diff2>
	 <xsl:sequence select="vset:difference(doc('people2.xml')//person,//person)"/>
   </people-diff2>
   </people>
</xsl:template>
   
<!--Define person equality as having the same name -->
<xsl:function name="vset:element-equality" as="xs:boolean">
  <xsl:param name="item1" as="element(person,item)"/>
  <xsl:param name="item2" as="element(person,item)"/>
  <xsl:sequence select="$item1/@name eq $item2/@name"/>
</xsl:function>

</xsl:stylesheet>
