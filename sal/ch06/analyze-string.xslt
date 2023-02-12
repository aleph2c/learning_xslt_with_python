<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes">

<xsl:variable name="test" as="element(test)">
  <test>
    <date>2004/01/01</date>
    <date>2004-01-01</date>
    <date> 2004-01-01 </date>
    <date>Jan 1, 2004</date>
  </test>
</xsl:variable>

<xsl:template match="/">
  <test>
  <xsl:apply-templates select="$test"/>
  </test>
</xsl:template>

<xsl:template match="date">
  <xsl:copy>
    <xsl:analyze-string select="normalize-space(.)" regex="(\d\d\d\d) ( / | - ) (\d\d) ( / | - ) (\d\d)" flags="x">
      <xsl:matching-substring>
        <year><xsl:value-of select="regex-group(1)"/></year>
        <month><xsl:value-of select="regex-group(3)"/></month>
        <day><xsl:value-of select="regex-group(5)"/></day>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <error><xsl:value-of select="."/></error>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
