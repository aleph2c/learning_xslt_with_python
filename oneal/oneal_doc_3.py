import saxonche
from saxonche import PySaxonApiError
from saxonche import PySaxonProcessor

# What this code demonstrates:
#
# 1) I think it's showing the compiler will produce an error, but the
#    error messages still seemed to be turned off. So errors in this
#    implementation are still useless.
# 2) It shows how to create a "new_xpath_processor()" and it uses this
#    to evaluate an Xpath expression and print the results to the screen
#
# The original code contains a bug, so it wasn't tested by O'Neal before he
# published it

with PySaxonProcessor(license=False) as proc:

  print(proc.version)
  print('Example 1\n')
  try:
      xsltproc = proc.new_xslt30_processor()
      document = proc.parse_xml(xml_text="""\
        <out>
          <person>text1</person>
          <person>text2</person>
          <person>text3</person>
        </out>
""")
      executable = xsltproc.compile_stylesheet(stylesheet_file="test.xsl")

      print(document)

      output = executable.transform_to_string(xdm_node=document)
      print(output)
  except PySaxonApiError as err:
      print('Error during function call:', err)


  print('Example 2\n')
  xml = """\
    <out>
      <person>text1</person>
      <person>text2</person>
      <person>text3</person>
    </out>"""
  xp = proc.new_xpath_processor()
  node = proc.parse_xml(xml_text=xml)
  print('test 1\n node='+node.string_value)
  xp.set_context(xdm_item=node)
  item = xp.evaluate_single('//person[1]')
  # In O'Neal's code (see
  # https://www.saxonica.com/saxon-c/documentation12/index.html#!samples/samples_python)
  # There is a bug in the following line
  # He writes 'saxonc' instead of 'saxonche' in the next line
  if isinstance(item, saxonche.PyXdmNode):
    print(item.string_value)


