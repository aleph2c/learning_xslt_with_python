<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" encoding="UTF-8" version="1.0" indent="yes" />

<xsl:template match="/">
  <xsl:value-of select="normalize-space(.)" />
</xsl:template>

</xsl:stylesheet>
