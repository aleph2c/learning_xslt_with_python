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
        # xdm_atomic_value = proc.make_integer_value(5)
        # xsltproc.set_parameter("xdm_atomic", xdm_atomic_value)
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
        # xdm_atomic_value = proc.make_integer_value(5)
        # xsltproc.set_parameter("xdm_atomic", xdm_atomic_value)
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
    home_dir = (Path(__file__).parent / ".." / "jenni" / "ch3_templates").resolve()
    xml_file_name = "HelloWorld.xml"
    xsl_file_name = "HelloWorld.xsl"
    output_file_name = "HelloWorld.html"

    result = saxon_xslt30_transform(
        home_dir, xml_file_name, xsl_file_name, output_file_name, verbose=True
    )
    print(result)
