# Learning XSLT with Python

XSLT is an XML Lisp used to transform data from one form to another.  The XSLT
language contains the XPath tree mini-language within it.

## Quick Start

I created this repo to learn XSLT/XPath and how it can be integrated with
Python. It has a lazy CLI (it caches previous command inputs and uses them to
minimize typing).

Install this repo (see instructions below).

Now imagine you are trying to learn XSLT.  You have installed this repo's command
line tools and XSLT compilers (see below).  And now you find yourself working on
the chapter 7.4 exercize of Sal Mangano's XSLT Cookbook.
You transcribe his text-hierarchy XSLT example into ``./sal/ch07/text.hierarchy.xsl``.
Now you want to use this .xsl program to transform ``book.xml`` into
``text.hierarchy.txt``.

To:

- set the working directory as ``sal/ch07``, and
- transform the ``books.xml`` file, with the
- ``text.hierarchy.xsl`` XSLT program,
- while providing the ``text.hierachy.xsl`` program with an ``indent`` parameter equal to four spaces, to produce
- the ``text.hierarchy.txt`` file, and
- see the output verbosely (-v) printed to the screen:

```
try -d sal/ch07 ex \
  -x books.xml \
  -p saxon \
  -l text.hierarchy.xsl \
  --params "indent='    '" \
  -o text.hieracrhy.txt \
  -v
```

Since you are learning, you probably made some mistakes.  You read the resulting
XSLT compiler errors and make an attempt to fix your program.  Since the ``try``
command caches its inputs you don't have to retype a long command to re-try your
``.xsl`` XSLT program, instead you type:

```
try ex -v
```

Now you can cycle between trying to fix your program and running the XSLT 3.0
compiler until your program does what you want.

## Context

XSLT is a language used to convert the data of an XML/JSON file, into another
format.  XSLT stands for eXtensible Stylesheet Language Transforms. XSLT is very
flexible; you can convert your XML/JSON data into HTML files, SVG pictures or
Python programs, or any other file format.

XSLT is much more powerful than most of the newer templating techniques, such as
Python's Jinja2 library.  Jinja2 is a great tool for transforming small data
structures, while XSLT can be used for arbitrarily large data sets or data
streams.

This is because XSLT is a fully functional programming language (it's a Lisp)
that contains the powerful XPath/XQuery tree-languages and, within XPath, there
is support for regular expressions and custom function construction. To use
Jinja2, you have to have a complete understanding of the data you feed your
template, but XSLT is declarative, you tell it what you want, and it figures out
how to give it to you.  The XSLT programs react to the data you feed them in a
kind of event-driven way.

XSLT compilers have been compiled from XSLT.  XSLT is an XML dialect.  This
means that all XSLT programs are pre-pickled.  They are serializable by default,
your XSLT program is data and your XSLT data is a program.  XSLT is an inherent
meta-programming language, it transforms data, and it is data, so it can
trivially transform itself into new forms.

Python does not come with a modern XSLT parser, but you can install external
libraries that integrate the XSLT language into Python. The XSLT standard is
currently at version "3.0", but most open-source tools only support version
"1.0".

An XSLT 3.0 book has not yet been published, but Altova has published a nice
[XPath 3.0/3.1 training resource](https://www.altova.com/training/xpath3), and there
are lots of XSLT 2.0 books.

If your editor uses snippet's, like SirVer's outstanding UltiSnips technology
for Vim, get yourself ready to build up a custom, intermediary shorthand between
your fingers and the XSLT language.  Don't copy someone else's [snippet library](https://github.com/aleph2c/.vim/blob/master/snippets/xslt.snippets),
build your own as you read through the XSLT books. Leave programming notes as
comments in your snippets work, you will reference these notes while you improve
and tune your snippets over time.  The UltiSnips library provides a short-cut to
get to your snippet files from your XSLT file.  Use this, or an analogous
feature in your development environment, to constantly jump back and forth
between your XSLT and your custom snippet work.

XSLT is an XML, so it is necessarily verbose.  This is the cost of having a data
language that can run against itself.  But, if you have your development
environment augmented with your snippets, and you are actively working on the
program to write your program, you will be able to swiftly type-in and debug the
hundreds of XSLT programs you will encounter in your training.  This will keep
your mind actively engaged while dealing with the new syntax, as you work through
the manuals.

If I were to re-start my training, I would begin with Michiel van Otegem's teach
yourself XSLT in 21 days.  It is very well written.  Pay special attention to
chapter 3 which explains the XPath tree language using diagrams.  While you are
wrestling with these XPath tree query concepts, use the ``try xpath`` command
provided by this repo (pictures and examples can be seen near the end of this
document).  Within each chapter, build up your snippet library, and type out
most of the book's programs by hand -- this will be easy to do with your
snippets.  Get used to validating your programs with the command line, go back
and troubleshoot your issues.  You are learning a workflow, a new language and
whatever snippet technology you are using.  Place your snippets under revision
control and make sure you can quickly access them in any working environment.

To get a sense of what the XSLT compilers are doing, play with 
[Evan Lenz's XSLT-visualizer](https://github.com/evanlenz/xslt-visualizer).
This will show you how the XSLT event manager reacts to the data in your XML
files and how it calls out to your various templates based on their XPath match
expressions.

Then get a copy of "Beginning XSLT 2.0 From Novice to Professional", by Jeni
Tennison.  This isn't an easy book to read as a beginner, but at this point you
will have a decent understanding of XSLT 1.0 from which you can infer over the
gaps in her explanations.

After that, I recommend getting a copy of "XSLT 2.0 and XPath 2.0 Programmer's
Reference 4th Edition" by Michael Kay, and work through Chapter 17: Stylesheet
Design Patterns.  If you would like to learn how to use the new XML-to-JSON,
JSON-to-XML and JSON transform features of XSLT 3.0, read [Transforming JSON
using XSLT 3.0](https://www.saxonica.com/papers/xmlprague-2016mhk.pdf), by
Michael Kay.  There is supporting example code for some of these JSON transforms
and the pattern's code in the pattern's folder of this repo. (see the docs
below) To become competent, get a copy of Sal Mangano's XSLT Cookbook, then work
through his examples as lab work.  To learn XSLT 3.0 read Martin Honnen's
[XSLT 3.0 by example blog](https://xslt-3-by-example.blogspot.com/), and read
through [his help on stack overflow](https://stackoverflow.com/users/252228/martin-honnen) and 
his [gists on github](https://gist.github.com/martin-honnen).

XSLT is a powerful and robust technology.  It has been actively developed for
almost 25 years, and it has been responsive to its community's feedback.  This
has been possible because Michael Kay has created a company called Saxonica,
where he can get paid to develop the language while also working on open
standards boards and writing books about XSLT/XPath.  He offers up part of his
software as open source, and makes his money by licensing XSLT compilers that
have more features.  His open-source software acts as a loss-leader for his
business.   He and his developers are active on StackOverflow, manage their bugs
using openly available bug trackers and are in constant contact with their
users.  It's worth learning XSLT.  It is also worth listening to Michael for
many other reasons, such as how to have a good life as a computer scientist, how
to build a software business, how to manage a committee, and how to follow
long-term plans.

As of Jan 13 2023, Saxonica, has released an open-source version of the XSLT
programming language compiler and parser (Mozilla Public Licence) as a Python
pip package.  This package is called ``saxonche``, and it supports XSLT 3.0,
XPath 3.1, XQuery 3.1, XSD 1.1 and has a Schema Validator processor, based on
SaxonC-HE 12.0.  The ``saxconche`` python library uses ctypes to build a SaxonC
XSLT compiler and run it within Python.  The SaxonC project is a port of the
Saxon Java software to C, so it can be used with C/C++, PHP and Python.  But,
before you get excited, know that you should avoid this library for production:

- The ``saxonche`` library's documentation is wrong.  If you try to follow their
  instructions your program won't run.  These docs were copied and pasted from
  the ``saxonpy`` library, written by non-saxonica people.  The ``saxonpy``
  library was build to support an earlier version of the saxon api.  If you only
  need to run your python/XSLT programs in Linux use the ``saxonpy`` library.
  If you need to run your code on a mac, you are stuck with ``saxonche``.

- The ``saxonche`` library also causes StackOverFlow errors when you try and
  instantiate it within certain Python environments, like Flask or in a thread.
  This bug is known, and it has been given a "low" priority by Saxonica.  So,
  you might want to stay away from the ``saxoniche`` project for production
  until it has stabilized.  But if you are willing to take a risk, there is some
  code at the end of this doc that demonstrates how to call ``saxonche`` in a
  python thread and not have it crash (I built it through guess-work).

- If things weren't bad enough, error messages from incorrect xsl compilations
  are turned off by default in ``saxonche``.  It took me a while to understand
  that saxon produces nice compiler errors (Michael Kay talks about this in his
  interviews), but if you use ``saxonche`` all you see is "there was a compiler
  error" when you make a mistake.  This isn't that helpful if you are trying to
  learn XSLT.

The developer who is working on these bugs is buried with other work (at the
time of this writing he has about 96 bugs in his queue and he has spent 2 years
on his highest priority bug -- so don't hold your breath).

This is one example, of many, of how the XSLT community lacks empathy for
beginners.  When their documentation is written correctly, it is excessively
formal and uses domain specific terminology to explain itself; it is written for
them, not for someone trying to understand something new.  There aren't enough
examples and this is an unforced error.

It is rational to choose an inferior data transformation technology, because it
is cheaper to understand than XSLT.  Saxonica and the other XML companies are
leaving a lot of money on the table because of their snobbery.  They would do
well to invest in some jargonaughts to bring their concepts down from the
heights (Martin Honnen would be perfect for this), and write lots of working
examples.  XSLT should have easily won as a data-transformation technology.
Ansible/Jinja2/Erb/JSON/YAML should not exist.  I predict that someone will
build a wrapper-business/compiler around XSLT and take all the money that is
currently sitting as potential energy.  (like what Docker did to Linux
containerization or Elixir is doing to Erlang).

Also, to learn XSLT 3.0 you need to be able to see its xsl compiler errors.  As I said
before, ``saxonche`` isn't documented.  I spent a long time trying to figure out
how to get compiler errors working with a threadable ``saxonche`` and eventually
decided to try something else.  I downloaded the 
[zipped java version of saxon](https://github.com/Saxonica/Saxon-HE/blob/be4dd844d935d8d0ef09748490448624abe3c66b/12/source/saxon12-0source.zip),
decompressed it and ran it's command line tool:

```
  java -jar <path to saxon-he-12.0.jar> \
   -xsl:<path to your xsl file> \
   -s:<path to your xml file>
```

By default this java-project produces XSLT compiler errors so you can debug your
``.xsl`` programs.

The command line tool used in this project was adjusted to call out to Java when
``saxonche`` detects an XSLT compiler error.  If you want to use this feature,
you will have to have java installed on your system.  See the installation
instructions below for details:

# Installation of two XSLT processors and a Supporting CLI

To install the CLI, the two XSLT python parsers, and the example files:

```bash
git clone git@github.com:aleph2c/leaning_xslt.git
cd learning_xslt
python3 -m venv venv
pip install --upgrade pip
pip install -e .
source ./venv/bin/activate
# see note:
xslt install-compile-errors
```

**Note:**
The ``saxonche`` pip package used by this repo will not output XSLT compiler errors,
but if you want to see them (which you do) this command will fix the problem:

```bash
xslt install-compile-errors
```

This will download the
[zipped java version of saxon](https://github.com/Saxonica/Saxon-HE/blob/be4dd844d935d8d0ef09748490448624abe3c66b/12/source/saxon12-0source.zip)
and decompress its contents in ``./java/``.  With this jar installed the ``try``
cli tool will call out to java when the ``saxoniche`` library fails to compile
your ``.xsl``.  It will rerun the compilation using the jar and output the XSLT
compiler error messages to the terminal.  This will give you the feedback
required to debug your program.

# Running Examples

The repo installs a ``try`` command.  To see how it works:

```text
try --help
Usage: try [OPTIONS] COMMAND [ARGS]...

    Try an XSLT/XPath example and cache the command

Options:
  -d, --dir TEXT  Set the exercise directory
  --help          Show this message and exit.

  Commands:
    cache  View your command cache
    ex     Run an exercise
    xpath  Test an XPath query on a given xml doc and context

```

## How to Run Specific Examples

To see how to run an exercise:

```text
try ex --help
Usage: try ex [OPTIONS]

  Run an exercise:
  
  try -d sal/ch07 ex \
    -x books.xml \
    -l text.hierarchy.xsl \
    -params "indent='    ',param2='some_value'" \
    -o text.hierarchy.txt

Options:
  -n, --node-name TEXT    Set the node name
  -x, --xml TEXT          Set the xml file
  -j, --json TEXT         Set the json file (saxon)
  -l, --xls TEXT          Set the xls file
  -p, --processor TEXT    Set the processor (lxml|saxon)
  -o, --output_file TEXT  Set the output file name
  --params TEXT           Set the optional parameter(s)
  -v, --verbose           Run in verbose mode?
  --help                  Show this message and exit.
```

To run an example:

```
try -d jenni/ch2_html_from_xml ex -x TVGuide2.xml -l TVGuide2.xsl -o TVGuide2.html -p lxml -v
# a lot of XML

ran the lxml process
```

To see your cache:

```
try cache
{'context': '', 'home_dir': 'jenni/home/scott/xslt/ch3_templates',
'output_file_name': 'TVGuide2.html', 'processor': 'lxml', 
'xls_file_name': 'TVGuide2.xsl', 'xml_file_name': 'TVGuide2.xml'}
```

To run the same exercise again:

```
try ex -v
# a lot of XML

ran the lxml processor
```

To try the same example with the saxon processor, you just have to tell the
``try`` command you want to use the ``saxon`` processor, if the other options
are not specified it will use your cached options:

```
try ex -p saxon -v
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
python -m json.tool ./michael/json_input.json

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

Perform a transform (saxonpy works, saxonche stackoverflow):

```
# this will crash with saxonche due to stackoverflow errors
# but it ran with saxonpy

try -d michael \
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

Perform the transform (saxonpy works, saxonche stackoverflow):

```
try -d michael \
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

# Integrating XSLT 3.0 with Python in the main thread

The [saxonche documentation](https://pypi.org/project/saxonche/) is wrong.  It is a copy of the docs from the [saxonpy project](https://github.com/tennom/saxonpy), which is based on SaxonC-HE 11.4 and not SaxonC-HE 12.0.  If you want to get your python code to parse XML/JSON/XSLT and output XML/JSON using ``saxonche`` consider the following:

```python

from pathlib import Path
from saxonche import PySaxonProcessor

def transform_with_saxonche(
    self, home_dir, xml_file_name, xsl_file_name, output_file_name
):
    # Don't use the PySaxonProcess context manager if you are calling saxonche
    # over and over again within your program.  Instead build the proc and
    # xsltproc once, and reference them when you need them.  If you don't do
    # this, you will get strange memory errors:
    # "JNI_CreateJavaVM() failed with result: -5" (last seen in saxonc-he 11.4)
    #
    # Example of how to build the proc and xsltproc once per program invocation:
    #
    # from functools import cache as cached
    # @cached
    # def get_cached_procs_from(*args):
    #   proc = PySaxonProcessor(licence=False)
    #   xsltproc = proc.new_xslt30_processor()
    #   return proc, xsltproc
    #
    # def transform_with_saxonche(...)
    #   proc, xsltproc = get_cached_procs_from(PySaxonProcessor)
    #   # ...

    # If you are running your transforms once per program invocation
    # you can use the PySaxonProcessor context manager.  Don't be fooled, given
    # that this context manager doesn't clean up memory when it's done, it's not
    # really behaving like a Python context manager. (see the memory bug
    # mentioned above)
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

# Integrating XSLT 3.0 with Multithreaded Python

The [saxonche library will throw StackOverFlow errors](https://saxonica.plan.io/issues/5787) when you try to instantiate it in
certain Python environments (Flask, or in a thread, etc.).  This bug has been given a "low" priority by
Saxonica.  This means this library is not production ready.  If you want XSLT in
production, use XSLT 1.0 and lxml:

```python
# This doesn't cause StackOverFlow crashes and, its fully documented 
# and its documentation isn't wrong
import lxml
```

But if you are willing to accept some risk, here is a working demo of Python thread
performing XSLT transforms using saxonche without causing StackOverFlows:

```python
import os
import shutil
from uuid import uuid1
from pathlib import Path

from queue import Queue
from threading import Thread
from threading import Lock
from collections import namedtuple
from threading import Event as ThreadEvent

from saxonche import PySaxonProcessor

proc_globals = {}
proc_globals_lock = Lock()
ValidateXmlPath = (Path(__file__).parent / "validate_xml.xsl").resolve()
SaxonPayload = namedtuple(
    "SaxonPayload",
    ["home_dir", "xml_file_name", "xsl_file_name", "output_file_name", "verbose"],
)

def __initialize_saxon(*args):
    """The PySaxonProcessor proc and the xslt30 proc should only be made once"""

    if "proc" in proc_globals:
        proc = proc_globals["proc"]
        xsltproc = proc_globals["xsltproc"]
    else:
        proc = PySaxonProcessor(license=False)
        xsltproc = proc.new_xslt30_processor()
        proc_globals["proc"] = proc
        proc_globals["xsltproc"] = xsltproc

    return proc, xsltproc

# call this from the main thread at least once
proc_globals_lock.acquire()
__initialize_saxon()
proc_globals_lock.release()


def __saxon_xslt30_transform(
    lock, home_dir, xml_file_name, xsl_file_name, output_file_name, verbose=False
):

    result = ""

    lock.acquire()
    proc, xsltproc = __initialize_saxon()

    home_path = Path(home_dir)
    xml_file_path = Path(home_dir) / xml_file_name
    xsl_file_path = Path(home_dir) / xsl_file_name
    output_file_path = Path(home_dir) / output_file_name

    if not home_path.exists():
        result = f"{home_dir} doesn't exist"
        lock.release()
        return result

    if not xml_file_path.exists():
        result = f"xml_file_name: {xml_file_path} doesn't exist"
        lock.release()
        return result

    if not (Path(home_dir) / xsl_file_name).exists():
        result = f"xsl_file_name: {xsl_file_path} doesn't exist"
        lock.release()
        return result

    stashed_output_file_path = None
    if xml_file_path == output_file_path:
        temp_output_path = Path(output_file_path).parent / (str(uuid1())[0:7] + ".tmp")
        stashed_output_file_path = output_file_path
        output_file_path = temp_output_path

    if Path(xml_file_name).suffix == ".json":
        json_input_param = proc.make_string_value(str(home_dir / xml_file_name))
        xsltproc.set_parameter("json_input_filename", json_input_param)

    _exec = xsltproc.compile_stylesheet(stylesheet_file=str(xsl_file_path))
    if _exec is None:
        error = f"{xsltproc.error_message}"
        xsltproc.exception_clear()
        lock.release()
        raise RuntimeError(error)

    if Path(xml_file_name).suffix == ".json":
        # it's a mystery why we have to use call_template_returning_file
        # and not make_string_value (this isn't documented anywhere)
        _exec.call_template_returning_file(output_file=str(output_file_path))
        if stashed_output_file_path:
            shutil.copy(src=output_file_path, dst=stashed_output_file_path)
            os.remove(output_file_path)
            output_file_path = stashed_output_file_path
        del _exec
    else:
        # add a test_param to validate saxon is working
        test_param = proc.make_string_value(str(xml_file_path))
        _exec.set_parameter("test_param", test_param)
        _exec.set_initial_match_selection(file_name=str(xml_file_path))
        _exec.apply_templates_returning_file(output_file=str(output_file_path))
        if _exec.exception_occurred:
            saxon_error = f"{_exec.error_message}"
            _exec.exception_clear()
            lock.release()
            raise RuntimeError(saxon_error)

        if stashed_output_file_path:
            shutil.copy(src=output_file_path, dst=stashed_output_file_path)
            os.remove(output_file_path)
            output_file_path = stashed_output_file_path

        # if our output path is an .xml file, run a post-transform-test to see
        # if the provided xsl_file_name created valid xml
        if output_file_path.suffix == '.xml':
            xsl_post_test_path = ValidateXmlPath

            if not (xsl_post_test_path).exists():
                result = f"xsl_file_name:\n{xsl_post_test_path}\ndoesn't exist"
                lock.release()
                return result

            _exec = xsltproc.compile_stylesheet(stylesheet_file=str(xsl_post_test_path))

            _exec.transform_to_string(
                source_file=str(output_file_path),
            )
            if _exec.exception_occurred:
                saxon_error = f"{_exec.error_message}"
                _exec.exception_clear()
                lock.release()
                raise RuntimeError(saxon_error)
            del _exec

    if verbose:
        with open(home_dir / output_file_name, "r") as fp:
            result = fp.read()
    lock.release()
    return result

def thread_runner(lock, task_event, input_queue, output_queue):

    # this will cause the StackOverFlow if it isn't first called
    # in the main thread
    lock.acquire()
    __initialize_saxon()
    lock.release()

    while task_event.is_set():
        q = input_queue.get(block=True)
        input_queue.task_done()
        result = __saxon_xslt30_transform(
            lock,
            home_dir=q.home_dir,
            xml_file_name=q.xml_file_name,
            xsl_file_name=q.xsl_file_name,
            output_file_name=q.output_file_name,
            verbose=q.verbose,
        )
        output_queue.put(result)

# this function demontrates how to create a thread, communicate with it and stop it.
def saxon_xslt30_transform(
    home_dir, xml_file_name, xsl_file_name, output_file_name, verbose=False
):
    global proc_globals_lock

    input_queue = Queue()
    output_queue = Queue()

    payload = SaxonPayload(
        home_dir=home_dir,
        xml_file_name=xml_file_name,
        xsl_file_name=xsl_file_name,
        output_file_name=output_file_name,
        verbose=verbose,
    )

    # The task event is a flag, which when:
    # - set: means the thread should run
    # - cleared: means the thread should stop and exit
    task_event = ThreadEvent()
    task_event.set()

    thread = Thread(
        target=thread_runner,
        args=(proc_globals_lock, task_event, input_queue, output_queue),
        daemon=True,
    )
    # start the thread
    thread.start()
    # give something to the thread
    input_queue.put(payload)
    # wait for the thread to react
    input_queue.join()
    # wait for the thread's output
    result = output_queue.get(block=True)
    output_queue.task_done()

    # kill the thread
    task_event.clear()

    return result

if __name__ == '__main__':

    # adjust this to point to the directory containing you files
    home_dir = (Path(__file__).parent / ".." / "ch3_templates").resolve()
    xml_file_name = "HelloWorld.xml"
    xsl_file_name = "HelloWorld.xsl"
    output_file_name = "HelloWorld.html"

    result = saxon_xslt30_transform(
        home_dir, xml_file_name, xsl_file_name, output_file_name, verbose=True
    )
    print(result)

```

# Testing XPath

Here we run an XPath expression against the ``menu.xml`` file in the
``otegem/ch03`` directory, then cache the command:

```
try -d ./otegem/ch03 xpath -x menus.xml -c "/" -p "menu"
context: /
<menu>
  <appetizers title="Work up an Appetite">
    <dish id="1" price="8.95">Crab Cakes</dish>
    <dish id="2" price="9.95">Jumbo Prawns</dish>
    <dish id="3" price="10.95">Smoked Salmon and Avocado Quesadilla</dish>
    <dish id="4" price="6.95">Caesar Salad</dish>
  </appetizers>
  <entrees title="Chow Time!">
    <dish id="5" price="19.95">Grilled Salmon</dish>
    <dish id="6" price="17.95">Seafood Pasta</dish>
    <dish id="7" price="16.95">Linguini al Pesto</dish>
    <dish id="8" price="18.95">Rack of Lamb</dish>
    <dish id="9" price="16.95">Ribs and Wings</dish>
  </entrees>
  <desserts title="To Top It Off">
    <dish id="10" price="6.95">Dame Blanche</dish>
    <dish id="11" price="5.95">Chocolate Mousse</dish>
    <dish id="12" price="6.95">Banana Split</dish>
  </desserts>
</menu>
```

To run the next xpath query against the same file:

```
try xpath -p "(//dish)[6]"
context: /
<dish id="6" price="17.95">Seafood Past</dish>

try xpath -c "/" -p "/menu/entrees/*/text()"
context: /
Grilled Salmon
Seafood Pasta
Linguini al Pestro
Rack of Lamb
Ribs and Wings

```

You would use the context to simulate how a template matching an XPath pattern
would behave.  Suppose you were trying to see what line 12 of the following
would output:

```
 1  <?xml version="1.0" encoding="UTF-8"?>
 2  <xsl:stylesheet version="1.0"
 3   xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 4    <xsl: tempate match="/">
 5      <xsl:apply-templates />
 6    </xsl:template>
 7    <xsl: tempate match="/menu/entrees">
 8      Entrees:
 9      <xsl:apply-templates />
10    </xsl:template>
11    <xsl:template match="dish">
12      <xsl:value-of select="text" />
13    </xsl:template>
13  </xsl:stylesheet>
```

We could simulate what would be expressed at line 12 by setting the context to
``/menu/entrees``:

```
try xpath -v
3.1

try xpath -c "/menu/entrees" -p "dish/text()[1]"
context: /menu/entrees
Grilled Salmon
```

# Testing XPath Axis Features

This picture will help you understand how the axis feature works in XPath:

![xpath 2](patterns/xpath_2.svg)

This is how the above picture can be represented in XML (see ``patterns/axis_testing.xml``):

```
try -d patterns/ xpath -x"axis_testing.xml" -c"/" -p"*"
context: /
<A id="1">
  <B id="2">
    <C id="3"/>
    <D id="4"/>
    <E id="5">
      <H id="8">
        <M id="13"/>
      </H>
      <I id="9"/>
      <J id="10">
        <N id="14"/>
        <O id="15">
          <T id="20"/>
          <U id="21"/>
        </O>
        <P id="16"/>
        <Q id="17"/>
        <R id="18">
          <V id="22"/>
          <W id="23"/>
        </R>
      </J>
      <K id="11"/>
      <L id="12">
        <S id="19"/>
      </L>
    </E>
    <F id="6"/>
    <G id="7"/>
  </B>
</A>
```

Now let's set ``J`` as the node context and perform our first axis experiment:

```
try xpath -c "//J" -p "self::*/name()"
context: //J
J
```

Let's look to see how the ``following::`` axis works, we search the "following" axis for any node name (``*``) 
and return the matched node names:

```
try xpath -p "following::*/name()"
"K"
"L"
"S"
"F"
"G"

try xpath -p "(following::* union preceding::*)/name()"
"C"
"D"
"H"
"M"
"I"
"K"
"L"
"S"
"F"
"G"
```

# Useful links

- [saxonche docs are wrong](https://saxonica.plan.io/issues/5842)
- [saxonche fails with stackoverflow errors](https://saxonica.plan.io/issues/5787)
- [interview with Michael Kay](https://www.youtube.com/watch?v=2Zt9oJtFKGw)
- [XPath 3.0/3.1 training resource](https://www.altova.com/training/xpath3),
- [XSLT-visualizer](https://github.com/evanlenz/xslt-visualizer)
- [XSLT 3.0 Prague 2016 resources](https://github.com/Saxonica/Prague2016)
- [XSLT XPath Tutorial by arbitrarytechnology](https://www.youtube.com/watch?v=WggVR4YI5oI)
- [Saxon XSLT 3.0 JSON Whitepaper](https://www.saxonica.com/papers/xmlprague-2016mhk.pdf)
- [What's new in XSLT 3.0 and XPath 3.1](http://dh.obdurodon.org/xslt3.xhtml)
- [xidel: Xidel is a command line tool to download and extract data from HTML/XML pages as well as JSON APIs](https://www.videlibri.de/xidel.html)
- [XML/XSLT links on Digital humanities](http://dh.obdurodon.org/)
- [XSLT elements](https://www.saxonica.com/documentation12/#!xsl-elements)
- [Martin Honnen's Understanding how to use maps](https://stackoverflow.com/a/48051099)
- [Martin Honnen's XSLT 3.0 by example blog](https://xslt-3-by-example.blogspot.com/)
- [Martin Honnen's XSLT github gists](https://gist.github.com/martin-honnen)
- [XSL 3.0 Specification](https://www.w3.org/TR/xslt-30)
