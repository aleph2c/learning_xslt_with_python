<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="local-functions.uri"
  xmlns:private-math="local-functions.uri"
  exclude-result-prefixes="xs math private-math"
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
    <total values="{math:sqrt-numbers($numbers)}"/>
  </xsl:template>

  <!--
    Accepts a sequence of numbers and returns the sqrt of each
    12 34.5 18.2 5 -> 3.4641 5.8737 4.2661 2.2361
  -->
  <xsl:function name="math:sqrt-numbers" as="xs:double*">
    <xsl:param name="input" as="xs:double*"/>
    <xsl:if test="exists($input)">
      <xsl:variable name="x" as="xs:double" select="math:sqrt($input[1])"/>
      <xsl:sequence select="$x"/>
      <xsl:sequence select="math:sqrt-numbers(subsequence($input,2))"/>
    </xsl:if>
  </xsl:function>

  <xsl:function name="math:sqrt" as="xs:double">
    <xsl:param name="number" as="xs:double" />
    <xsl:sequence select="math:sqrt($number, 4)" />
  </xsl:function>

  <xsl:function name="math:sqrt" as="xs:double">
    <xsl:param name="number" as="xs:double" />
    <xsl:param name="precision" as="xs:integer" />
    <xsl:sequence select="private-math:sqrt($number, $precision, 1)" />
  </xsl:function>

  <xsl:function name="private-math:sqrt" as="xs:double">
    <xsl:param name="number" as="xs:double" />
    <xsl:param name="precision" as="xs:integer" />
    <xsl:param name="estimate" as="xs:double" />
    <xsl:variable name="next_estimate" as="xs:double"
      select="$estimate + (($number - $estimate * $estimate ) div (2 * $estimate))" />
    <xsl:variable name="rounded_estimate" as="xs:double"
      select="round-half-to-even($next_estimate, $precision)" />
    <xsl:sequence select="if ($estimate = $rounded_estimate) then $estimate else
    private-math:sqrt($number, $precision, $rounded_estimate)" />
  </xsl:function>
</xsl:stylesheet>


