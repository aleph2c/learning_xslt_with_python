<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:lfn="http://127.0.0.1/localfunctions"
  xmlns:private-lfn="http://127.0.0.1/privatelocalfunctions"
  xmlns:exclude-result-prefixes="lfn private-lfn"
>

<xsl:output method="text" encoding="UTF-8" />
<xsl:strip-space elements="*" />

<xsl:mode on-no-match="shallow-skip" />

<xsl:template match="/">
  <xsl:variable name="search-path">
    <xsl:apply-templates select="//meta/@selection" />
  </xsl:variable>
  <xsl:apply-templates>
    <xsl:with-param name="search-path" select="$search-path" />
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="meta/@selection">
  <xsl:value-of select="." />
</xsl:template>

<xsl:template match="*">
  <xsl:param name="search-path" />

  <xsl:apply-templates>
    <xsl:with-param name="search-path" select="$search-path"/>
  </xsl:apply-templates>

</xsl:template>

<xsl:template match="item">
  <xsl:param name="search-path"/>

  <xsl:variable name="ancestors" select="ancestor-or-self::*" />

  <xsl:variable
    name="result"
    select="lfn:process-and-evaluate(
    $search-path,
    $ancestors)"
  />

  <xsl:if test="$result">
    <xsl:value-of select="$result" />
  </xsl:if>

  <xsl:apply-templates >
    <xsl:with-param name="search-path" select="$search-path"/>
  </xsl:apply-templates>

</xsl:template>

<xsl:function name="lfn:process-and-evaluate" as="xs:boolean">
  <xsl:param name="search-path" />
  <xsl:param name="ancestors" />
  <xsl:variable
    name="reversed-search-tokens"
    select="lfn:search-path-tokenized-and-reverse($search-path)"
  />

  <xsl:sequence select="private-lfn:process-and-evaluate(
    $reversed-search-tokens,
    $ancestors,
    1)"
  />
</xsl:function>

<xsl:function name="private-lfn:process-and-evaluate" as="xs:boolean">
  <xsl:param name="reversed-search-tokens" />
  <xsl:param name="ancestors" />
  <xsl:param name="index" />

  <xsl:variable
    name="search-token"
    select="$reversed-search-tokens[$index]"
  />
  <xsl:variable
      name="node-name"
      select="lfn:create-name-for-search-item($search-token)" />

  <xsl:variable
    name="attr-name"
    select="lfn:create-attr-name-for-search-item($search-token)"
  />

  <xsl:variable
    name="attr-value"
    select="lfn:create-attr-value-for-search-item($search-token)"
  />

  <xsl:variable name="this-test" select="
    private-lfn:validate(
      reverse($ancestors)[$index]/name(),
      reverse($ancestors)[$index]/@*/name(),
      reverse($ancestors)[$index]/@*/.,
      $node-name,
      $attr-name,
      $attr-value)"
  />

  <xsl:choose>
    <xsl:when test="count($reversed-search-tokens) = $index">
      <xsl:sequence select="$this-test" />
    </xsl:when>
    <xsl:when test="not($this-test)">
      <xsl:sequence select="false()" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="
        private-lfn:process-and-evaluate(
        $reversed-search-tokens,
        $ancestors,
        $index+1)"
    />
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>


<xsl:function name="private-lfn:validate" as="xs:boolean">
  <xsl:param name="path-name" />
  <xsl:param name="path-attr-name" />
  <xsl:param name="path-attr-value" />
  <xsl:param name="search-name" />
  <xsl:param name="search-attr-name" />
  <xsl:param name="search-attr-value" />

  <xsl:choose>
    <xsl:when test="
      $path-name = $search-name and
      $path-attr-name = $search-attr-name and
      $path-attr-value = $search-attr-value"
    >
      <xsl:sequence select="true()" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="false()" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="lfn:create-name-for-search-item" as="xs:string*">
  <xsl:param name="item" />
  <xsl:variable
    name="node_name"
    select="lfn:match($item, '(\w+)\[.+')"
  />
  <xsl:sequence select="$node_name" />
</xsl:function>

<xsl:function name="lfn:create-attr-name-for-search-item" as="xs:string*">
  <xsl:param name="item" />
  <xsl:variable
    name="attr_name"
    select="lfn:match($item, '@(\w+)=')"
  />
  <xsl:sequence select="$attr_name" />
</xsl:function>

<xsl:function name="lfn:create-attr-value-for-search-item" as="xs:string*">
  <xsl:param name="item" />
  <xsl:variable
    name="attr_value"
    select="lfn:match($item, '=.(.+).\]')"
  />
  <xsl:sequence select="$attr_value" />
</xsl:function>

<xsl:function name="lfn:search-path-tokenized-and-reverse" >
  <xsl:param name="search-pattern" as="xs:string" />
  <xsl:variable name="_search-path" select="replace($search-pattern, '//', '')"/>
  <xsl:sequence select="reverse(tokenize($_search-path, '/'))" />
</xsl:function>

<xsl:function name="lfn:match">
  <xsl:param name="item" />
  <xsl:param name="pattern" />
  <xsl:try>
    <xsl:variable name="result" as="xs:string">
      <xsl:analyze-string select="$item" regex="{$pattern}" >
        <xsl:matching-substring>
          <xsl:value-of select="regex-group(1)" />
        </xsl:matching-substring>
        <xsl:non-matching-substring>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </xsl:variable>
    <xsl:sequence select="$result" />
    <xsl:catch>
      <xsl:variable name="empty" ></xsl:variable>
      <xsl:sequence select="$empty" />
    </xsl:catch>
  </xsl:try>
</xsl:function>
</xsl:stylesheet>
