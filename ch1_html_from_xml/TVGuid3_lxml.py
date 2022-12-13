from lxml import etree
from pathlib import Path

this_dir = Path(__file__).parent

XML_FILE = "TVGuide3.xml"
XSL_FILE = "TVGuide3.xsl"
OUTPUT_FILE = "TVGuide3.html"

transform = etree.XSLT(etree.parse(str(this_dir / XSL_FILE)))
doc = etree.parse(str(this_dir / XML_FILE))

result = transform(doc)

with open(this_dir / OUTPUT_FILE, "wb") as fp:
  fp.write(etree.tostring(result))


