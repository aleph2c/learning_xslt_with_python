<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="copy.xslt"/>
   
<xsl:output method="xml" indent="yes" version="1.0" encoding="UTF-8"/>
   
<!-- Match elements that are parents -->
<xsl:template match="*[*]">
  <xsl:choose>
    <!-- Only convert children if this element has no attributes -->
    <!-- of its own -->
    <xsl:when test="not(@*)">
      <xsl:copy>
        <!-- Convert children to attributes if the child has -->
        <!-- no children or attributes and has a unique name -->
        <!-- amoung its siblings -->
        <xsl:for-each-group select="*" group-by="name()">
          <xsl:sort select="count(current-group())" order="ascending" data-type="number"/>
          <xsl:choose>
            <xsl:when test="not(*) and count(current-group()) eq 1">
              <xsl:attribute name="{local-name(.)}">
                <xsl:value-of select="."/>
              </xsl:attribute>
              <!-- Copy attributes of child to parent element -->
              <xsl:copy-of select="@*"/>  
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="current-group()"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each-group>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
  
</xsl:stylesheet>
