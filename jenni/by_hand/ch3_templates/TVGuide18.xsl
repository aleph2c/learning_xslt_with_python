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
    <head>
      <title>TV Guide</title>
      <link rel="stylesheet" href="TVGuide2.css" />
      <script type="text/javascript">
        function toggle(element) {
          if (element.style.display == 'none') {
            element.style.display = 'block';
          } else {
            element.style.display = 'none';
          }
        }
      </script>
    </head>

    <body>
      <h1>TV Guide</h1>
      <p>
        <xsl:apply-templates mode="ChannelList" />
      </p>
      <xsl:apply-templates />
      <p>
        <xsl:apply-templates mode="ChannelList" />
      </p>
    </body>
  </html>
</xsl:template>

<xsl:template match="Channel" mode="ChannelList">
  [<a href="#{Name}"><xsl:value-of select="Name" /></a>]
</xsl:template>

<xsl:template match="Channel/Name">
  <h2 class="channel">
    <a name="{.}" id="{.}"><xsl:apply-templates /></a>
  </h2>
</xsl:template>

<xsl:template match="Program">
  <div>
    <p>
      <xsl:apply-templates select="Start" /><br />
      <xsl:apply-templates select="Series" /><br />
      <xsl:apply-templates select="Description" />
      <span onclick="toggle({Series}Cast);">[Cast]</span>
    </p>
    <div id="{Series}Cast" style="display: none;">
      <ul class="castlist">
        <xsl:apply-templates select="CastList" />
      </ul>
    </div>
  </div>
</xsl:template>

<xsl:template match="Start">
  <span class="date"><xsl:apply-templates /></span>
</xsl:template>

<xsl:template match="Series">
 <span class="title"><xsl:apply-templates /></span>
</xsl:template>

<xsl:template match="CastMember">
  <li>
    <xsl:apply-templates select="Character" />
    <xsl:apply-templates select="Actor" />
  </li>
</xsl:template>

<xsl:template match="Character" priority="2">
  <span class="character">
    <xsl:next-match />
  </span>
</xsl:template>

<xsl:template match="CastMember/Character">
  <xsl:apply-templates select="Name" />
</xsl:template>

<xsl:template match="Actor" priority="2">
  <span class="actor">
    <xsl:next-match />
  </span>
</xsl:template>

<xsl:template match="CastMember/Actor">
  <xsl:apply-templates select="Name" />
</xsl:template>

<xsl:template match="Description//Link">
  <a href="{@href}"><xsl:apply-templates /></a>
</xsl:template>

<xsl:template match="Description//Program">
  <span class="program"><xsl:apply-templates /></span>
</xsl:template>

<xsl:template match="Description//Series">
  <span class="series"><xsl:apply-templates /></span>
</xsl:template>

<xsl:template match="Description//Channel">
  <span class="channel"><xsl:apply-templates /></span>
</xsl:template>

</xsl:stylesheet>
