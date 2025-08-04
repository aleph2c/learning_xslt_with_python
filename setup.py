from setuptools import setup, find_packages

setup(
    name="xslt-practice",
    version="0.0.4",
    packages=find_packages(),
    install_requires=[
        "requests",
        "click",
        "black",
        "pyflakes",
        "lxml",
        "markdown",
        "pygments",
        "saxonche >= 12.1.0",
        "PyYAML",
    ],
    entry_points={
        "console_scripts" : [
          "try=cli.cli:cli",
          "xslt=cli.cli:xslt",
          "mk=cli.cli:_markdown",
      ]
  },
)
