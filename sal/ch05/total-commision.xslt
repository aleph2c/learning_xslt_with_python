<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                xmlns:fn="http://www.w3.org/2004/10/xpath-functions" 
                xmlns:ckbk="http://www.oreilly.com/catalog/xsltckbk">

<xsl:output method="text"/>
   
<xsl:template match="salesBySalesperson">
  <xsl:text>Total commision = </xsl:text>
  <xsl:value-of select="ckbk:total-commision(*)"/>
</xsl:template>
   
<!-- By default salespeople get 2% commsison and no base salary -->
<xsl:template match="salesperson" mode="commision" as="xs:double">
  <xsl:sequence select="0.02 * sum(product/@totalSales)"/>
</xsl:template>
   
<!-- salespeople with seniority > 4 get $10000.00 base + 0.5% commsison -->
<xsl:template match="salesperson[@seniority > 4]" mode="commision" priority="1" as="xs:double">
  <xsl:sequence select="10000.00 + 0.05 * sum(product/@totalSales)"/>
</xsl:template>
   
<!-- salespeople with seniority > 8 get (seniority * $2000.00) base + 0.8% commsison -->
<xsl:template match="salesperson[@seniority > 8]" mode="commision" priority="2" as="xs:double">
  <xsl:sequence select="@seniority * 2000.00 + 0.08 * 
          sum(product/@totalSales)"/>
</xsl:template>
     
<xsl:function name="ckbk:total-commision" as="xs:double">
  <xsl:param name="salespeople" as="node()*"/>
  <xsl:sequence select="sum(for $s in $salespeople return ckbk:commision($s))"/>
</xsl:function>
   
<xsl:function name="ckbk:commision" as="xs:double">
  <xsl:param name="salesperson" as="node()"/>
  <xsl:apply-templates select="$salesperson" mode="commision"/>
</xsl:function>

 
</xsl:stylesheet>
