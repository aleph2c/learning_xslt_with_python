<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:array="http://www.w3.org/2005/xpath-functions/array"
  xmlns:lfn="http://127.0.0.1/localfunctions"
  xmlns:private-lfn="http://127.0.0.1/privatelocalfunctions"
  xmlns:exclude-result-prefixes="lfn private-lfn"
>

<xsl:output method="text" encoding="UTF-8" />
<xsl:strip-space elements="*" />

<xsl:accumulator name="test-pass" as="xs:integer" initial-value="0">
  <xsl:accumulator-rule phase="start" select="0" />
  <xsl:accumulator-rule phase="end" select="$value" />
  <xsl:accumulator-rule phase="tests" select="$value + 1" />
</xsl:accumulator>

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
  <xsl:apply-templates select="//item[@name='Young']/item[@name='Rex']" >
    <xsl:with-param name="search-path" select="$search-path"/>
  </xsl:apply-templates>

  <!--
  <xsl:evaluate xpath="$search-path" context-item="$actual-path" />

  <xsl:value-of select="tokenize($search-path, '/')" />

  <xsl:apply-templates>
    <xsl:with-param name="search-path" select="$search-path" />
    </xsl:apply-templates>
  -->
  </xsl:template>

  <xsl:template match="item">
    <xsl:param name="search-path"/>
    <xsl:if test="@* = 'Rex'">
      <!-- pull this out later -->
      <!--
        <xsl:variable name="search-path">//item[@name='Young']/item[@name='Rex']</xsl:variable>
      -->
      <!--
        <xsl:variable name="search-path">item/item[@name='Rex']</xsl:variable>
      <xsl:variable name="search-path">item/item[@name='Rex']</xsl:variable>
      -->

      <xsl:variable
        name="reversed-search-tokens"
        select="lfn:search-path-tokenized-and-reverse($search-path)"
      />
      <xsl:variable name="ancestors" select="ancestor-or-self::*" />
      <!-- range(1, lfn:items-in-search-path($search-path)+1)" -->
      <xsl:variable name="indexes" as="xs:integer*">
        <xsl:for-each select="1 to lfn:items-in-search-path($search-path)">
            <xsl:sequence select="." />
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable
        name="tests"
        as="array(xs:integer)"
        select="array{1 to count($indexes)}" />

      <xsl:for-each select="1 to count($indexes)">
        <xsl:variable name="index" select="." />

        <!-- search token -->
        <xsl:variable
          name="search-token"
          select="$reversed-search-tokens[$index]"
        />
        <xsl:value-of select="$search-token" />
        <xsl:text>&#xA;|</xsl:text>
        <xsl:value-of select="reverse($ancestors)[$index]/name()" />
        <xsl:value-of select="reverse($ancestors)[$index]/@*/name()" />
        <xsl:value-of select="reverse($ancestors)[$index]/@*/." />
        <xsl:text>|&#xA;</xsl:text>

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

        <xsl:text>&#xA;|</xsl:text>
        <xsl:value-of select="$node-name" />
        <xsl:value-of select="$attr-name" />
        <xsl:value-of select="$attr-value" />
        <xsl:text>|&#xA;</xsl:text>

        <xsl:variable name="result-ex"
        select="reverse($ancestors)[$index]/name() = $node-name"
        />
        <xsl:value-of select="$result-ex" />
        <xsl:variable name="test-result" select="
          lfn:validate(
            reverse($ancestors)[$index]/name(),
            reverse($ancestors)[$index]/@*/name(),
            reverse($ancestors)[$index]/@*/.,
            $node-name,
            $attr-name,
            $attr-value)"
        />
        <xsl:value-of select="$test-result" />
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

<xsl:function name="lfn:validate" as="xs:integer">
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
      <xsl:sequence select="1" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="0" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="lfn:append">
  <xsl:param name="seq" />
  <xsl:param name="item" />
  <xsl:sequence select="insert-before($seq, count($seq)+1, $item)" />
</xsl:function>

<xsl:function name="lfn:generate-x-path" >
  <xsl:param name="p-node" />
  <xsl:for-each select="$p-node/ancestor::*">
    <xsl:value-of select="name()" />
    <xsl:text>/</xsl:text>
  </xsl:for-each>
  <xsl:value-of select="name($p-node)" />
</xsl:function>

<xsl:function name="lfn:reverse-ancestors" as="node()*">
  <xsl:param name="ancestors" as="node()*" />
</xsl:function>

<!-- working -->
<xsl:function name="lfn:create-name-for-search-item" as="xs:string*">
  <xsl:param name="item" />
  <xsl:variable
    name="node_name"
    select="lfn:match($item, '(\w+)\[.+')"
  />
  <xsl:sequence select="$node_name" />
</xsl:function>

<!-- not tested -->
<xsl:function name="lfn:create-attr-name-for-search-item" as="xs:string*">
  <xsl:param name="item" />
  <xsl:variable
    name="attr_name"
    select="lfn:match($item, '@(\w+)=')"
  />
  <xsl:sequence select="$attr_name" />
</xsl:function>

<!-- not tested -->
<xsl:function name="lfn:create-attr-value-for-search-item" as="xs:string*">
  <xsl:param name="item" />
  <xsl:variable
    name="attr_value"
    select="lfn:match($item, '=.(.+).\]')"
  />
  <xsl:sequence select="$attr_value" />
</xsl:function>

<!-- not tested -->
<xsl:function name="lfn:items-in-search-path" as="xs:integer">
  <xsl:param name="search-path"></xsl:param>
  <xsl:sequence select="replace($search-path, '//', '') => tokenize('/') => count()" />
</xsl:function>

<!-- works -->
<xsl:function name="lfn:search-path-tokenized-and-reverse" >
  <xsl:param name="search-pattern" as="xs:string" />
  <xsl:variable name="_search-path" select="replace($search-pattern, '//', '')"/>
  <xsl:sequence select="reverse(tokenize($_search-path, '/'))" />
</xsl:function>

<!-- it seems that without the as="xs:string" this function squishes
     the results into one string -->
<xsl:function name="lfn:create-node-for-search-item" as="xs:string*">
  <xsl:param name="item" />
  <!--
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$item" />
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&#xA;</xsl:text>
  -->
  <xsl:variable
    name="node_name"
    select="lfn:match($item, '(\w+)\[.+')"
  />
  <xsl:variable
    name="attr_name"
    select="lfn:match($item, '@(\w+)=')"
  />
  <xsl:variable
    name="attr_value"
    select="lfn:match($item, '=.(.+).\]')"
  />
  <!--
    <xsl:variable name="result" select="$node_name, $attr_name, $attr_value" />
  -->
  <xsl:sequence select="$node_name, $attr_name, $attr_value" />
</xsl:function>

<xsl:function name="lfn:match">
  <xsl:param name="item" />
  <xsl:param name="pattern" />
  <!--
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$pattern" />
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&#xA;</xsl:text>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$item" />
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&#xA;</xsl:text>

  -->
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
