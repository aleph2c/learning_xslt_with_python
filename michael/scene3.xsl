<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
version="3.0">

<xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes" />

<xsl:variable name="background" select="'#FFFFCC'" />

<xsl:template match="SCENE|PROLOGUE|EPILOGUE">
  <html>
    <head>
      <title><xsl:value-of select="TITLE" /></title>
      <style type="text/css">
        h1 {text-align:center}
        h2 {text-align:center; font-size:120%; margin-top:12;margin-bottom:12}
        body {background-color: <xsl:value-of select="$background" />}
        div.speech {float:left; width=100%; padding:0; margin-top:6}
        div.speaker {float:left; width:160;}
        div.text {float:left}
      </style>
    </head>
    <body>
      <xsl:apply-templates />
    </body>
  </html>
</xsl:template>

<xsl:template match="SPEECH">
  <div class="speech">
    <div class="speaker">
      <xsl:apply-templates select="SPEAKER" />
    </div>
    <div class="text">
      <xsl:apply-templates select="STAGEDIR|LINE" />
    </div>
  </div>
</xsl:template>

<xsl:template match="TITLE">
  <h1><xsl:apply-templates /></h1>
</xsl:template>

<xsl:template match="SPEAKER">
  <strong>
    <xsl:apply-templates />
    <xsl:if test="not(position()=last())"><br/></xsl:if>
  </strong>
</xsl:template>

<xsl:template match="SCENE/STAGEDIR">
  <h2>
    <xsl:apply-templates />
  </h2>
</xsl:template>

<xsl:template match="SPEECH/STAGEDIR">
  <p>
    <em><xsl:apply-templates /></em>
  </p>
</xsl:template>

<xsl:template match="LINE/STAGEDIR">
  <xsl:text>[ </xsl:text>
  <em><xsl:apply-templates /></em>
  <xsl:text> ]</xsl:text>
</xsl:template>

<xsl:template match="SCENE/SUBHEAD">
  <h2><xsl:apply-templates /></h2>
</xsl:template>

<xsl:template match="SPEECH/SUBHEAD">
  <p><strong><xsl:apply-templates /></strong></p>
</xsl:template>

<xsl:template match="LINE">
  <xsl:apply-templates />
  <br/>
</xsl:template>

</xsl:stylesheet>
