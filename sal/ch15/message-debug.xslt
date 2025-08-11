<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
  xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes"
  xmlns:debug="debug-namespace-unique-identifier"
  >

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <!--
    # to force message failure
    try -d sal/ch15 \
    ex \
    -x cars1.xml \
    -l message-debug.xslt \
    -a "debug_on='yes',foo=-1" \
    -o cars1_out.xml
    -v

    # to run without message failure
    try -d sal/ch15 \
    ex \
    -x cars1.xml \
    -l message-debug.xslt \
    -a "debug_on='yes',foo=-1" \
    -o cars1_out.xml
    -v
  -->

  <xsl:param name="debug_on" as="xs:string" select="'no'" />
  <xsl:param name="foo" as="xs:string" select="'-1'" />

  <xsl:template match="/">
    <xsl:variable name="bar" select="number($foo)"/>

    <xsl:message>
      <xsl:if test="$debug_on = 'yes'">
        <xsl:text>Debug mode is on!</xsl:text>
      </xsl:if>
    </xsl:message>

    <!--

      Terminate the program here is bar is lt 0!

      This is acts like an assert

      In XSLT +2.0, you can create a sequence by listing items separated by a
      comma, so the expression select " 'bar=', $bar " does the following:

      1) 'bar =': This is a literal string and becomes the first item in the sequence
      2) $bar: This is a reference to the $bar variable, which holds a number,
         this is the second item in the squence.
      3) The select attribute creates a sequence ('bar=', -5)
      4) xsl:message takes this sequence, and converts both parts to strings
      5) and joins them with a space between them
      6) prints this message

    -->
    <xsl:message select=" 'bar =', $bar " terminate="{ if ($bar lt 0) then 'yes' else 'no'}"/>

    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="@* | node()">

    <!--
      To call a function WITHOUT adding to the output tree, use xsl:sequence (W3C
      XSLT 3.0: "Invoke functions for side-effects like message")
    -->
    <xsl:sequence select="debug:message($debug_on, xs:integer($foo), .)" />
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:function name="debug:message" visibility="public">
    <xsl:param name="debug_on" as="xs:string" />
    <xsl:param name="foo" as="xs:integer" />
    <xsl:param name="current_node" as="node()?" />

    <xsl:message>
      <xsl:if test="$debug_on = 'yes'">
        <xsl:for-each select="$current_node"> <!-- Switch context to passed node -->
          <xsl:choose>
            <xsl:when test="self::attribute()">
              <xsl:text>Attribute: </xsl:text>
              <xsl:value-of select="name()" />
              <xsl:text> = </xsl:text>
              <xsl:value-of select="." />
            </xsl:when>
            <xsl:when test="self::*">
              <xsl:text>Element: </xsl:text>
              <xsl:value-of select="name()" />
              <xsl:text> = </xsl:text>
              <xsl:value-of select="." />
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>Other node type: </xsl:text>
              <xsl:value-of select="name()" />
              <xsl:text> = </xsl:text>
              <xsl:value-of select="." />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:if>
  </xsl:message>

</xsl:function>
</xsl:stylesheet>
