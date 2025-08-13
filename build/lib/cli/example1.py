from saxonche import PySaxonProcessor

proc_globals = {}


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


if __name__ == "__main__":
    proc, _ = __initialize_saxon()
    xml = """\
        <out>
          <person attr1="value1" attr2="value2">text1</person>
          <person>text2</person>
          <person>text3</person>
        </out>
        """
    node = proc.parse_xml(xml_text=xml)

    print(f"node.node_kind={node.node_kind_str}")  # => document
    print(f"node.size={str(node.size)}")  # => 1
    out_node = node.children
    print(f"len of children={str(len(node.children))}")  # => 1
    print(f"element name={out_node[0].name}")  # => out
    children = out_node[0].children

    # children[0] carriage return after <out>
    # children[1] first person node
    attrs = children[1].attributes
    if len(attrs) == 2:
        print(attrs[1].string_value)
