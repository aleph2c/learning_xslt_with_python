<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="xs"
  version="3.0">

<!--
  XML DOC STYLESHEET UPGRADE PATH
  0.0.0 -> 0.0.1
  FOR XML VERSIONING TRANSFORMs

  This tranform will be applied to the XML that contains the mission
  information.

  This stylesheet transform will be applied across all such mission documents to
  synchronize the data with the data format expected by the current version of
  the software.

  This file could be one of many used to transform the customer's data to the
  current version fo the software.
-->

<xsl:output method="xml" encoding="UTF-8" indent="yes" />

<xsl:variable name="old_version" as="xs:string" select="'0.0.0'" />
<xsl:variable name="new-version" as="xs:string" select="'0.0.1'" />

<xsl:template name="xsl:initial-template">
  <ooda version="{$new-version}">
  <mission></mission>
  <parent></parent>
  <observe>
    <goal />
    <summary />
  </observe>
  <orient>
    <discoveries />
    <questions />
    <ideas />
  </orient>
  <decide>
    <plan />
  </decide>
  <act />
</ooda>
</xsl:template>

</xsl:stylesheet>
