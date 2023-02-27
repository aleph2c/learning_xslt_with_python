<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" encoding="UTF-8" version="5.0" indent="no" />
<xsl:strip-space elements="*" />

<xsl:template match="/">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="code">
  <xsl:comment>
  <script language="{@language}">
    <xsl:value-of select="." disable-output-escaping="yes" />
  </script>
  </xsl:comment>
</xsl:template>

</xsl:stylesheet>
