from pathlib import Path

import saxonche
from saxonche import PySaxonApiError
from saxonche import PySaxonProcessor

# the program will fail because it is not lisensed

with PySaxonProcessor(license=False) as proc:

  this_dir = Path(__file__).parent
  path_to_xml_doc = this_dir / 'test_with_bad_schema_5.xml'
  path_to_schema = this_dir / 'schema_5.xds'

  validator = proc.new_schema_validator()
  validator.register_schema(xds_file=str(path_to_schema))

  validator.validate(file_name=str(path_to_xml_doc))


