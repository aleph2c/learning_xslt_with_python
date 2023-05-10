from io import StringIO
from saxonche import PySaxonProcessor, XdmValue

xml_string = '<foo><bar></bar></foo>'
processor = PySaxonProcessor(license=False)
document_node = processor.parse_xml(xml_text=xml_string)

xpath_processor = processor.new_xpath_processor()

result = xpath_processor.evaluate(XdmValue.make_value('/foo/bar'),
    document_node.as_document_node())
print(result)  # should print an empty string

