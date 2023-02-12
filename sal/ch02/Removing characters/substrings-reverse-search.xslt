<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes"
xmlns:ckbk="http://www.oreilly.com/catalog/xsltckbk">

<xsl:output method="text"/>
  
<xsl:template match="/">

 <xsl:if test="ckbk:substring-before-last('abc,def,gh',',') ne 'abc,def'">
    <xsl:message terminate="yes">
      <xsl:value-of select="ckbk:substring-before-last('abc,def,gh',',')"/> ne 'abc,def'
    </xsl:message>
  </xsl:if>

 <xsl:if test="ckbk:substring-before-last('abc,def,gh','') ne 'abc,def,gh'">
    <xsl:message terminate="yes">
      <xsl:value-of select="ckbk:substring-before-last('abc,def,gh','')"/> ne 'abc,def,gh'
    </xsl:message>
  </xsl:if>

 <xsl:if test="ckbk:substring-before-last('',',') ne ''">
    <xsl:message terminate="yes">
      <xsl:value-of select="ckbk:substring-before-last('',',')"/> ne ''
    </xsl:message>
  </xsl:if>

 <xsl:if test="ckbk:substring-after-last('abc,def,gh',',') ne 'gh'">
    <xsl:message terminate="yes">
      <xsl:value-of select="ckbk:substring-after-last('abc,def,gh',',')"/> ne 'gh'
    </xsl:message>
  </xsl:if>

 <xsl:if test="ckbk:substring-after-last('abc,def,gh','') ne 'abc,def,gh'">
    <xsl:message terminate="yes">
      <xsl:value-of select="ckbk:substring-after-last('abc,def,gh','')"/> ne 'abc,def,gh'
    </xsl:message>
  </xsl:if>

 <xsl:if test="ckbk:substring-after-last('',',') ne '' ">
    <xsl:message terminate="yes">
      <xsl:value-of select="ckbk:substring-after-last('',',')"/> ne ''
    </xsl:message>
  </xsl:if>

 <xsl:if test="ckbk:substring-before-last('abc.def.gh','.',true()) ne 'abc.def' ">
    <xsl:message terminate="yes">
      <xsl:value-of select="ckbk:substring-before-last2('abc.def.gh','.')"/> ne 'abc.def'
    </xsl:message>
  </xsl:if>
  
</xsl:template>


<!--Caveat: these functions won't work as expected if the substr contains unescaped regex characters -->
<xsl:function name="ckbk:substring-before-last">
	<xsl:param name="input"/>
	<xsl:param name="substr"/>
	<xsl:sequence 
       select="if ($substr) 
               then 
                  if (contains($input, $substr)) then 
                  string-join(tokenize($input, $substr)[position() ne last()],$substr) 
                  else ''
               else $input"/>
</xsl:function>

<xsl:function name="ckbk:substring-after-last">
	<xsl:param name="input"/>
	<xsl:param name="substr"/>
	<xsl:sequence 
    select="if ($substr) 
            then
               if (contains($input, $substr))
               then tokenize($input, $substr)[last()] 
               else '' 
            else $input"/>
</xsl:function>

<xsl:function name="ckbk:substring-before-last">
	<xsl:param name="input"/>
	<xsl:param name="substr"/>
	<xsl:param name="mask-regex"/>
	<xsl:variable name="matchstr" 
		        select="if ($mask-regex) 
                    then replace($substr,'([.+?*^$])','\$1')
                    else $substr"/>

	<xsl:sequence select="ckbk:substring-before-last($input,$matchstr)"/>
</xsl:function>

<xsl:function name="ckbk:substring-after-last">
	<xsl:param name="input"/>
	<xsl:param name="substr"/>
	<xsl:param name="mask-regex"/>
	<xsl:variable name="matchstr" 
		        select="if ($mask-regex) 
                           then replace($substr,'([.+?*^$])','\$1')
                           else $substr"/>

	<xsl:sequence select="ckbk:substring-after-last($input,$matchstr)"/>
</xsl:function>

</xsl:stylesheet>
