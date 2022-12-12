from pathlib import Path
from saxonpy import PySaxonProcessor

this_dir = Path(__file__).parent

with PySaxonProcessor(license=False) as proc:
  xsltproc = proc.new_xslt_processor()

  with open(this_dir / 'HelloWorld.xml') as fp:
    xml_text = fp.read()
  document = proc.parse_xml(xml_text=xml_text)

  with open(this_dir / 'HelloWorld.xsl') as fp:
    xslt_text = fp.read()
  xsltproc.set_source(xdm_node=document)
  xsltproc.compile_stylesheet(stylesheet_text=xslt_text)
  output = xsltproc.transform_to_string()
  print(output)

  #doc = proc.parse_xml(xml_



