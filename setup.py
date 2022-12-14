from setuptools import setup

setup(
    name='xslt practice',
    version='0.0.1',
    py_modules=['cli'],
    install_requires=[
      'click',
      'black',
      'pyflakes',
      'lxml',
      'saxonpy',
      'PyYAML',
    ],
    entry_points='''
      [console_scripts]
      try=cli.cli:cli
    ''',
)
