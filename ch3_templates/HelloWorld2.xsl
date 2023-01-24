<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="test_param"/>

<xsl:template match="/">
  <html>
    <head><title>Hello World Example</title></head>
    <body>
      <p>
        <xsl:value-of select="$test_param" />
      </p>
      <p>
        <xsl:value-of select="/greeting" />
      </p>
    </body>
  </html>  
</xsl:template>

</xsl:stylesheet>
