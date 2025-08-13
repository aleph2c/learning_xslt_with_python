<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="3.0">

  <xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes" />

  <!--
    With a key we don't have to repeat things like this:
    //book[publish = 'HarperCollins']

    This gives you a handle to book that can be indexed by the node value of
    publisher
  -->
  <xsl:key name="kbook_with" match="book" use="publisher" />

  <xsl:template match="/">
    <xsl:variable name="doc" select="." as="document-node()" />

    <xsl:variable name="publishers" as="xs:string*"
         select="distinct-values($doc/booklist/book/publisher)" />

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
          <xsl:for-each select="$publishers">
            <tr>
              <td><xsl:value-of select="." /></td>
              <td>
                <xsl:call-template name="total-sales">
                  <xsl:with-param name="publisher" select="." />
                  <xsl:with-param name="doc" select="$doc" />
                </xsl:call-template>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="total-sales">
    <xsl:param name="publisher" as="xs:string" />
    <xsl:param name="doc" as="document-node()" />

    <xsl:value-of select="sum(key('kbook_with', $publisher, $doc)/sales)" />
  </xsl:template>

</xsl:stylesheet>
