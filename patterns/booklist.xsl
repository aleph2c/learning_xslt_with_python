<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="3.0" >
  <!--
    Comment about the above block, we place "xs" in the exclude-result-prefixes
    because we do not want the xs namespace in the result document
  -->
  <xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes" />

  <!--
    Indexing with XPaths.
  -->
  <xsl:key name="pub" match="book" use="publisher" />

  <!--
    Declare a variable that refers to an input document, for later use in a named
    template that has no context node.
  -->
  <xsl:variable name="in" select="/" as="document-node()" />

  <!--
    The global variable $publishers is a sequence of strings containing one string
    for each distinct publisher found in the source file.
  -->
  <xsl:variable name="publishers" as="xs:string*"
       select="distinct-values(/booklist/book/publisher)" />

  <!--
    The main template iterates over the distinct publishers using the
    <xsl:for-each>
  -->
  <xsl:template match="/">
  <html>
    <head>
      <title>Sales volume by publisher</title>
    </head>
    <body>
      <h1>Sales volume by publisher</h1>
      <table>
        <tr>
          <th>Publisher</th><th>Total Units Sold</th>
        </tr>
        <!--
          The order of which these items are collected, doesn't matter, this is
          a declarative language, it could be forward or backward or all at the
          same instance and you would get the same result.
        -->
        <xsl:for-each select="$publishers">
          <tr>
            <td><xsl:value-of select="." /></td>
            <td><xsl:call-template name="total-sales" /></td>
          </tr>
        </xsl:for-each>
      </table>
    </body>
  </html>
  </xsl:template>

  <xsl:template name="total-sales">
    <xsl:param name="publisher" select="." />
    <xsl:value-of select="sum($in/key('pub', $publisher)/sales)" />
  </xsl:template>

</xsl:stylesheet>
