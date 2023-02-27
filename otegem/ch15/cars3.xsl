<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:auto="http://www.cars.com"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" encoding="UTF-8" version="1.0" indent="no" />

<xsl:template match="/">
  <xsl:value-of select="namespace-uri(child::*)" />
</xsl:template>

</xsl:stylesheet>
