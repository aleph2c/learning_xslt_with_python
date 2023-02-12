<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/02/xpath-functions" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes">

	<xsl:import href="copy.xslt"/>

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="people">
	   <xsl:copy>
			<xsl:for-each-group select="*" group-starting-with="class">
				<xsl:element name="{@name}">
					<xsl:apply-templates select="current-group()[not(self::class)]"/>
				</xsl:element>
			</xsl:for-each-group>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
