<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="3.0"
  xmlns="http://www.w3.org/2005/xpath-functions"
  xpath-default-namespace="http://www.w3.org/2005/xpath-functions"
  expand-text="yes">

  <xsl:param name="json_input_filename"/>

  <xsl:output method="text"/>

  <xsl:template name="xsl:initial-template">
    <xsl:variable name="input-as-xml"
    select="json-to-xml(unparsed-text($json_input_filename))"/>
    <xsl:variable name="transformed-xml" as="element(array)">
      <array>
        <xsl:for-each-group select="$input-as-xml//string[@key='email']" group-by=".">
          <xsl:sort select="../string[@key='last']"/>
          <xsl:sort select="../string[@key='first']"/>
          <map>
            <string key="email">{current-grouping-key()}</string>
            <array key="courses">
              <xsl:for-each select="current-group()">
                <string>{../../../*[@key='course']}</string>
              </xsl:for-each>
            </array>
          </map>
        </xsl:for-each-group>
      </array>
    </xsl:variable>
    <xsl:value-of select="xml-to-json($transformed-xml)"/>
  </xsl:template>

</xsl:stylesheet>

