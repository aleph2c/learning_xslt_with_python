<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2004/10/xpath-functions"
  xmlns:xdt="http://www.w3.org/2004/10/xpath-datatypes"
  xmlns:str="http://www.ora.com/XSLTCookbook/namespaces/strings"
  xmlns:str-fn="local-functions.uri"
  xmlns:private-str-fn="local-functions.uri"
  exclude-result-prefixes="xs str-fn private-str-fn"
>
<xsl:output method="text"/>

<!--Levels indented with two spaces by default -->
<xsl:param name="indent" select=" ' ' "/>

<xsl:template match="*">
  <xsl:param name="level" select="count(./ancestor::node())"/>
  <!-- Indent this element -->
  <xsl:call-template name="string-dup" >
    <xsl:with-param name="input" select="$indent"/>
    <xsl:with-param name="count" select="$level"/>
  </xsl:call-template>
  <!--Process the element name. Default will output local-name -->
  <xsl:apply-templates select="." mode="name">
    <xsl:with-param name="level" select="$level"/>
  </xsl:apply-templates>
  <!--Signal the start of processing of attributes.
  Default will output '(' -->
  <xsl:apply-templates select="." mode="begin-attributes">
    <xsl:with-param name="level" select="$level"/>
  </xsl:apply-templates>
  <!--Process attributes.
  Default will output name="value". -->
  <xsl:apply-templates select="@*">
    <xsl:with-param name="element" select="."/>
    <xsl:with-param name="level" select="$level"/>
  </xsl:apply-templates>
  <!--Signal the end of processing of attributes.
  Default will output ')' -->
  <xsl:apply-templates select="." mode="end-attributes">
    <xsl:with-param name="level" select="$level"/>
  </xsl:apply-templates>
  <!-- Process the elements value. -->
  <!-- Default will format the value of a leaf element -->
  <!-- so it is indented at next line -->
  <xsl:apply-templates select="." mode="value">
    <xsl:with-param name="level" select="$level"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="." mode="line-break">
    <xsl:with-param name="level" select="$level"/>
  </xsl:apply-templates>

  <!-- Process children -->
  <xsl:apply-templates select="*">
      <xsl:with-param name="level" select="$level + 1"/>
  </xsl:apply-templates>
</xsl:template>

<!--Default handling of element names. -->
<xsl:template match="*" mode="name">[<xsl:value-of select="local-name(.)"/></xsl:template>

<!--Default handling of start of attributes. -->
<xsl:template match="*" mode="begin-attributes">
  <xsl:if test="@*"><xsl:text> </xsl:text></xsl:if>
</xsl:template>

<!--Default handling of attributes. -->
<xsl:template match="@*">
  <xsl:value-of select="local-name(.)"/>="<xsl:value-of select="."/>"<xsl:text/>
  <xsl:if test="position( ) != last( )">
    <xsl:text> </xsl:text>
  </xsl:if>
</xsl:template>

<!--Default handling of end of attributes. -->
<xsl:template match="*" mode="end-attributes">]</xsl:template>

<!--Default handling of element values. -->
<xsl:template match="*" mode="value">
  <xsl:param name="level"/>
  <!-- Only output value for leaves -->
  <xsl:if test="not(*)">
    <xsl:variable name="indent-str">
    <xsl:call-template name="string-dup" >
      <xsl:with-param name="input" select="$indent"/>
      <xsl:with-param name="count" select="$level"/>
    </xsl:call-template>
    </xsl:variable>
    <xsl:text>&#xa;</xsl:text>
    <xsl:value-of select="$indent-str"/>
    <xsl:call-template name="string-replace">
      <xsl:with-param name="input" select="."/>
      <xsl:with-param name="search-string" select=" '&#xa;' "/>
      <xsl:with-param name="replace-string" select="concat('&#xa;',$indent-str)"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="line-break">
  <xsl:text>&#xa;</xsl:text>
</xsl:template>

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
