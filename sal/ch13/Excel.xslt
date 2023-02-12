<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 xmlns:fn="http://www.w3.org/2005/02/xpath-functions" 
 xmlns:o="urn:schemas-microsoft-com:office:office" 
 xmlns:x="urn:schemas-microsoft-com:office:excel" 
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:ckbk="http://www.oreilly.com/xsltckbk">
 
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <!-- The name of the top level element -->
  <xsl:param name="topLevelName" select=" 'Table' " as="xs:string"/>
  <!-- The name of each row -->
  <xsl:param name="rowName" select=" 'Row' " as="xs:string"/>
  <!-- The namespace to use -->
  <xsl:param name="namespace" select=" '' " as="xs:string"/>
  <!-- The namespace prefix to use -->
  <xsl:param name="namespacePrefix" select=" '' " as="xs:string" />
  <!-- The character to use if column names contain white space -->
  <xsl:param name="wsSub" select="'_'" as="xs:string"/>
  <!--Determines which row contains the col names-->
  <xsl:param name="colNamesRow" select="1" as="xs:integer"/>
  <!--Determines which row the data begins -->
  <xsl:param name="dataRowStart" select="2" as="xs:integer"/>
  <!-- If false then cells with null or whitespace only content -->
  <!-- will be skipped -->
  <xsl:param name="includeEmpty" select="true( )" as="xs:boolean"/>
  <!-- If false then author and creation meta data will not be put -->
  <!-- into a comment-->
  <xsl:param name="includeComment" select="true( )" as="xs:boolean"/>
  
  <!--Normalize the namespacePrefix -->
  <xsl:variable name="nsp" as="xs:string" 
                        select="if (contains($namespacePrefix,':')) 
                                     then concat(translate(substring-before($namespacePrefix,':'),' ',''),':')
                                     else
                                     if (matches($namespacePrefix,'\W'))
                                     then concat(translate($namespacePrefix,' ',''),':') 
                                     else '' "/>
   
  <!--Get the names of all the columns-->
  <xsl:variable name="COLS" select="/*/*/*/ss:Row[$colNamesRow]/ss:Cell"/>
  
  <xsl:template match="o:DocumentProperties">
    <xsl:if test="$includeComment">
      <xsl:text>&#xa;</xsl:text>
      <xsl:comment select="concat('&#xa;',
                                            ckbk:comment(o:Company), 
                                            ckbk:comment(o:Author),
                                            ckbk:comment(o:Created,'Created on'),
                                            ckbk:comment(o:LastAuthor,'Last Author'),
                                            ckbk:comment(o:LastSaved,'Saved on'))"/>
      
    </xsl:if>
      <xsl:text>&#xa;</xsl:text>
  </xsl:template>
  
  <xsl:template match="ss:Table">
    <xsl:element
        name="{ckbk:makeName($nsp,$topLevelName,$wsSub)}" 
         namespace="{$namespace}">
      <xsl:apply-templates select="ss:Row[position() ge $dataRowStart]"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="ss:Row">
    <xsl:element
        name="{ckbk:makeName($nsp,$rowName,$wsSub)}" 
        namespace="{$namespace}">
      <xsl:for-each select="ss:Cell">
        <xsl:variable name="pos" select="position()"/>
   
       <!-- Get the correct column name even if there were empty -->
       <!-- cols in original spreadsheet -->     
        <xsl:variable name="colName" as="xs:string" 
                             select="if (@ss:Index and $COLS[@ss:Index = current()/@ss:Index]) 
                                         then $COLS[@ss:Index = current()/@ss:Index]/ss:Datae
                                         else
                                         if (@ss:Index)
                                         then $COLS[number(current()/@ss:Index)]/ss:Data
                                         else
                                        $COLS[$pos]/ss:Data"/>
        
        <xsl:if test="$includeEmpty or 
                      translate(ss:Data,'&#x20;&#x9;&#xA;','')">
          <xsl:element
               name="{ckbk:makeName($nsp,$colName,$wsSub)}" 
               namespace="{$namespace}">
            <xsl:value-of select="ss:Data"/>
          </xsl:element>
        </xsl:if>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="text()"/>

 <xsl:function name="ckbk:makeName" as="xs:string">
  <xsl:param name="nsp" as="xs:string"/>
  <xsl:param name="name" as="xs:string"/>
  <xsl:param name="wsSub" as="xs:string"/>
  <xsl:sequence select="concat($nsp,translate($name,
                                      '&#x20;&#x9;&#xA;',$wsSub))"/>
 </xsl:function>
 
 <xsl:function name="ckbk:comment" as="xs:string">
  <xsl:param name="elem"/>
  <xsl:sequence select="ckbk:comment($elem, local-name($elem))"/>
 </xsl:function>

 <xsl:function name="ckbk:comment" as="xs:string">
  <xsl:param name="elem"/>
  <xsl:param name="label" as="xs:string"/>
  <xsl:sequence select="if (normalize-space($elem)) 
                                       then concat($label,': ',$elem,'&#xa;')
                                       else '' "/>
 </xsl:function>
  
</xsl:stylesheet>
