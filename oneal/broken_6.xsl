<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:array="http://www.w3.org/2005/xpath-functions/array"
  xmlns:lfn="http://127.0.0.1/local/functions"
  xmlns:private-lfn="http://127.0.0.1/private/local/functions"
  exclude-result-prefixes="lfn private-lfn"
>

<xsl:output method="text" encoding="UTF-8" version="1.0" indent="no" />

<!--
  try
    -d oneal
    ex
    -x test_6.xml \
    -l broken_6.xsl \
    -o test_6.txt \
    -v
-->

<xsl:strip-space elements="*" />
<!--
# XSLT 3.0
# shallow-skip: causes all node that are not matched (including text nodes)
#               to be skipped
# fail:         treats a no-match as an error
# true:         results in a warning
-->
<xsl:mode on-no-match="shallow-skip" />

<xsl:template match="/">
  <xsl:value-of select="break here!" />
</xsl:template>

<!-- remove default behavior, for XSLT 1.0/2.0 -->
<xsl:template match="*">
  <xsl:message terminate="no">
    WARNING: Unmatched element: <xsl:value-of select="name()"/>
  </xsl:message>
  <xsl:apply-templates/>
</xsl:template>
</xsl:stylesheet>
