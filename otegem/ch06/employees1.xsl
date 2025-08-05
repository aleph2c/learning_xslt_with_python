<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- 
  text files don't indent, so having indent="no" will fool you
  into thinking you have solved your whitespace problem when you haven't.
-->
<xsl:output method="text" indent="no" />
<xsl:strip-space elements="*" />

<!-- since you are including white space in your template
     it will show up in the output as weird indents -->
<xsl:template match="/">
  <xsl:for-each select="employees/employee">
    *<xsl:value-of select="@name" />*
    <xsl:for-each select="phonenumber">
          <xsl:value-of select="@type" />: <xsl:value-of select="." /><xsl:text>&#xA;</xsl:text>
    </xsl:for-each>
  </xsl:for-each>
</xsl:template>

<!-- to avoid the weird whitespace, you would use the <xsl:text></xsl:text> tags like this:

<xsl:template match="/">
  <xsl:for-each select="employees/employee">
    <xsl:text>*</xsl:text><xsl:value-of select="@name"/><xsl:text>*&#xA;</xsl:text>
    <xsl:for-each select="phonenumber">
      <xsl:value-of select="@type"/><xsl:text>:</xsl:text><xsl:value-of select="."/><xsl:text>&#xA;</xsl:text>
    </xsl:for-each>
  </xsl:for-each>
  </xsl:template>

-->

</xsl:stylesheet>
