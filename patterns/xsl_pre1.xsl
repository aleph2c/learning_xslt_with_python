<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:out="temp"
>
  <xsl:output method="xml" encoding="UTF-8" version="1.0" indent="yes" />
  <xsl:namespace-alias stylesheet-prefix="out" result-prefix="xsl" />
  <!--
    try
    -d pattens /
      ex \
        -x xml1.xml \
        -l xsl_pre1.xsl \
        -o xsl_post1.xsl \
        -v
  -->
  <xsl:strip-space elements="*" />

  <xsl:mode on-no-match="fail" />

  <xsl:template match="/">
    <xsl:variable name="_query" select='//meta/@selection' />
    <xsl:call-template name="create-xsl-post">
      <xsl:with-param name="query" select="$_query" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="create-xsl-post">
    <xsl:param name="query" />

    <out:stylesheet version="3.0">
      <out:output method="text" encoding="UTF-8" />
      <xsl:comment> try \
        -d patterns \
        ex \
        -x xml1.xml  \
        -l xsl_post1.xml \
        -o out1.txt
        -v </xsl:comment>
      <out:strip-space elements="*" />
      <out:mode on-no-match="shallow-skip" />

      <out:template match="/">
        <out:apply-templates select="{$query}" />
      </out:template>

      <out:template match="{$query}">
        <out:variable name="level" select="count(./ancestor::*)" />
        <out:for-each select="1 to $level">
          <out:text>&#xA0;</out:text>
        </out:for-each>
        <out:value-of select="." />
        <out:text>&#xA;</out:text>
      </out:template>
    </out:stylesheet>
  </xsl:template>
</xsl:stylesheet>
