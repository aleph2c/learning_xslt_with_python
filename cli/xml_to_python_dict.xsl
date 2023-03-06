<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:array="http://www.w3.org/2005/xpath-functions/array"
  xmlns:lfn="http://127.0.0.1/local/functions"
  xmlns:private-lfn="http://127.0.0.1/private/local/functions"
  xmlns:exclude-result-prefixes="lfn private-lfn"
>

<xsl:output method="text" encoding="UTF-8" version="1.0" indent="no" />

<!--
  xslt
  -d ./ooda/migrations/stylesheets
  convert
  -x xml5.xml \
  -l xml_to_python_dict.xsl \
  -a indent='    '" \
  -o python_prototype5.py
  -v
-->
<xsl:param name="indent" select=" '    ' " />

<xsl:strip-space elements="*" />
<!--
# XSLT 3.0
# shallow-skip: causes all node that are not matched (including text nodes)
#               to be skipped
# fail:         treats a no-match as an error
# true:         results in a warning
-->
<xsl:mode on-no-match="shallow-skip" />
<xsl:import href="./string.replace.xsl" />
<xsl:import href="./string.dup.xsl" />

<xsl:template match="/">
  <xsl:call-template name="pre-dict-python">
  </xsl:call-template>
  <xsl:variable name="var-name" select="*[1]/name()" />
  <xsl:value-of select="$var-name" />
  <xsl:text> = </xsl:text>
  <xsl:text>{</xsl:text>
  <xsl:text>&#xA;</xsl:text>
  <xsl:apply-templates />
  <xsl:text>}</xsl:text>
  <xsl:text>&#xA;</xsl:text>
  <xsl:call-template name="post-dict-python">
    <xsl:with-param name="var-name" select="$var-name" />
  </xsl:call-template>
</xsl:template>

<xsl:template name="pre-dict-python">
  <xsl:text>import pprint</xsl:text>
  <xsl:text>&#xA;</xsl:text>
  <xsl:text>def pp(item):</xsl:text>
  <xsl:text>&#xA;</xsl:text>
  <xsl:call-template name="string-dup" >
    <xsl:with-param name="input" select="$indent" />
    <xsl:with-param name="count" select="1"/>
  </xsl:call-template>
  <xsl:text>pprint.pprint(item)</xsl:text>
  <xsl:text>&#xA;</xsl:text>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="post-dict-python">
  <xsl:param name="var-name" />
  <xsl:text>&#xA;</xsl:text>
  <xsl:text>if __name__ == '__main__':</xsl:text>
  <xsl:text>&#xA;</xsl:text>
  <xsl:call-template name="string-dup" >
    <xsl:with-param name="input" select="$indent" />
    <xsl:with-param name="count" select="1"/>
  </xsl:call-template>
  <xsl:text>pp(</xsl:text>
  <xsl:value-of select="$var-name" />
  <xsl:text>)</xsl:text>
</xsl:template>


<xsl:template match="*">
  <xsl:variable name="level" select="count(./ancestor::*) + 1"/>
  <xsl:call-template name="string-dup" >
    <xsl:with-param name="input" select="$indent" />
    <xsl:with-param name="count" select="$level"/>
  </xsl:call-template>
  <xsl:text>"</xsl:text>
  <xsl:value-of select="local-name()" />
  <xsl:text>": {</xsl:text>

  <xsl:text>&#xA;</xsl:text>
  <xsl:apply-templates select="@*" >
    <xsl:with-param name="input" select="$indent" />
    <xsl:with-param name="level" select="$level+1"/>
  </xsl:apply-templates>

  <xsl:apply-templates/>

  <xsl:call-template name="string-dup" >
    <xsl:with-param name="input" select="$indent" />
    <xsl:with-param name="count" select="$level"/>
  </xsl:call-template>
  <xsl:choose>
    <xsl:when test="$level gt 0">
      <xsl:text>},</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>}</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="@*">
  <xsl:param name="input" />
  <xsl:param name="level" />
  <xsl:call-template name="string-dup" >
    <xsl:with-param name="input" select="$indent" />
    <xsl:with-param name="count" select="$level"/>
  </xsl:call-template>
  <xsl:text>"@</xsl:text>
  <xsl:value-of select="normalize-space(./local-name())" />
  <xsl:text>" :</xsl:text> 
  <xsl:text>"</xsl:text>
  <xsl:value-of select="." />
  <xsl:text>"</xsl:text>
  <xsl:text>,</xsl:text>
  <!--
  <xsl:if test="position() ne last()">
    <xsl:text>, </xsl:text>
    </xsl:if>
  -->
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

</xsl:stylesheet>
