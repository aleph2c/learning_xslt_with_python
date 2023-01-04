<html xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xsl:version="3.0">
  <head>
    <title>Management Structure</title>
  </head>
  <body>
    <h1>Management Structure</h1>
    <p>The following responsibilities were announced on
      <xsl:value-of select="format-date(/orgchart/@date, '[D1] [MNn] [Y1]')" /></p>
    <table border="2" cellpadding="5">
      <tr>
        <th>Name</th><th>Role</th><th>Reporting to</th>
      </tr>
      <xsl:for-each select="//person">
        <tr>
          <td><xsl:value-of select="name" /></td>
          <td><xsl:value-of select="title" /></td>
          <td><xsl:value-of select="ancestor::person[1]/name" /></td>
        </tr>
      </xsl:for-each>
    </table>
  </body>
</html>
