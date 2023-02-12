# this causes a StackOverFlow
import os
import time
import random
import contextlib
from pathlib import Path

from queue import Queue
from threading import Thread
from threading import Lock
from collections import namedtuple
from threading import Event as ThreadEvent

from saxonche import PySaxonProcessor

SaxonXmlPayload = namedtuple(
    "SaxonXmlPayload",
    ["xml", "delay"],
)

proc_globals = {}
proc_globals_lock = Lock()

def __get_saxon_globals():
    """The PySaxonProcessor proc and the xslt30 proc should only be made once"""
    global proc_globals

    if "proc" in proc_globals:
        proc = proc_globals["proc"]
        xsltproc = proc_globals["xsltproc"]
    else:
        proc = PySaxonProcessor(license=False)
        xsltproc = proc.new_xslt30_processor()
        proc_globals["proc"] = proc
        proc_globals["xsltproc"] = xsltproc
        xml = """<out></out>"""
        proc.parse_xml(xml_text=xml)

    return proc, xsltproc

proc_globals_lock.acquire()
__get_saxon_globals()
proc_globals_lock.release()

@contextlib.contextmanager
def guarded_saxonc(proc, xslt_proc=None):
  global proc_globals_lock

  proc_globals_lock.acquire()
  if xslt_proc:
    yield proc, xslt_proc
  else:
    yield proc
  proc_globals_lock.release()


def thread_runner(task_event, input_queue, output_queue, fn):
    global proc_globals_lock
    proc_globals_lock.acquire()
    global_proc, global_xsltproc = __get_saxon_globals()
    proc_globals_lock.release()

    while task_event.is_set():
        result = ""
        q = input_queue.get(block=True)
        input_queue.task_done()
        xml = q.xml
        delay = q.delay
        time.sleep(delay)
        import pdb; pdb.set_trace()
        with guarded_saxonc(global_proc) as proc:
          fn(proc, xml)
        output_queue.put(result)

def saxon_parse(xml, fn):

    input_queue = Queue()
    output_queue = Queue()

    payload = SaxonXmlPayload(xml=xml, delay=random.uniform(0.5, 1.0))

    task_event = ThreadEvent()
    task_event.set()
    thread = Thread(
        target=thread_runner,
        args=(task_event, input_queue, output_queue, fn),
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
  xml = """\
        <out>
          <person attr1="value1" attr2="value2">text1</person>
          <person>text2</person>
          <person>text3</person>
        </out>
        """

  def fn(proc, xml):
    node = proc.parse_xml(xml_text=xml)
    result += f"node.node_kind={node.node_kind_str}"
    result += f"node.size={str(node.size)}"
    out_node = node.children
    result += f"len of children={str(len(node.children))}"
    result += f"element name={out_node[0].name}"
    children = out_node[0].children
    # children[0] carriage return after <out>
    # children[1] first person node
    attrs = children[1].attributes
    if len(attrs) == 2:
      result += (attrs[1].string_value)

  for i in range(100):
    saxon_parse(xml, fn)

