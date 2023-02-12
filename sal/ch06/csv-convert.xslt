<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xs="http://www.w3.org/2001/XMLSchema" 
xmlns:fn="http://www.w3.org/2005/02/xpath-functions" 
xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes">

 <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

 <xsl:param name="csv-file" select=" 'test.csv' "/>  
  
  <xsl:template match="/">
  
    <converted-csv filename="{$csv-file}">
      <xsl:for-each select="tokenize(unparsed-text($csv-file, 'UTF-8') , '\n')">
        <xsl:if test="normalize-space(.)">
          <row>
            <xsl:analyze-string select="." regex="," flags="x">
              <xsl:non-matching-substring>
                <col><xsl:value-of select="normalize-space(.)"/></col>
              </xsl:non-matching-substring>
            </xsl:analyze-string>
          </row>
        </xsl:if>
      </xsl:for-each>
    </converted-csv>
    
  </xsl:template>
  
</xsl:stylesheet>
