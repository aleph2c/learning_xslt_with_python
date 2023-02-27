<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" indent="no" />
<xsl:strip-space elements="*" />

<xsl:template match="/">
  <xsl:for-each select="employees/employee">
    *<xsl:value-of select="@name" />*
    <xsl:for-each select="phonenumber">
          <xsl:value-of select="@type" />: <xsl:value-of select="." /><xsl:text>&#xA;</xsl:text>
    </xsl:for-each>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
