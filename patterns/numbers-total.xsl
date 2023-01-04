<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:f="local-functions.uri"
  exclude-result-prefixes="xs f"
  version="3.0">

  <!--
    Create a $number-as-xml document-node variable:

    The input is <number>1 2 3 ... </number>

    We change this to:
    <document>
      <number>1</number>
      <number>2</number>
      <number>3</number>
      <number>...</number>
    </document>

    And assign it to $number-as-xml
  -->
  <xsl:variable name="numbers-as-xml" as="document-node()">
    <xsl:call-template name="string-numbers-to-double">
      <xsl:with-param name="numbers-as-string-seq" select="tokenize(/numbers, '\s')" />
    </xsl:call-template>
  </xsl:variable>
  <xsl:template name="string-numbers-to-double">
    <xsl:param name="numbers-as-string-seq" as="xs:string*" />
    <xsl:document>
      <xsl:for-each select="$numbers-as-string-seq">
        <!-- number() converts an arg into a xs:double -->
        <number><xsl:value-of select="number(.)" /></number>
      </xsl:for-each>
    </xsl:document>
  </xsl:template>

  <!--
    This matches the root and performs that transform
  -->
  <xsl:template match="/">
    <xsl:variable name="numbers" select="$numbers-as-xml/number" />
    <xsl:text>
</xsl:text>
    <total values="{f:total-numbers($numbers, 0)}"/>
  </xsl:template>

  <!--
    Accepts a sequence of numbers and returns an accumulated sum
    12 34.5 18.2 5 -> 12 46.5 64.7 69.7
  -->
  <xsl:function name="f:total-numbers" as="xs:decimal*">
    <xsl:param name="input" as="xs:decimal*"/>
    <xsl:param name="total" as="xs:decimal"/>
    <xsl:if test="exists($input)">
      <xsl:variable name="x" as="xs:decimal" select="$input[1] + $total"/>
      <xsl:sequence select="$x"/>
      <xsl:sequence select="f:total-numbers(subsequence($input,2),$x)"/>
    </xsl:if>
  </xsl:function>

</xsl:stylesheet>


