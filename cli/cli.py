import yaml
from pathlib import Path
from functools import partial
from contextlib import contextmanager

import click
from lxml import etree
from saxonche import PySaxonProcessor

import pprint


def pp(item):
    pprint.pprint(item)


PathToDefault = (Path(__file__).parent / ".." / "ch3_templates").resolve()


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


class Config:
    def __init__(self):
        self._cwd = Path(".").resolve()
        self.cwd = str(self._cwd)
        self.cache = None

    def clear(self):
        self.cache.xml_file_name = None
        self.cache.xsl_file_name = None
        self.cache.processor = None

    def cache_inputs(self, home_dir, xml_file_name, xsl_file_name, processor):
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

        else:
            if home_dir is None:
                home_dir = PathToDefault
            self.cache = CliCache(
                home_dir=home_dir,
                xml_file_name=None,
                xsl_file_name=None,
                processor=None,
            )

        self.cache.xml_file_name = xml_file_name
        self.cache.xsl_file_name = xsl_file_name
        self.cache.processor = processor

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
    """Try an XSLT example and cache the command"""
    ctx.cache_inputs(
        home_dir=home_dir, xml_file_name=None, xsl_file_name=None, processor=None
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
def ex(
    ctx,
    node_name,
    xml_file_name,
    xsl_file_name,
    json_file_name,
    processor,
    output_file_name,
):
    """Run an XSLT exercise"""
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

    if processor == "lxml":
        ctx.transform_with_lxml(
            home_dir=ctx.cache.home_dir,
            xml_file_name=xml_file_name,
            xsl_file_name=xsl_file_name,
            output_file_name=output_file_name,
        )
        click.echo("ran the lxml processor")
    elif "saxon" in processor:
        ctx.transform_with_saxonche(
            home_dir=ctx.cache.home_dir,
            xml_file_name=xml_file_name,
            xsl_file_name=xsl_file_name,
            output_file_name=output_file_name,
        )
        click.echo("ran the saxon processor")
    else:
        click.echo('command ignored, no processor set; "try ex --help"')
