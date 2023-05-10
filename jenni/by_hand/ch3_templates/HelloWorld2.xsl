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
<xsl:output method="xml" encoding="UTF-8" version="1.0" indent="yes" />
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
  <html>
    <head><title>Hello World Example</title></head>
    <body>
      <p>
        <xsl:value-of select="/greeting" />
      </p>
    </body>
  </html>
</xsl:template>



</xsl:stylesheet>
