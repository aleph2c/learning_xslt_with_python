# Learning XSLT

XSLT is a language used to convert the data of an XML file, into another format.
XSLT stands for eXtensible Stylesheet Language Transforms. XSLT is very
flexible; you can convert your XML/JSON data into HTML files, SVGs or Python
programs, or any other file format.

XSLT is significantly more powerful than a lot of the newer templating
techniques, such as Python's Jinja2 library. This is because XSLT is a fully
functional programming language that contains the powerful XPath
mini-tree-searching language and, within XPath, there is support for regular
expressions and custom function construction. To use Jinja2, you have to have a
complete understanding of the data you feed your template, but XSLT is
declarative, you tell it what you want, and it figures out how to give it to
you.

Jinja2 is a great tool for transforming small data structures, while XSLT can be
used for arbitrarily large data sets or data streams. XSLT software has been
compiled from XSLT.

XSLT is an XML dialect, and it's an XML lisp. It is very difficult to learn XML
from a book; If you are transcribing the book's examples, then trying to run
those files through your python program, most of your time will be spent
debugging, and not learning. XML books have a way of bleeding-away will-power
because XML syntax is hard to look at.

I created this repo to learn XSLT and how it can be integrated with Python. I
wanted something that had a lazy CLI (caches previous command inputs and uses
them to minimize typing), to create an experimental environment to try the
different XSLT parsers from program examples included from three training
sources.

Python does not come with an XSLT parser, but you can install external libraries
that integrate the XSLT language into Python. The XSLT standard is currently at
version "3.0", but most open-source tools only support version "1.0".

To follow along, go and get a copy of "Beginning XSLT 2.0 From Novice to
Professional" by Jeni Tennison, clone this repo and install the command line
tools and the XSLT parsers (see below).  After that, I recommend getting a copy
of "XSLT 2.0 and XPath 2.0 Programmer's Reference 4th Edition" by Michael Kay,
and work through Chapter 17: Stylesheet Design Patterns.  If you would like to
learn how to use the new XML-to-JSON, JSON-to-XML and JSON transform features of XSLT 3.0, read
[Transforming JSON using XSLT 3.0](https://www.saxonica.com/papers/xmlprague-2016mhk.pdf),
by Michael Kay.  There is supporting example code for some of these JSON transforms 
and the pattern's code in the pattern's folder of this repo. (see the docs below)

An XSLT 3.0 book has not yet been published.

As of Jan 13 2023, Michael Kay's company, Saxonica, has released an open-source
version of the XSLT programming language compiler and parser (Mozilla Public
Licence) as a Python pip package.  This package is called ``saxonche``, and it
supports XSLT 3.0, XQuery 3.1 and has a Schema Validator processor, based on
SaxonC-HE 12.0.  The SaxonC project is a port of the Saxon Java software to C,
so it can be used with C/C++, PHP and Python.  (see the docs below on how to use
saxonche with Python)

# Installation of two XSLT processors and a Supporting CLI

To install the CLI, the two XSLT python parsers, and the example files:

```bash
git clone git@github.com:aleph2c/leaning_xslt.git
cd learning_xslt
python3 -m venv venv
pip install --upgrade pip
pip install -e .
source ./venv/bin/activate
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
``try`` command you want to use the ``saxon`` processor, if the other options
are not specified it will use your cached options:

```
try ex -p saxon
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
python -m json.tool ./patterns/json_input.json

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
  ex -j json_input.json \
     -l to_json.xsl \
     -o json_output.json \
     -p saxon
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
will take the data being organized from faculty->courses->students->email and
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

Perform the transform:

```
try -d patterns \
  ex -x json_input2.json \
     -l to_json2.xsl \
     -o json_output2.json \
     -p saxon

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

# Intergrating XSLT 3.0 with Python

The [saxonche documentation](https://pypi.org/project/saxonche/) is wrong.  It is a copy of the docs from the [saxonpy project](https://github.com/tennom/saxonpy), which is based on SaxonC-HE 11.4 and not SaxonC-HE 12.0.  If you want to get your python code to parse XML/JSON/XSLT and output XML/JSON using ``saxonche`` consider the following:

```python

from pathlib import Path
from saxonche import PySaxonProcessor

def transform_with_saxonche(
    self, home_dir, xml_file_name, xsl_file_name, output_file_name
):
    # Don't use the context manager if you are calling saxonica over and
    # over again with your program.  Instead build the proc and
    # xsltproc once, and reference them when you need them.  If you don't do
    # this, you will get strange memory errors. (last seen in version 11.4)
    #
    # Example of building proc and xsltproc once and reusing them:
    #
    # saxonica_globals = {}
    #
    # def transform_with_saxonche(...)
    #   if 'proc' not in saxonica_globals:
    #     proc = PySaxonProcessor(license=False)
    #     xsltproc = proc.new_xslt30_processor()
    #     saxonica_globals['proc'] = proc
    #     saxonica_globals['xsltproc'] = xsltproc
    #   else:
    #     proc = saxonica_globals['proc']
    #     xsltproc = saxonica_globals['xsltproc']
    #     # ...

    # If you are running your transforms once per program invocation
    # you can use the PySaxonProcessor context manager.
    with PySaxonProcessor(license=False) as proc:
        xsltproc = proc.new_xslt30_processor()
        xsltproc.set_cwd(str(home_dir))

        if not Path(home_dir).exists():
            print(f"{home_dir} doesn't exist")
            exit(1)

        if not (Path(home_dir) / xml_file_name).exists():
            print(
                f"xml_file_name: {str(Path(home_dir) / xml_file_name)} doesn't exist"
            )
            exit(1)

        if not (Path(home_dir) / xsl_file_name).exists():
            print(
                f"xsl_file_name: {str(Path(home_dir) / xsl_file_name)} doesn't exist"
            )
            exit(1)

        if Path(xml_file_name).suffix == ".json":
            json_input_param = proc.make_string_value(str(home_dir / xml_file_name))
            xsltproc.set_parameter("json_input_filename", json_input_param)

        stylesheet_file = str(Path(home_dir) / xsl_file_name)
        _exec = xsltproc.compile_stylesheet(
            stylesheet_file=stylesheet_file,
        )
        if _exec is None:
            print("saxonica failed")
            exit(1)

        if Path(xml_file_name).suffix == ".json":
            # it's a mystery why we have to use call_template_returning_file
            # and not make_string_value (this isn't documented anywhere)
            _exec.call_template_returning_file(output_file=output_file_name)
        else:
            # add a test_param to validate saxon is working
            test_param = proc.make_string_value(str(home_dir / xml_file_name))
            _exec.set_parameter("test_param", test_param)
            _exec.set_initial_match_selection(file_name=xml_file_name)
            _exec.apply_templates_returning_file(output_file=output_file_name)

        with open(home_dir / output_file_name, "r") as fp:
            contents = fp.read()
            print(contents)

```

# Useful links

- [XSLT XPath Tutorial by arbitrarytechnology](https://www.youtube.com/watch?v=WggVR4YI5oI)
- [Building saxonC-HE from source](https://stackoverflow.com/a/74017370)
- [Dealing with recursion depth](https://stackoverflow.com/questions/5435881/xslt-processing-recursion-depth)
- [White space article for XSLT 3.0](https://blogs.sap.com/2020/02/26/thinking-in-xslt-filtering-xml-elements/)
- [Jeni's white space comments on SO](https://stackoverflow.com/a/185048)
- [XSLT 3.0 Prague 2016 resources](https://github.com/Saxonica/Prague2016)
- [Saxon XSLT 3.0 JSON Whitepaper](https://www.saxonica.com/papers/xmlprague-2016mhk.pdf)
