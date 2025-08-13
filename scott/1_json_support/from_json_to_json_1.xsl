<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="3.0"
xpath-default-namespace="http://www.w3.org/2005/xpath-functions">

  <!--
    try -d scott/1_json_support
      ex \
      -j json_1.json  \
      -l from_json_to_json_1.xsl -o \
      json_out_1.json
  -->

  <!--
    A DEVELOPER'S GUIDE to <xsl:mode on-no-match="..."> in XSLT 3.0

    This attribute sets the global, default rule for what happens when the processor
    encounters a node that does not have a specific <xsl:template match="..."> for it.
    Think of it as the "catch-all" behavior for your entire transformation.

    on-no-match="shallow-copy" (The "Smart Identity Transform")

      - What it Does: Copies the current node and all its attributes, then continues
                      processing its children.
      - Use it when: You want to copy most of an XML document as-is, while only
                     writing specific templates for the few things you want to change.
                     This is the most common and useful mode for transformations.
      - Analogy: A smart photocopier that copies the current page's layout and
                 headers, then processes the content inside.
  -->
  <xsl:mode on-no-match="shallow-copy" />

  <!-- The "json_input_filename" is provided by the cli -->
  <xsl:param name="json_input_filename" />
  <xsl:output method="text" />

  <!--
  initial-template is required since we don't have a root node
  -->
  <xsl:template name="xsl:initial-template">
    <xsl:variable name="input-as-xml" select="json-to-xml(unparsed-text($json_input_filename))"/>
    <xsl:variable name="transformed-xml" as="document-node()">
      <xsl:apply-templates select="$input-as-xml"/>
    </xsl:variable>
    <xsl:value-of select="xml-to-json($transformed-xml)"/>
  </xsl:template>

  <!--

    Don't become confused: the 'map' and 'array' in this statement are not
    referring to the keywords 'map' and 'array'.  The json-to-xml function
    creates xml with 'map' and 'array' tags.

    Also, you only wrote a rule for the ice item, yet you want the whole thing
    to print out, this is done because we set

    <xsl:mode on-no-match="shallow-copy"/>

    <array>
      <map>
        <number key="id">2</number>
        <string key="name">An ice sculpture</string>
        <number key="price">12.50</number>
        <array key="tags">
          <string>cold</string>
          <string>ice</string>
        </array>
        <map key="dimensions">...</map>
        <map key="warehouseLocation">...</map>
      </map>
      <map>
        <number key="id">3</number>
        <string key="name">A blue mouse</string>
        <number key="price">25.50</number>
        <array key="tags">
          <string>small</string>
        </array>
        <map key="dimensions">...</map>
        <map key="warehouseLocation">...</map>
      </map>
  </array>

  The xpath uses a predicate to reach into map[array[@key='tags']/string='ice']
    and finds that node, then continues the path search on the matching map:
    <matching map>/number[@key='price'], this is now referencing the number node
    /text() will return the value of that node.
  The value-of select="xs:decimal(.)*1.1" is new XPath 3.1 syntax
  -->

  <xsl:template match="map[array[@key='tags']/string='ice']/number[@key='price']/text()">
    <xsl:value-of select="xs:decimal(.)*1.1"/>
  </xsl:template>

</xsl:stylesheet>

