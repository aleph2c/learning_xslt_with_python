<?xml version="1.0" encoding="utf-8"?>
<!-- TVGuide1.xsl 
Convert the TVGuide1.xml file into html
-->
<html xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xsl:version="2.0">
  <head>
    <title>Hello World Example</title>
  </head>
  <body>
    <p>
      <xsl:value-of select="/greeting" />
    </p>
  </body>
</html>
