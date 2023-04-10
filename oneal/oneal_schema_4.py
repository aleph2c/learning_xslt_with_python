from pathlib import Path

import saxonche
from saxonche import PySaxonApiError
from saxonche import PySaxonProcessor

# the schema information will be ignored

with PySaxonProcessor(license=False) as proc:

  this_dir = Path(__file__).parent
  path_to_xml_doc = this_dir / 'test_with_schema_4.xml'
  with open(path_to_xml_doc, 'r') as fp:
    xml = fp.read()
  xp = proc.new_xpath_processor()
  node = proc.parse_xml(xml_text=xml)
  print('test 1\n node='+node.string_value)
  xp.set_context(xdm_item=node)
  item = xp.evaluate_single('//person/name[1]')
  if isinstance(item, saxonche.PyXdmNode):
    print(item.string_value)


