from pathlib import Path
from saxonche import PySaxonProcessor

this_dir = Path(__file__).parent

# What the following code demonstrates:
#
# 1) how to turn an XML string into an "xdm_node" (see comment below)
# 2) how to apply an xsl program (not included in his example) 
#
# This is the main python documentation for the saxonche.  It can't be run
# because the "text.xsl" code was missing from the example.  I wonder if O'Neal
# tested this code.  His other examples also contain published bugs.

with PySaxonProcessor(license=False) as proc:
  print(proc.version)
  xsltproc = proc.new_xslt30_processor()
  document = proc.parse_xml(xml_text="""\
      <doc>
        <item>text1</item>
        <item>text2</item>
        <item>text3</item>
      </doc>
""")
  executable = xsltproc.compile_stylesheet(stylesheet_file=str(this_dir / "test.xsl"))
  output = executable.transform_to_string(xdm_node=document)
  print(output)


################################################################################
#                                     XDM                                      #
################################################################################
# XDM stands for "XQuery Data Model"
#
# XDM stands for "XQuery Data Model," which is a way of organizing and working
# with data used by XSLT and XQuery. Think of XDM as a framework or set of rules
# for how to structure and manipulate different types of data, such as XML
# documents or other structured and semi-structured data.
#
# The purpose of XDM is to provide a standardized way to organize and manipulate
# data different data languages, like XSLT and XQuery (which is often used
# within XSLT parsers). By providing a common framework for working with
# different types of data, XDM helps make these programming languages work
# together consistently.
#
# XDM provides a standard way to represent different types of data, including
# text, numbers, and elements like tags and attributes. It also provides a way to
# select and manipulate this data using tools like XPath expressions and XSLT
# functions. This makes it easier for XSLT and XQuery to understand and work with
# data in a consistent and predictable way.
#
# Overall, the purpose of XDM is to provide a standardized way to organize and
# manipulate data in XSLT and XQuery. By providing a common framework for working
# with different types of data, XDM helps make these programming languages work
# together consistently.
