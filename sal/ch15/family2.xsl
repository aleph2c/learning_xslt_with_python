<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:my="my-recursive-functions"
  exclude-result-prefixes="my">

  <!-- Ensure we produce a nicely formatted XML output file -->
  <xsl:output method="xml" indent="yes"/>

  <!-- ============================================= -->
  <!-- The Main Template (Control Center) -->
  <!-- ============================================= -->
  <xsl:template match="/">
    <!--
      STEP 1: Call our trace function for its side-effect.
      We use xsl:sequence so the function runs, but its (non-existent)
      return value doesn't get added to the output tree.
      We start the trace on the root element (*).
    -->
    <xsl:sequence select="my:trace-node(*, 1)"/>

    <!--
      STEP 2: Now, separately, process the nodes to generate the output file.
      This call will use the identity transform template below.
    -->
    <xsl:apply-templates/>
  </xsl:template>

  <!-- ============================================= -->
  <!-- The Standard Identity Transform Template -->
  <!-- This template's only job is to create the XML output. -->
  <!-- ============================================= -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- ============================================= -->
  <!-- Here is the recursive function (unchanged). -->
  <!-- ============================================= -->
  <xsl:function name="my:trace-node">
    <xsl:param name="node" as="element()"/>
    <xsl:param name="level" as="xs:integer"/>

    <xsl:message>
      <xsl:for-each select="1 to $level">
        <xsl:text>  </xsl:text>
      </xsl:for-each>
      <xsl:text>Node: </xsl:text>
      <xsl:value-of select="$node/@name"/>
    </xsl:message>

    <xsl:for-each select="$node/*">
      <xsl:sequence select="my:trace-node(., $level + 1)"/>
    </xsl:for-each>
  </xsl:function>

</xsl:stylesheet>
