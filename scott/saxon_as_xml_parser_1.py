from saxonche import PySaxonProcessor

with PySaxonProcessor(license=False) as proc:

  xml = """\
      <out>
        <person attr_1='value1' attr_2='value2'>bob</person>
        <person>mary</person>
        <person>nacho</person>
      </out>
  """
  node = proc.parse_xml(xml_text=xml)
  print(f"node.node_kind={node.node_kind_str}") # node.node_kind=document
  print(f"node.size={str(node.size)}") # node.size=1

  out_node = node.children
  print(f"len of children={str(len(node.children))}") # len of children=1
  print(f"element name={out_node[0].name}") # element name=out

  persons = out_node[0].children
  [print(p) for p in persons if len(str(p)) != 0]
    #   <person attr_1='value1' attr_2='value2'>bob</person>
    #   <person>mary</person>
    #   <person>nacho</person>

  print(persons[0].__class__)  # saxonche.PyXdmNode
  print(dir(persons[0].__class__))  # see the methods you can play with

  attrs = persons[1].attributes
  if len(attrs) == 2:
    print(attrs[1].string_value) # value2

  

