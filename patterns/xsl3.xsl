<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:lfn="http://127.0.0.1/localfunctions"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:private-lfn="http://127.0.0.1/privatelocalfunctions"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exclude-result-prefixes="lfn private-lfn"
>

<xsl:output method="text" encoding="UTF-8" />
<xsl:strip-space elements="*" />
<xsl:mode on-no-match="shallow-skip" />

<xsl:template match="/">
  <xsl:variable name="search-path">
    <xsl:apply-templates select="//meta/@selection" />
  </xsl:variable>
  <xsl:value-of select="$search-path" />
  <xsl:apply-templates>
    <xsl:with-param name="search-path" select="$search-path" />
  </xsl:apply-templates>
</xsl:template>

<!--
<xsl:template name="apply-match">
  <xsl:param name="search-path" />
  <xsl:param name="actual-path" />
  <xsl:value-of select="lfn:example($search-path, $actual-path)" />
  </xsl:template>
-->

<xsl:template match="meta/@selection">
  <xsl:value-of select="." />
</xsl:template>

<xsl:template match="*">
  <xsl:param name="search-path" />
  <xsl:text>&#xA;</xsl:text>
  <xsl:variable name="actual-path" select="ancestor::*/element()"/>

  <xsl:apply-templates select="//item[@name='Young']/item[@name='Rex']" />

  <!--
  <xsl:evaluate xpath="$search-path" context-item="$actual-path" />

  <xsl:value-of select="tokenize($search-path, '/')" />

  <xsl:apply-templates>
    <xsl:with-param name="search-path" select="$search-path" />
    </xsl:apply-templates>
  -->
  </xsl:template>

  <xsl:template match="item">
    <xsl:if test="@* = 'Rex'">
      <xsl:text>hey</xsl:text>
      <xsl:text>&#xA;</xsl:text>

      <xsl:variable name="search-path">//item[@name='Young']/item[@name='Rex']</xsl:variable>
      <xsl:variable
        name="reverse-tokens"
        select="$search-path => tokenize('/') => reverse()"
      />
      <xsl:variable
        name="reverse-actual-path"
        select="ancestor::*/element() => reverse()"
      />
      <xsl:for-each select="1 to count($reverse-tokens)">
        <xsl:variable name="i" select='number(.)' />
        <xsl:if test="string-length($reverse-tokens[$i]) gt 0">
          <xsl:analyze-string select="$reverse-tokens[$i]" regex="\[(.+)\]" >
            <xsl:matching-substring>
              <xsl:text>|</xsl:text>
              <xsl:value-of select="regex-group(1)" />
              <xsl:text>|</xsl:text>
              <xsl:text>&#xA;</xsl:text>
              <xsl:variable name="temp" select="." />
            </xsl:matching-substring>
            <xsl:non-matching-substring>
              <xsl:variable name="temp" select="." />
            </xsl:non-matching-substring>
          </xsl:analyze-string>
        </xsl:if>
      </xsl:for-each>

      <xsl:value-of select="$reverse-actual-path" />
      <xsl:text>&#xA;</xsl:text>
      <xsl:value-of select="$reverse-tokens" />
    </xsl:if>
  </xsl:template>

<xsl:function name="lfn:tokenize-reverse-search" >
  <xsl:param name="search-pattern">
  <xsl:variable
    name="tokenized-reverse-search"
    select="$search-pattern => tokenize('/') => reverse()"
  />
  <xsl:value-of select="$tokenized-reverse-search" />
</xsl:function>

<xsl:function name="lfn:reverse-ancestors">
  <xsl:param name="$ancestors" />
  <xsl:variable
    name="reversed-ancestors"
    select="$ancestors => reverse()"
  />
  <xsl:value-of select="$reversed-ancestors" />
</xsl:function>

<xsl:function name="lfn:create-node-for-search-item">
  <xsl:param name="$item" />
  <xsl:variable
    name="node_name"
    select="lfn:match($item, '(.+)\[')"
  />
  <xsl:variable
    name="attr_name"
    select="lfn:match($item, '\[@(.+)=')"
  />
  <xsl:variable
    name="attr_value"
    select="lfn:match($item, '=(.+)')"
  />


</xsl:function>

<xsl:function name="lfn:match">
  <xsl:param name="item" />
  <xsl:param name="pattern" />
  <xsl:analyze-string select="$item" regex="$pattern" >
    <xsl:matching-substring>
      <xsl:variable
        name="result"
        select="regex-group(1)"
      />
    </xsl:matching-substring>
    <xsl:non-matching-substring>
      <xsl:variable name="result"></xsl:variable>
    </xsl:non-matching-substring>
  </xsl:analyze-string>
  <xsl:value-of select="$result" />
</xsl:function>

<xsl:function name="lfn:create-reversed-search-nodes" >
  <xsl:param name="search-pattern">
  <xsl:variable name="reverse-search-sequenc">
    <xsl:value-of select="lfn:tokenize-reverse-search($search-pattern)" />
  </xsl:variable>
</xsl:function>

<xsl:function name="lfn:compare-ancestors-to-search-pattern">
  <xsl:param name="ancestors" />
  <xsl:param name="search-pattern" />
  <xsl:variable name="reverse-search-nodes">
    <xsl:value-of select="lfn:create-reversed-search-nodes($search-pattern)" />
  </xsl:variable>
  <xsl:variable name="reversed-ancestor-nodes">
    <xsl:value-of select="lfn:reverse-ancestors($ancestors)" />
  </xsl:variable>
</xsl:function>


</xsl:stylesheet>
