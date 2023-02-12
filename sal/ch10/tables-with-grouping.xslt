<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:output method="html"/>
     
  <xsl:template match="sales">
    <html>
      <head>
        <title>Sales by Region</title>
      </head>
      <body>
        <h1>Sales by Region</h1>
        <table border="1" cellpadding="3">
          <tbody>
            <tr>
              <th>SKU</th>
              <th>Sales</th>
            </tr>
            <xsl:for-each-group select="product" group-by="@region">
              <tr >
                <th colspan="2"><xsl:value-of select="."/> Sales</th>
              </tr>
              <xsl:apply-templates select="current-group()"/>
              <tr style="font-weight:bold">
                <td >Total</td>
                <td align="right"><xsl:value-of 
                select="format-number(sum(current-group()/@sales),'#.00')"/>
                </td>
              </tr>
            </xsl:for-each-group>
          </tbody>
        </table>
      </body>
    </html>
  </xsl:template>
     
  <xsl:template match="product">
    <tr>
      <td><xsl:value-of select="@sku"/></td>
      <td align="right"><xsl:value-of select="@sales"/></td>
    </tr>
  </xsl:template>
  

</xsl:stylesheet>
