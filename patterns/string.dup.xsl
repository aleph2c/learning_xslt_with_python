<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2004/10/xpath-functions"
  xmlns:str-fn="local-functions.uri"
  xmlns:private-str-fn="local-functions.uri"
  exclude-result-prefixes="xs str-fn private-str-fn"
>

<xsl:template name="string-dup">
  <xsl:param name="input" as="xs:string" />
  <xsl:param name="count" as="xs:integer" />
  <xsl:value-of select="private-str-fn:dup($input, $count)" />
</xsl:template>

<xsl:function name="str-fn:dup">
  <xsl:param name="input" as="xs:string" />
  <xsl:sequence select="private-str-fn:dup($input, 2)" />
</xsl:function>

<xsl:function name="private-str-fn:dup">
  <xsl:param name="input" as="xs:string" />
  <xsl:param name="count" as="xs:integer" />
  <xsl:sequence select="string-join(for $i in 1 to $count return $input,'')" />
</xsl:function>

</xsl:stylesheet>
