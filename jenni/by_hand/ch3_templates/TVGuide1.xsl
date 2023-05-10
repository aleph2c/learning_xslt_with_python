<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:output method="html" encoding="UTF-8" version="5.0" indent="yes" />

<!--
  try
  -d jenni/ch3_templates
  ex
  -x TVGuide.xml \
  -l TVGuide.xsl \
  -o TVGuide.html
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
  <html>
    <head></head>
    <body>
      <xsl:apply-templates />
    </body>
  </html>
</xsl:template>

<xsl:template match="Channel">
  <h2 class="channel"><xsl:value-of select="Name" /></h2>
  <xsl:for-each select="Program">
    <div>
      <p>
        <span class="date"><xsl:value-of select="Start" /></span>
        <span class="title"><xsl:value-of select="Series"/></span>
        <xsl:value-of select="Description" />
        <span onclick="toggle({Series}Cast);">[Cast]</span>
      </p>
    </div>
    <div id="{Series}Cast" style="display: none;">
      <ul class="castlist">
        <xsl:for-each select="Castlist/CastMember">
          <li>
            <span class="character"><xsl:value-of select="Character" /></span>
            <span class="actor"><xsl:value-of select="Actor" /></span>
          </li>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:for-each>
</xsl:template>


</xsl:stylesheet>
