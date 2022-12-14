
from pathlib import Path
from saxonpy import PySaxonProcessor

this_dir = Path(__file__).parent

XML_FILE = "TVGuide1.xml"
XSL_FILE = "TVGuide1.xsl"
OUTPUT_FILE = "TVGuide1.html"

with PySaxonProcessor(license=False) as proc:
  xsltproc = proc.new_xslt_processor()

  with open(this_dir / XML_FILE) as fp:
    xml_text = fp.read()
  document = proc.parse_xml(xml_text=xml_text)

  with open(this_dir / XSL_FILE) as fp:
    xslt_text = fp.read()
  xsltproc.set_source(xdm_node=document)
  xsltproc.compile_stylesheet(stylesheet_text=xslt_text)
  output = xsltproc.transform_to_string()
  print(output)

  if output:
    with open(this_dir / OUTPUT_FILE, "w" ) as fp:
      fp.write(output)
  else:
    print('there is nothing to write')

