<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:template name="string-replace">
    <xsl:param name="input" as="xs:string" />
    <xsl:param name="search-string" as="xs:string" />
    <xsl:param name="replace-string" as="xs:string" />
    <xsl:choose>
      <!-- See if the input contains the search string -->
      <xsl:when test="$search-string and contains($input,$search-string)">
      <!-- If so, then concatenate the substring before the search
        string to the replacement string and to the result of
        recursively applying this template to the remaining substring.
      -->
        <xsl:value-of select="substring-before($input,$search-string)"/>
        <xsl:value-of select="$replace-string"/>
        <xsl:call-template name="string-replace">
          <xsl:with-param name="input"
          select="substring-after($input,$search-string)"/>
          <xsl:with-param name="search-string"
          select="$search-string"/>
          <xsl:with-param name="replace-string"
          select="$replace-string"/>
          </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- There are no more occurrences of the search string so
        just return the current input string -->
        <xsl:value-of select="$input"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
