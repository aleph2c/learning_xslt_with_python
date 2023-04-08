from pathlib import Path
from saxonche import PySaxonProcessor
this_dir = Path(__file__).parent

# What this code demonstrates:
#
# 1) How to parse an XML string with an XSLT string into an output string
#
# This code was buried in the saxonche package, within the "test_saxonc.py"
# file.  This file contains other examples.

with PySaxonProcessor(license=False) as proc:

    # parse the XML text into an XDM structure called document
    document = proc.parse_xml(xml_text="""\
<out>
  <person>text1</person>
  <person>text2</person>
  <person>text3</person>
</out>""")

    # create an xsltproc object and use it to compile your XSLT
    xsltproc = proc.new_xslt30_processor()
    executable = xsltproc.compile_stylesheet(stylesheet_text="""\
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='2.0'>
  <xsl:param name='values' select='(2,3,4)' />
  <xsl:output method='xml' indent='yes' />

  <xsl:template match='*'>
     <output>
       <xsl:value-of select='//person[1]'/>
       <xsl:for-each select='$values' >
         <out>
           <xsl:value-of select='. * 3'/>
         </out>
       </xsl:for-each></output>
    </xsl:template></xsl:stylesheet>
""")

    # you have to call the XSLT executable twice with your document information
    executable.set_initial_match_selection(xdm_value=document)
    executable.set_global_context_item(xdm_item=document)

    output2 = executable.apply_templates_returning_string()
    assert output2 is not None
    assert output2.startswith('<?xml version="1.0" encoding="UTF-8"?>\n<output>text1<out>6</out')
    print(output2)


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
