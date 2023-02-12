<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/02/xpath-functions" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="/">
		<xsl:variable name="foo" select="-1"/>
	
		<xsl:message use-when="system-property('debug_on') = 'yes' ">
			<xsl:text>Debug mode is on!</xsl:text>
		</xsl:message>

		<!-- Output the value of $foo and terminate if it is negative -->
		<xsl:message select=" 'foo=', $foo " terminate="{ if ($foo lt 0) then 'yes' else 'no'}"/>
	</xsl:template>
	
</xsl:stylesheet>
