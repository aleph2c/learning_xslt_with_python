<?xml version="1.0" encoding="utf-8"?>
<!-- TVGuide1.xsl 
Convert the TVGuide1.xml file into html
-->
<html xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xsl:version="2.0">
  <head>
    <title>TV Guide</title>
    <link rel="stylesheet" href="TVGuide.css"/>
    <script type="text/javascript">
      function toggle(element) {
        if (element.style.display == 'none') {
          element.style.display = 'block';
        }
        else {
          element.style.display = 'none';
        }
      }
    </script>
  </head>
  <body>
    <h1>TV Guide</h1>
    <xsl:for-each select="/TVGuide/Channel">
      <h2 class="channel"><xsl:value-of select="Name" /></h2>
    </xsl:for-each>
  </body>
</html>
