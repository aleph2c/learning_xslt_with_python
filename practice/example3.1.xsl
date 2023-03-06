<xsl:stylesheet version="3.0"

  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" encoding="UTF-8" />
<!-- Define the accumulator -->
<xsl:accumulator name="my-accumulator" initial-value="0"
as="xs:integer">
<xsl:accumulator-rule match="node()" select="$value + 1"/>
</xsl:accumulator>

<!-- Use the accumulator in different parts of the program -->
<xsl:template match="/">
  <output>
    <xsl:value-of select="accumulator-before('my-accumulator')"/> <!-- Outputs 0
    -->
    <xsl:apply-templates select="node()"/>
    <xsl:value-of select="accumulator-after('my-accumulator')"/> <!-- Outputs 3
    -->
      </output>
      <output>
        <xsl:value-of select="accumulator-before('my-accumulator')"/> <!--
        Outputs 3 -->
        <xsl:apply-templates select="node()"/>
        <xsl:value-of select="accumulator-after('my-accumulator')"/> <!--
        Outputs 6 -->
  </output>
    
  <!-- Re-initialize the accumulator to a new value -->
  <xsl:accumulator name="my-accumulator" initial-value="10" as="xs:integer">
  <xsl:accumulator-rule match="node()" select="$value + 1"/>
    </xsl:accumulator>
      
    <output>
      <xsl:value-of select="accumulator-before('my-accumulator')"/> <!-- Outputs
      10 -->
      <xsl:apply-templates select="node()"/>
      <xsl:value-of select="accumulator-after('my-accumulator')"/> <!-- Outputs
      13 -->
        </output>
        </xsl:template>

</xsl:stylesheet>
