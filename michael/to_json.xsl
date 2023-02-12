<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="3.0"
  xpath-default-namespace="http://www.w3.org/2005/xpath-functions">

  <!-- "3.0" behavior, when a template doesn't match, invoke the
       "identity template", which copies an element and does
       apply-templates to its attributes and children 
  -->
  <xsl:mode on-no-match="shallow-copy"/>


  <!-- The "json_input_filename" is provided by the cli -->
  <xsl:param name="json_input_filename" />
  <xsl:output method="text" />

  <xsl:template name="xsl:initial-template">
    <xsl:variable name="input-as-xml" select="json-to-xml(unparsed-text($json_input_filename))"/>
    <xsl:variable name="transformed-xml" as="document-node()">
      <xsl:apply-templates select="$input-as-xml"/>
    </xsl:variable>
    <xsl:value-of select="xml-to-json($transformed-xml)"/>
  </xsl:template>

  <!-- Don't become confused: the 'map' and 'array' in this statement are not
    referring to the keywords 'map' and 'array'.  The json-to-xml function
    creates xml with 'map' and 'array' tags.
  -->
  <xsl:template match="map[array[@key='tags']/string='ice']/number[@key='price']/text()">
    <xsl:value-of select="xs:decimal(.)*1.1"/>
  </xsl:template>

</xsl:stylesheet>

