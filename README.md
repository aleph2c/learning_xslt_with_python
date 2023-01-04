# Learning XSLT

XSLT is a language used to convert the data of an XML file, into another format.
XSLT stands for eXtensible Stylesheet Language Transforms.  XSLT is very
flexible; you can convert your XML/JSON data into HTML files, SVG images or
Python programs, or any other file format.

XSLT is significantly more powerful than a lot of the newer templating
techniques, such as Python's Jinja2 library.  This is because XSLT is a fully
functional programming language that contains the powerful XPath
mini-tree-searching language and, within XPath, there is support for regular
expressions and custom function construction.  To use Jinja2, you have to have a
complete understanding of the data you feed your template, but XSLT is
declarative, you tell it what you want, and it figures out how to give it to
you.

Jinja2 is a great tool for transforming small data structures, while XSLT
can be used for arbitrarily large data sets.  XSLT software has been compiled
from XSLT.

I created this repo to learn XSLT and how it can be integrated with Python.  I
wanted something that had a lazy CLI (caches previous command inputs and uses
them to minimize typing), and an experimental environment to try the different
XSLT parsers from program examples included from three training sources.

Python does not come with an XSLT parser, but you can install external libraries
that integrate XSLT programming language into Python.  XSLT is current at
version "3.0", but most open-source tools only support version "1.0".  The XSLT
technology is powerful, but it seems to have fell out of favour, as did XML and
UML.  These technologies came from a different time, where arbitrary amounts of
formalism (and tedius syntax) were accepted by the community.

TTo follow along, go and get a copy of "Beginning XSLT 2.0 From Novice to
Professional" by Jeni Tennison, clone this repo and install the command line
tools and the XSLT parsers (see below).  After that, I recommend getting a copy
of "XSLT 2.0 and XPath 2.0 Programmer's Reference 4th Edition" and work through
Chapter 17: Stylesheet Design Patterns.  If you would like to learn how to use
the new XML-to-JSON, JSON-to-XML and JSON transform features of XSLT 3.0, read
[Transforming JSON using XSLT 3.0](https://www.saxonica.com/papers/xmlprague-2016mhk.pdf).
There is supporting example code for some of these JSON transforms and the
pattern's code in the pattern's folder of this repo.

An XSLT 3.0 book has not yet been published, and I find that the specifications
are written for an "in group", not someone trying to learn the technology.

This package uses two XSLT python interpreters, the freely available lxml python
library (support for XSLT version 1.0, XPath 1.0) and saxonpy (support for XSLT
1.0, 2.0 and 3.0, and XPath 3.1).  The saxonpy pip install will only work on
Linux.

It is very difficult to learn XML from a book.  If you are transcribing the
book's examples, then trying to run those files through your python program,
most of your time will be spent debugging, and not learning. XML books have a
way of bleeding-away will-power.  This repo tries to solve this problem; the
book's examples are organized into separate chapter-folders, and a CLI tool is
installed to make it easy to run a specific example and check its output and
results.  The CLI tool has a cache, so you only have to type the minimal number
of things to get the result you want.

# Installation of two XSLT processors and a Supporting CLI

To install the CLI, the two XSLT python parsers, and the example files:

```bash
git clone git@github.com:aleph2c/leaning_xslt.git
cd learning_xslt
python3 -m venv venv
pip install --upgrade pip
pip install -e .
source ./venv/bin/activate

# If the saxonpy pip package fails to run on your system you can try building
# the saxonica code from source and installing it into your venv
#
# This command will download, build andinstall the saxonica parser and fix a
# broken *nix install of the saxonpy pip package (if you are running on windows
# you can use the WSL or adjust the setup.py in this repo)
#
# python setup.py install
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

## How to Run Specific Examples

To see how to run an exercise:

```text
try ex --help
Usage: try ex [OPTIONS]

  Run an exercise

Options:
  -n, --node-name TEXT    Set the node name
  -x, --xml TEXT          Set the xml file
  -j, --json TEXT         Set the json file (saxon)
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

## Running Your Own Examples

To run examples from a different book, add a descriptive folder name for each
chapter and add your xml and xsl files so that the basename are the same.
Example ``MyExample1.xml``, ``MyExample1.xsl``

## JSON Transform Example 1

In this example we will perform a transform to increase the price of a product
tagged with "ice" by 10 percent (see ./patterns/to_json.xs):

Given this input:

```
python -m json.tool ./patterns.json_input.json

[
  {
    "id": 2,
    "name": "An ice sculpture",
    "price": 12.50,
    "tags": ["cold", "ice"],
    "dimensions": {
    "length": 7.0,
    "width": 12.0,
    "height": 9.5
    },
    "warehouseLocation": {
      "latitude": -78.75,
      "longitude": 20.4
    }
  },
  {
    "id": 3,
    "name": "A blue mouse",
    "price": 25.50,
    "dimensions": {
      "length": 3.1,
      "width": 1.0,
      "height": 1.0
    },
    "warehouseLocation": {
      "latitude": 54.4,
      "longitude": -32.7
    }
  }
]
```

Perform a transform:

```
try -d patterns \
  ex -j json_intput.json \
     -l to_json.xsl \
     -o json_output.json
```

This will create the following output:

```
python -m json.tool ./patterns/json_output.json

[
    {
        "id": 2,
        "name": "An ice sculpture",
        "price": 13.75,
        "tags": [
            "cold",
            "ice"
        ],
        "dimensions": {
            "length": 7,
            "width": 12,
            "height": 9.5
        },
        "warehouseLocation": {
            "latitude": -78.75,
            "longitude": 20.4
        }
    },
    {
        "id": 3,
        "name": "A blue mouse",
        "price": 25.5,
        "dimensions": {
            "length": 3.1,
            "width": 1,
            "height": 1
        },
        "warehouseLocation": {
            "latitude": 54.4,
            "longitude": -32.7
        }
    }
]
```

## JSON Transform Example 2

We would like to invert the hierarchy of a json document. In this example we
will take the data being oranized from faculty->courses->students->email and
transform it to email->courses.  We will also sort the output based on last name
and then the first name of each student, but we will keep the student's name out
of the final output.

Given this input:

```
[
  {
    "faculty": "humanities",
    "courses": [
      {
        "course": "English",
        "students": [
          {
            "first": "Mary",
            "last": "Smith",
            "email": "mary_smith@gmail.com"
          },
          {
            "first": "Ann",
            "last": "Jones",
            "email": "ann_jones@gmail.com"
          }
        ]
      },
      {
        "course": "History",
        "students": [
          {
            "first": "Ann",
            "last": "Jones",
            "email": "ann_jones@gmail.com"
          },
          {
            "first": "John",
            "last": "Taylor",
            "email": "john_taylor@gmail.com"
          }
        ]
      }
    ]
  },
  {
    "faculty": "science",
    "courses": [
      {
        "course": "Physics",
        "students": [
          {
            "first": "Anil",
            "last": "Singh",
            "email": "anil_singh@gmail.com"
          },
          {
            "first": "Amisha",
            "last": "Patel",
            "email": "amisha_patel@gmail.com"
          }
        ]
      },
      {
        "course": "Chemistry",
        "students": [
          {
            "first": "John",
            "last": "Taylor",
            "email": "john_taylor@gmail.com"
          },
          {
            "first": "Anil",
            "last": "Singh",
            "email": "anil_singh@gmail.com"
          }
        ]
      }
    ]
  }
]
```

Perform the tranform:

```
try -d patterns ex -x json_input2.json -l to_json2.xsl -o json_output2.json
```

This will produce the following output

```
python -m json.tool ./patterns/json_output2.json

[
  {
    "email": "ann_jones@gmail.com",
    "courses": [
      "English",
      "History"
    ]
  },
  {
    "email": "amisha_patel@gmail.com",
    "courses": [
      "Physics"
    ]
  },
  {
    "email": "anil_singh@gmail.com",
    "courses": [
      "Physics",
      "Chemistry"
    ]
  },
  {
    "email": "mary_smith@gmail.com",
    "courses": [
      "English"
    ]
  },
  {
    "email": "john_taylor@gmail.com",
    "courses": [
      "History",
      "Chemistry"
    ]
  }
]
```


