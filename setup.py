import os
import sys
import subprocess
from pathlib import Path
from zipfile import ZipFile
from setuptools import setup
from setuptools.command.install import install

# Thank you to:
#
# Michael Kay - the primary author of saxon
# Jenni Tennison - from writing a great XSLT book
# Apress - for providing the XSLT and other examples from Jenni's book
# David Challis - for showing how to build external c files in setup.py
# toddmo - for showing how to build saxonc and integrate it with python
# Armin Ronacher - for writing the click python CLI library

# Tested on WSL
SAXON_PACKAGE = 'libsaxon-HEC-setup64-v11.4'
SAXON_DIR = "libsaxon-HEC-11.4"
SAXON_ZIP_NAME = f'{SAXON_PACKAGE}.zip'
SAXON_URL = f'https://saxonica.com/download/{SAXON_ZIP_NAME}'



def path_to_this_python_install():
    result = None
    result_blob = subprocess.run(
      'which python', shell=True, capture_output=True, text=True
    )
    if result_blob.returncode == 0:
      result = Path(result_blob.stdout.rstrip())
    return result

def get_virtualenv_path():
    """Find path to installed compiled binaries"""
    result = None

    if hasattr(sys, 'real_prefix'):
        result = sys.prefix
    if hasattr(sys, 'base_prefix') and sys.base_prefix != sys.prefix:
        result = sys.prefix
    if 'conda' in sys.prefix:
        result =  sys.prefix
    if result is None:
        result_blob = subprocess.run(
          'which python', shell=True, capture_output=True, text=True
        )
        if result_blob.returncode == 0:
          result = Path(result_blob.stdout.rstrip()) / '..'
    return result

def get_saxonc_source():
    # do not put this at the top of the file or it will stop working
    # requests is installed by this file before this call is made
    import requests
    path_to_zip_dir = Path(get_virtualenv_path()) / 'source'
    path_to_zip_dir.mkdir(parents=True, exist_ok=True)
    path_to_zip = path_to_zip_dir / SAXON_ZIP_NAME
    if not path_to_zip.exists():
      response = requests.get(SAXON_URL)
      open(path_to_zip, "wb").write(response.content)
      with ZipFile(str(path_to_zip), 'r') as zip_object:
        zip_object.extractall(path=str(path_to_zip_dir))

def compile_and_install_software():
    """Call out to the system to compile/install the C software"""
    path_to_source = Path(get_virtualenv_path()) / 'source' / SAXON_DIR
    path_to_python_api = str(path_to_source / 'Saxon.C.API' / 'python-saxon')
    path_to_python_bin = str(path_to_this_python_install())
    cmd = f"{path_to_python_bin} saxon-setup.py build_ext -if"
    #subprocess.check_call(
    #    cmd, cwd=path_to_python_api, shell=True)
    path_to_lib = Path(sys.prefix) / 'lib'
    path_to_site_packages = [x for x in path_to_lib.iterdir() if path_to_lib][0] / 'site_package'
    # figure out how to link this into Jessica's environment
    import pdb; pdb.set_trace()

class CustomInstall(install):
    """Custom handler for the 'install' command."""
    def run(self):
        get_saxonc_source()
        compile_and_install_software()
        super().run()

setup(
    name='xslt practice',
    version='0.0.2',
    py_modules=['try_xslt_in_python'],
    install_requires=[
      'requests',
      'click',
      'black',
      'pyflakes',
      'lxml',
      'saxonpy',
      'PyYAML',
      'Cython',
    ],
    cmdclass={'install': CustomInstall},
    entry_points='''
      [console_scripts]
      try=cli.cli:cli
    ''',
)
