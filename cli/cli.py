import os
import yaml
import pprint
import shutil
import zipfile
import subprocess
from uuid import uuid1
from pathlib import Path
from functools import partial
from contextlib import contextmanager

from queue import Queue
from threading import Thread
from threading import Lock
from collections import namedtuple
from threading import Event as ThreadEvent


import click
import requests
from lxml import etree
from saxonche import PySaxonProcessor


def pp(item):
    pprint.pprint(item)


PathToDefault = (Path(__file__).parent / ".." / "ch3_templates").resolve()

# SaxonC/Saxonche is currently unreliable: Issues StackOverFlow errors using
# Python on a server: https://saxonica.plan.io/issues/5787
#
# Through experimentation I found that the following works:
#   - Create these in the main thread:
#       - PySaxonProcessor(licence=False) => proc
#       - proc.new_xslt30_processor() => xsltproc
#   - Store the proc/xsltproc in a global, DO NOT use functools.cache or you will
#     get a StackOverFlow
#   - Create a thread lock to defend the proc and xsltproc from being used by
#     two threads at the same time
#

proc_globals = {}
proc_globals_lock = Lock()
ValidateXmlPath = (Path(__file__).parent / "validate_xml.xsl").resolve()
SaxonPayload = namedtuple(
    "SaxonPayload",
    [
        "home_dir",
        "xml_file_name",
        "xsl_file_name",
        "output_file_name",
        "params",
        "verbose",
    ],
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


proc_globals_lock.acquire()
__initialize_saxon()
proc_globals_lock.release()


def call_out_to_java_to_get_saxon_compile_errors(
    home_dir, xml_file_name, xsl_file_name
):
    """having spent hours dealing with undocumented saxonche, I gave up and used the java version instead"""
    xml_file_path_str = str((Path(home_dir) / xml_file_name).resolve())
    xsl_file_path_str = str((Path(home_dir) / xsl_file_name).resolve())
    run_path = (Path(__file__).parent / "..").resolve()
    run_path_str = str(run_path)
    saxon_java_path = run_path / "java" / "saxon-he-12.0.jar"
    saxon_java_path_str = str(saxon_java_path)
    output_obj = None
    if not saxon_java_path.exists():
        feedback0 = "saxonche isn't documented, so there is no way to get saxon compiler errors"
        feedback1 = f"download saxon-he-12.0.jar and place it in {saxon_java_path_str}"
        feedback2 = "saxon-he-12.0.jar can be used to generate compiler messages"
        click.echo(feedback0)
        click.echo(feedback1)
        click.echo(feedback2)
    else:
        cmd = f"java -jar '{saxon_java_path_str}' -xsl:'{xsl_file_path_str}' -s:'{xml_file_path_str}'"
        output_obj = subprocess.run(
            cmd, cwd=run_path_str, shell=True, capture_output=True, text=True
        )
    return output_obj


def __saxon_xslt30_transform(
    lock,
    home_dir,
    xml_file_name,
    xsl_file_name,
    output_file_name,
    params=None,
    verbose=False,
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

    exception_occurred = True
    try:
      _exec = xsltproc.compile_stylesheet(stylesheet_file=str(xsl_file_path))
    except:
      exception_occurred = True
      _exec = None

    if _exec is None:
        saxon_error = f"{xsltproc.error_message}\n"
        xsltproc.exception_clear()
        lock.release()
        # the saxonche library doesn't output saxon compile errors so use
        # java instead
        java_feedback = call_out_to_java_to_get_saxon_compile_errors(
            home_dir, xml_file_name, xsl_file_name
        )
        if java_feedback:
            # saxon_error += java_feedback.stdout
            saxon_error += java_feedback.stderr
        raise RuntimeError(saxon_error)

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
        # pass in parameters
        if params:
            for k, v in params.items():
                if len(v) > 3:
                    # if "'string'" => "string" or
                    # if '"string"' => "string"
                    if "'" == v[0] and "'" == v[-1] or '"' == v[0] and '"' == v[-1]:
                        v = v[1:-1]
                param = proc.make_string_value(str(v))
                _exec.set_parameter(k, param)
        _exec.set_initial_match_selection(file_name=str(xml_file_path))
        _exec.apply_templates_returning_file(output_file=str(output_file_path))
        if exception_occurred or _exec.exception_occurred:
            saxon_error = f"{_exec.error_message}\n"
            _exec.exception_clear()
            lock.release()
            # the saxonche library doesn't output saxon compile errors so use
            # java instead
            java_feedback = call_out_to_java_to_get_saxon_compile_errors(
                home_dir, xml_file_name, xsl_file_name
            )
            if java_feedback:
                saxon_error += java_feedback.stdout
                saxon_error += java_feedback.stderr
            raise RuntimeError(saxon_error)

        if stashed_output_file_path:
            shutil.copy(src=output_file_path, dst=stashed_output_file_path)
            os.remove(output_file_path)
            output_file_path = stashed_output_file_path

        if Path(output_file_name).suffix == ".xml":
            # post test to see if the provided xsl_file_name created valid xml
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
                saxon_error = f"{_exec.error_message}\n"
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
        try:
            result = __saxon_xslt30_transform(
                lock,
                home_dir=q.home_dir,
                xml_file_name=q.xml_file_name,
                xsl_file_name=q.xsl_file_name,
                output_file_name=q.output_file_name,
                params=q.params,
                verbose=q.verbose,
            )
        except RuntimeError as ex:
            result = str(ex)
        output_queue.put(result)


def xpath_with_saxon(home_dir, xml_file_name, pattern):
    with PySaxonProcessor(license=False) as proc:
        xpath_processor = proc.new_xpath_processor()
        xml_as_string = ""
        with open((Path(home_dir) / xml_file_name), "r") as fp:
            xml_as_string = fp.read()
        pattern = pattern.replace('///', '//')
        if 'html' in Path(xml_file_name).suffix:
          xpath_processor.declare_namespace('xhtml', "http://www.w3.org/1999/xhtml")
        node = proc.parse_xml(xml_text=xml_as_string)
        xpath_processor.set_context(xdm_item=node)
        item = xpath_processor.evaluate(pattern)
        print(item)


def saxon_xslt30_transform(
    home_dir,
    xml_file_name,
    xsl_file_name,
    output_file_name,
    params=None,
    verbose=False,
):

    global proc_globals_lock

    input_queue = Queue()
    output_queue = Queue()

    payload = SaxonPayload(
        home_dir=home_dir,
        xml_file_name=xml_file_name,
        xsl_file_name=xsl_file_name,
        output_file_name=output_file_name,
        params=params,
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


class CliCache:

    CacheFileName = "cache.yml"
    PathToCache = Path(__file__).parent.absolute() / CacheFileName

    def __init__(
        self,
        home_dir,
        xml_file_name=None,
        xsl_file_name=None,
        processor=None,
        output_file_name=None,
        context=None,
        params=None,
    ):
        self._cache = None
        self.cache_yml_path = CliCache.PathToCache
        if not self.cache_yml_path.exists():
            assert home_dir
            self._cache = {}
            self._cache["home_dir"] = str(home_dir)
            self._cache["xml_file_name"] = None
            self._cache["xsl_file_name"] = None
            self._cache["processor"] = None
            self._cache["output_file_name"] = None
            self._cache["context"] = None
            self._cache["params"] = None

            if not self.cache_yml_path.exists():
                with open(self.cache_yml_path, "wt") as f:
                    f.write(yaml.dump(self._cache))
        else:
            with open(self.cache_yml_path, "rt") as f:
                self._cache = yaml.safe_load(f.read())

        @contextmanager
        def cached(self, *args, **kwargs):
            with open(self.cache_yml_path, "rt") as f:
                _cache = yaml.safe_load(f.read())
            try:
                if _cache is None:
                    _cache = self._cache
                yield _cache
            finally:
                with open(self.cache_yml_path, "wt") as f:
                    f.write(yaml.dump(_cache))

        self.cached = partial(cached, self=self)

    def __str__(self):
        return str(self._cache) if self._cache else ""

    @staticmethod
    def exists():
        return CliCache.PathToCache.exists()

    @property
    def home_dir(self):
        result = None
        with self.cached() as cache:
            result = cache["home_dir"]
            result = None if result == "None" else result
        if result is not None:
            if Path(result).exists():
                result = Path(result)
        return result

    @home_dir.setter
    def home_dir(self, home_dir):
        with self.cached() as cache:
            cache["home_dir"] = str(home_dir)

    @property
    def xml_file_name(self):
        result = None
        with self.cached() as cache:
            result = cache["xml_file_name"]
        return result

    @xml_file_name.setter
    def xml_file_name(self, xml_file_name):
        with self.cached() as cache:
            cache["xml_file_name"] = xml_file_name

    @property
    def xsl_file_name(self):
        result = None
        with self.cached() as cache:
            result = cache["xsl_file_name"]
        return result

    @xsl_file_name.setter
    def xsl_file_name(self, xsl_file_name):
        with self.cached() as cache:
            cache["xsl_file_name"] = xsl_file_name

    @property
    def processor(self):
        result = None
        with self.cached() as cache:
            result = cache["processor"]
        return result

    @processor.setter
    def processor(self, processor):
        with self.cached() as cache:
            cache["processor"] = processor

    @property
    def output_file_name(self):
        result = None
        with self.cached() as cache:
            result = cache["output_file_name"]
        return result

    @output_file_name.setter
    def output_file_name(self, output_file_name):
        with self.cached() as cache:
            cache["output_file_name"] = output_file_name

    @property
    def context(self):
        result = None
        set_empty_context = False
        with self.cached() as cache:
            if "context" not in cache:
                set_empty_context = True
                result = ""
            else:
                result = cache["context"]
        if set_empty_context:
            self.context = result
        return result

    @context.setter
    def context(self, context):
        with self.cached() as cache:
            cache["context"] = context

    @property
    def params(self):
        result = None
        set_empty_params = False
        with self.cached() as cache:
            if "params" not in cache:
                set_empty_params = True
                result = ""
            else:
                result = cache["params"]
        if set_empty_params:
            self.params = result
        return result

    @params.setter
    def params(self, params):
        with self.cached() as cache:
            cache["params"] = params


class Config:
    def __init__(self):
        self._cwd = Path(".").resolve()
        self.cwd = str(self._cwd)
        self.cache = None

    def clear(self):
        self.cache.xml_file_name = None
        self.cache.xsl_file_name = None
        self.cache.processor = None

    def cache_inputs(
        self, home_dir, xml_file_name, xsl_file_name, processor, context, params
    ):
        cache_exists = True if CliCache.exists() else False

        if cache_exists:
            self.cache = CliCache(home_dir=home_dir)
            if home_dir is None:
                home_dir = self.cache.home_dir
            if xml_file_name is None:
                xml_file_name = self.cache.xml_file_name
            if xsl_file_name is None:
                xsl_file_name = self.cache.xsl_file_name
            if processor is None:
                processor = self.cache.processor
            if context is None:
                context = self.cache.context
            if params is None:
                params = self.cache.params

        else:
            if home_dir is None:
                home_dir = PathToDefault
            self.cache = CliCache(
                home_dir=home_dir,
                xml_file_name=None,
                xsl_file_name=None,
                processor=None,
                context=None,
                params=None,
            )

        self.cache.xml_file_name = xml_file_name
        self.cache.xsl_file_name = xsl_file_name
        self.cache.processor = processor
        self.cache.context = context
        self.cache.params = params

    def transform_with_lxml(
        self, home_dir, xml_file_name, xsl_file_name, output_file_name
    ):

        xsl_p = (Path(home_dir) / xsl_file_name).resolve()
        if not xsl_p.exists():
            raise Exception(f"{xsl_p} doesn't exist")

        xml_p = (Path(home_dir) / xml_file_name).resolve()
        if not xml_p.exists():
            raise Exception(f"{xml_p} doesn't exist")

        out_p = (Path(home_dir) / output_file_name).resolve()
        trasform = etree.XSLT(etree.parse(str(xsl_p)))
        doc = etree.parse(str(xml_p))
        result = trasform(doc)
        result_as_string = etree.tostring(result, pretty_print=True).decode("utf-8")
        print(result_as_string)
        with open(out_p, "wb") as fp:
            fp.write(etree.tostring(result, pretty_print=True))

    def transform_with_saxonche(
        self, home_dir, xml_file_name, xsl_file_name, output_file_name
    ):
        # Don't use the context manager if you are calling saxonica over and
        # over again with your program.  Instead build the proc and
        # xsltproc once, and call it over and over.  If you don't do this, you
        # will get strange errors associated with memory problems. (last seen
        # in version 11.4)
        #
        # Instead do something like this:
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
        #
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


pass_config = click.make_pass_decorator(Config, ensure=True)


@click.group()
@click.option(
    "-d", "--dir", "home_dir", default=None, help="Set the exercise directory"
)
@pass_config
def cli(ctx, home_dir):
    """Try an XSLT/XPath example and cache the command"""
    ctx.cache_inputs(
        home_dir=home_dir,
        xml_file_name=None,
        xsl_file_name=None,
        processor=None,
        context=None,
        params=None,
    )
    if ctx.cache.home_dir is None:
        ctx.cache.home_dir = str(PathToDefault)
        click.echo(home_dir)
    elif home_dir is not None and Path(home_dir).exists():
        ctx.cache.home_dir = str(Path(home_dir).resolve())
    elif home_dir is not None and not Path(home_dir).exists():
        click.echo(f"{home_dir} does not exist")
        exit(1)


@cli.command
@pass_config
def cache(ctx):
    """View your command cache"""
    click.echo(ctx.cache)


@cli.command
@click.option(
    "-x", "--xml", "xml_file_name", default=None, help="Set the xml file (Cachable)"
)
@click.option("-p", "--pattern", default=None, help="Pattern")
@click.option("-c", "--context", default=None, help="Cachable context")
@click.option("--cache", is_flag=True, default=False, help="Reflect upon the Cache")
@click.option(
    "-v", "--version", is_flag=True, default=False, help="Output the XPath version"
)
@pass_config
def xpath(
    ctx,
    xml_file_name,
    pattern,
    context,
    cache,
    version,
):
    """Test an XPath query on a given xml doc and context"""
    xpath_version = "3.1"
    if version:
        click.echo(f"XPath {xpath_version}")
        exit(0)

    if cache:
        click.echo("XPath cache:")
        home_dir = str(ctx.cache.home_dir)
        xml_file_name = ctx.cache.xml_file_name
        context = ctx.cache.context
        click.echo(f"  home_dir: {home_dir}")
        click.echo(f"  xml_file_name: {xml_file_name}")
        click.echo(f"  context: {context}")
        exit(0)

    if xml_file_name:
        ctx.cache.xml_file_name = xml_file_name
    else:
        xml_file_name = ctx.cache.xml_file_name

    if context or context == "":
        ctx.cache.context = context
    else:
        context = ctx.cache.context

    if ctx.cache.context:
        click.echo(f"context: {ctx.cache.context}")

    if context:
        if context[-1] != "/":
            context += "/"
        full_pattern = context + pattern
    else:
        full_pattern = pattern

    xpath_with_saxon(
        home_dir=ctx.cache.home_dir, xml_file_name=xml_file_name, pattern=full_pattern
    )


def download_file(url, file_path=None):
    if file_path is None:
        local_filename = Path(url.split("/")[-1])
    else:
        local_filename = file_path
    with requests.get(url, stream=True) as r:
        with open(local_filename, "wb") as f:
            shutil.copyfileobj(r.raw, f)
    return local_filename


@click.group()
def xslt():
    pass


@xslt.command
def install_compiler_errors():
    """Download and inflate java version of saxon-he"""
    url = "https://github.com/Saxonica/Saxon-HE/raw/be4dd844d935d8d0ef09748490448624abe3c66b/12/Java/SaxonHE12-0J.zip"
    zip_file_path = Path(url.split("/")[-1])
    install_directory = (Path(__file__).parent / ".." / "java").resolve()
    target_path = install_directory / "saxon-he-12.0.jar"

    if not install_directory.exists():
        os.makedirs(install_directory)

    if not target_path.exists():
        downloaded_file = download_file(url, file_path=zip_file_path)
        with zipfile.ZipFile(zip_file_path, "r") as zip_ref:
            zip_ref.extractall(install_directory)
        os.remove(downloaded_file)
        click.echo(f"{str(target_path)} installed")
    else:
        click.echo(f"{str(target_path)} already installed")


@cli.command
@pass_config
@click.option("-x", "--xml", "xml_file_name", default=None, help="Set the xml file")
@click.option(
    "-o",
    "--output_file",
    "output_file_name",
    default=None,
    help="Set the output file name",
)
@click.option("-a", "--params", default=None, help="Set the optional parameters(s)")
@click.option("-v", "--verbose", is_flag=True, default=False, help="Verbose mode")
def to_python(
    ctx,
    xml_file_name,
    output_file_name,
    params,
    verbose
):
    '''Convert and XML file into a python file (dict at the top)'''
    if xml_file_name:
        ctx.cache.xml_file_name = xml_file_name
    else:
        xml_file_name = ctx.cache.xml_file_name

    if output_file_name:
        ctx.cache.output_file_name = output_file_name
    else:
        output_file_name = ctx.cache.output_file_name

    if params:
        ctx.cache.params = params
    elif params == '':
        params = None
        ctx.cache.params = None
    else:
        params = ctx.cache.params

    if params:
        scratch = params.split(',')
        _params = {k:v for k,v in [items.split('=') for items in scratch]}
    else:
        _params =  None

    home_dir = Path('/')
    xml_file_name = Path(ctx.cache.home_dir) / Path( xml_file_name )
    xsl_file_name = (Path(__file__).parent) / 'xml_to_python_dict.xsl'
    output_file_name = Path(ctx.cache.home_dir) / output_file_name

    try:
      result = saxon_xslt30_transform(
          home_dir=home_dir,
          xml_file_name=xml_file_name,
          xsl_file_name=xsl_file_name,
          output_file_name=output_file_name,
          params=_params,
          verbose=verbose,
      )
      if verbose:
        print(result)
      click.echo("ran the saxon processor")
    except RuntimeError as ex:
      click.echo(ex)

@cli.command
@pass_config
@click.option("-n", "--node-name", default=None, help="Set the node name")
@click.option("-x", "--xml", "xml_file_name", default=None, help="Set the xml file")
@click.option(
    "-j", "--json", "json_file_name", default=None, help="Set the json file (saxon)"
)
@click.option("-l", "--xls", "xsl_file_name", default=None, help="Set the xls file")
@click.option("-p", "--processor", default=None, help="Set the processor (lxml|saxon)")
@click.option(
    "-o",
    "--output_file",
    "output_file_name",
    default=None,
    help="Set the output file name",
)
@click.option("-a", "--params", default=None, help="Set the optional parameter(s)")
@click.option(
    "-v", "--verbose", is_flag=True, default=False, help="Run in verbose mode?"
)
def ex(
    ctx,
    node_name,
    xml_file_name,
    xsl_file_name,
    json_file_name,
    processor,
    output_file_name,
    params,
    verbose,
):
    """Run an XSLT exercise:


    try -d sal/ch07 ex -x books.xml -l text.hierarchy.xsl \\

      --params "indent='   ',param2='some_value'" -o text.hierarchy.txt

    """
    if node_name:
        xml_file_name = f"{node_name}.xml"
        xsl_file_name = f"{node_name}.xsl"
        output_file_name = f"{node_name}.html"

    if json_file_name:
        xml_file_name = json_file_name

    if xml_file_name:
        ctx.cache.xml_file_name = xml_file_name
    else:
        xml_file_name = ctx.cache.xml_file_name

    if xsl_file_name:
        ctx.cache.xsl_file_name = xsl_file_name
    else:
        xsl_file_name = ctx.cache.xsl_file_name

    if processor:
        ctx.cache.processor = processor
    else:
        processor = ctx.cache.processor

    if output_file_name:
        ctx.cache.output_file_name = output_file_name
    else:
        output_file_name = ctx.cache.output_file_name

    if not xml_file_name:
        click.echo("you need to specify an xml_file_name or node_name")
        exit(0)

    if not xsl_file_name:
        click.echo("you need to specify an xsl_file_name or node_name")
        exit(0)

    if not processor:
        click.echo("you need to specify an processor or node_name")
        exit(0)

    if not output_file_name:
        click.echo("you need to specify an output_file_name")
        exit(0)

    if params:
        ctx.cache.params = params
    elif params == "":
        ctx.cache.params = None
        params = None
    else:
        params = ctx.cache.params

    if params:
        scratch = params.split(",")
        _params = {k: v for k, v in [item.split("=") for item in scratch]}
    else:
        _params = None

    if processor == "lxml":
        ctx.transform_with_lxml(
            home_dir=ctx.cache.home_dir,
            xml_file_name=xml_file_name,
            xsl_file_name=xsl_file_name,
            output_file_name=output_file_name,
        )
        click.echo("ran the lxml processor")
    elif "saxon" in processor:
        result = saxon_xslt30_transform(
            home_dir=ctx.cache.home_dir,
            xml_file_name=xml_file_name,
            xsl_file_name=xsl_file_name,
            output_file_name=output_file_name,
            params=_params,
            verbose=verbose,
        )
        click.echo(result)
        click.echo("ran the saxon processor thread")
    else:
        click.echo('command ignored, no processor set; "try ex --help"')
