<xsl:stylesheet version="3.0"

  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" encoding="UTF-8" />

<xsl:template match="/">
  <xsl:variable name="my-sequence" as="xs:string*">
    <xsl:sequence select="'one', 'two', 'three'"/>
        </xsl:variable>
        <xsl:variable name="updated-sequence" as="xs:string*">
        <xsl:sequence select="insert-before($my-sequence, count($my-sequence) + 1, 'four')"/>
    </xsl:variable>

    <output>
      <xsl:value-of select="$updated-sequence"/>
    </output>
  </xsl:template>

  </xsl:stylesheet>
