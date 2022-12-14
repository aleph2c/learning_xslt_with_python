# Learning XSLT

XSLT is a language used to convert the data of an XML file, into another
format.  XSLT stands for eXtensible Stylesheet Language Transforms.  XSLT is
very flexible; you can convert your XML data into HTML files, SVG images or
Python programs, or something else.  It seems like XSLT is significantly more
powerful than newer templating techniques, such as Jinja2 because it supports
the powerful XPath mini-search language and within XPath there is support for
regular expressions.  To use Jinja2, you have to have a complete understanding
of the data you feed your template, but with XSLT, XPath gives you a way to
create data search strings as you create your data transforms.  Jinja2 is still
a great tool for transforming small data structures, while XSLT can be used for
arbitrarily large data sets.  Both Jinja2 and XSLT are mini-languages; just as
regular expressions are a mini-language.

I created this repo to learn XSLT and how it can be integrated with Python.
Python does not come with an XSLT parser, but you can install external
libraries that integrate these parsers into Python.  There are currently three
versions of XSLT, but most open-source tools only support version "1.0".  The
XSLT technology is powerful, but it fell out of favour, as did XML and UML.
These technologies came from a different time, where arbitrary amounts of
formalism (and tedium) were accepted by the community.  The position of an
architect was a thing, and the water fall process was followed.  Today,
developers are more mercenary with their time, and they want immediate
understanding and results.

The community that supports XSLT and XML is very different from the open-source
community.  They seem to want to get paid for their work!

I keep being drawn back to XML because of XPath.  I continue to have to
template data into other files and forms; in researching better ways to do
this, I found XSLT.  I guess I should learn it before I integrate it into my
work.

If you want to follow along, go and get a copy of "Beginning XSLT 2.0 From
Novice to Professional" by Jeni Tennison, clone this repo and install the
command line tools and the XSLT parsers.

This package uses two XSLT python interpreters, the freely available lxml
(support for XSLT version 1.0) and saxonpy (support for XSLT 1.0, 2.0 and 3.0).
The saxonpy install will only work on Linux, if you want to build this for a
mac, you will have to pull down the saxon c source files and build it locally.
(the saxonica people want to be paid for their code and aren't making it easy
to take it for free).

It is very difficult to learn XML from a book.  You have to have an extremely
patient mind to learn the non-stop alphabet soup of acronyms before you get to
your "hello world".  If you are transcribing their examples into files, then
trying to run those files through your python program, most of your time will
be spent debugging, and not learning. XML books have a way of bleeding-away
will-power.  This repo tries to solve this problem; the book's examples are
organized into separate chapter-folders, and a CLI tool it installed to make it
easy to run a specific example and check its output and results.  The CLI tool
has a cache, so you only have to type the minimal number of things to get the
result you want.

```bash
python3 -m venv venv
pip install --upgrade pip
pip install -e .
```

# Running Examples

The repo installs a ``try`` command.  To see how it works:

```text
try --help
Usage: try [OPTIONS] COMMAND [ARGS]...

    Try an XSLT example and cache the command

Options:
  -d, --dir TEXT  Set the exercise directory
  --help          Show this message and exit.

  Commands:
    cache  View your command cache
    ex     Run an exercise

```

To see how to run an exercise:

```text
try ex --help
Usage: try ex [OPTIONS]

  Run an exercise

Options:
  -n, --node-name TEXT    Set the node name
  -x, --xml TEXT          Set the xml file
  -l, --xls TEXT          Set the xls file
  -p, --processor TEXT    Set the processor (lxml|saxon)
  -o, --output_file TEXT  Set the output file name
  --help                  Show this message and exit.
```

To run an example:

```
try -d ch2_html_from_xml ex -n TVGuide2 -p lxml
# a lot of XML

ran the lxml process
```

To see your cache:

```
try cache
{'home_dir': '/home/scott/xslt/ch3_templates', 'output_file_name':
'TVGuide2.html', 'processor': 'lxml', 'xls_file_name': 'TVGuide2.xsl',
'xml_file_name': 'TVGuide2.xml'}
```

To run the same exercise again:

```
try ex
# a lot of XML

ran the lxml processor
```

To try the same example with the saxon processor, you just have to tell the
``try`` command you want to use the ``saxonpy`` processor, if the other options
are not specified it will use your cached options:

```
try ex -p saxonpy
# a lot of XML

ran the saxon processor
```

# Examples from a different book

To run examples from a different book, add a descriptive folder name for each
chapter and add your xml and xsl files so that the basename are the same.
Example ``MyExample1.xml``, ``MyExample1.xsl``

