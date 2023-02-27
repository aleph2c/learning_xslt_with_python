<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:out="http://www.temp.com"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" encoding="UTF-8" version="1.0" indent="yes" />
<xsl:namespace-alias stylesheet-prefix="out" result-prefix="xsl" />
<xsl:template match="/">
  <out:stylesheet version="1.0">
    <out:value-of select="." />
  </out:stylesheet>
</xsl:template>

</xsl:stylesheet>
