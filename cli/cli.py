import yaml
from pathlib import Path
from functools import partial
from contextlib import contextmanager

import click
from lxml import etree
from saxonpy import PySaxonProcessor

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
        xls_file_name=None,
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
            self._cache["xls_file_name"] = None
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
    def xls_file_name(self):
        result = None
        with self.cached() as cache:
            result = cache["xls_file_name"]
        return result

    @xls_file_name.setter
    def xls_file_name(self, xls_file_name):
        with self.cached() as cache:
            cache["xls_file_name"] = xls_file_name

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
        self.cache.xls_file_name = None
        self.cache.processor = None

    def cache_inputs(self, home_dir, xml_file_name, xls_file_name, processor):
        cache_exists = True if CliCache.exists() else False

        if cache_exists:
            self.cache = CliCache(home_dir=home_dir)
            if home_dir is None:
                home_dir = self.cache.home_dir
            if xml_file_name is None:
                xml_file_name = self.cache.xml_file_name
            if xls_file_name is None:
                xls_file_name = self.cache.xls_file_name
            if processor is None:
                processor = self.cache.processor

        else:
            if home_dir is None:
                home_dir = PathToDefault
            self.cache = CliCache(
                home_dir=home_dir,
                xml_file_name=None,
                xls_file_name=None,
                processor=None,
            )

        self.cache.xml_file_name = xml_file_name
        self.cache.xls_file_name = xls_file_name
        self.cache.processor = processor

    def create_file_from_lxml(
        self, home_dir, xml_file_name, xls_file_name, output_file_name
    ):

        xsl_p = (Path(home_dir) / xls_file_name).resolve()
        if not xsl_p.exists():
            raise Exception(f"{xsl_p} doesn't exist")

        xml_p = (Path(home_dir) / xml_file_name).resolve()
        if not xml_p.exists():
            raise Exception(f"{xml_p} doesn't exist")

        out_p = (Path(home_dir) / output_file_name).resolve()
        trasform = etree.XSLT(etree.parse(str(xsl_p)))
        doc = etree.parse(str(xml_p))
        result = trasform(doc)
        result_as_string = etree.tostring(result, pretty_print=True).decode('utf-8')
        print(result_as_string)
        with open(out_p, "wb") as fp:
            fp.write(etree.tostring(result, pretty_print=True))

    def create_file_from_saxonpy(
        self, home_dir, xml_file_name, xls_file_name, output_file_name
    ):

        with PySaxonProcessor(license=False) as proc:
            xsltproc = proc.new_xslt_processor()

            with open(home_dir / xml_file_name) as fp:
                xml_text = fp.read()
            document = proc.parse_xml(xml_text=xml_text)

            with open(home_dir / xls_file_name) as fp:
                xslt_text = fp.read()
            xsltproc.set_source(xdm_node=document)
            xsltproc.compile_stylesheet(stylesheet_text=xslt_text)
            output = xsltproc.transform_to_string()
            print(output)

            if output:
                with open(home_dir / output_file_name, "w") as fp:
                    fp.write(output)
            else:
                print("there is nothing to write")


pass_config = click.make_pass_decorator(Config, ensure=True)


@click.group()
@click.option(
    "-d", "--dir", "home_dir", default=None, help="Set the exercise directory"
)
@pass_config
def cli(ctx, home_dir):
    '''Try an XSLT example and cache the command'''
    ctx.cache_inputs(
        home_dir=home_dir, xml_file_name=None, xls_file_name=None, processor=None
    )
    if ctx.cache.home_dir is None:
        ctx.cache.home_dir = str(PathToDefault)
        click.echo(home_dir)


@cli.command
@pass_config
def cache(ctx):
    '''View your command cache'''
    click.echo(ctx.cache)


@cli.command
@pass_config
@click.option("-n", "--node-name", default=None, help="Set the node name")
@click.option("-x", "--xml", "xml_file_name", default=None, help="Set the xml file")
@click.option("-l", "--xls", "xls_file_name", default=None, help="Set the xls file")
@click.option("-p", "--processor", default=None, help="Set the processor (lxml|saxon)")
@click.option(
    "-o",
    "--output_file",
    "output_file_name",
    default=None,
    help="Set the output file name",
)
def ex(ctx, node_name, xml_file_name, xls_file_name, processor, output_file_name):
    '''Run an exercise'''
    if node_name:
        xml_file_name = f"{node_name}.xml"
        xls_file_name = f"{node_name}.xsl"
        output_file_name = f"{node_name}.html"

    if xml_file_name:
        ctx.cache.xml_file_name = xml_file_name
    else:
        xml_file_name = ctx.cache.xml_file_name

    if xls_file_name:
        ctx.cache.xls_file_name = xls_file_name
    else:
        xls_file_name = ctx.cache.xls_file_name

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

    if not xls_file_name:
        click.echo("you need to specify an xls_file_name or node_name")
        exit(0)

    if not processor:
        click.echo("you need to specify an processor or node_name")
        exit(0)

    if not output_file_name:
        click.echo("you need to specify an output_file_name")
        exit(0)

    if processor == "lxml":
        ctx.create_file_from_lxml(
            home_dir=ctx.cache.home_dir,
            xml_file_name=xml_file_name,
            xls_file_name=xls_file_name,
            output_file_name=output_file_name,
        )
        click.echo("ran the lxml processor")
    elif "saxon" in processor:
        ctx.create_file_from_saxonpy(
            home_dir=ctx.cache.home_dir,
            xml_file_name=xml_file_name,
            xls_file_name=xls_file_name,
            output_file_name=output_file_name,
        )
        click.echo("ran the saxon processor")
    else:
        click.echo('command ignored, no processor set; "try ex --help"')
