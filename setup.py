from setuptools import setup

setup(
    name="xslt practice",
    version="0.0.3",
    py_modules=["try_xslt_in_python"],
    install_requires=[
        "requests",
        "click",
        "black",
        "pyflakes",
        "lxml",
        "saxonche >= 12.1.0",
        "PyYAML",
    ],
    entry_points="""
      [console_scripts]
      try=cli.cli:cli
      xslt=cli.cli:xslt
    """,
)
