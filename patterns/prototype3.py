# try and program this as if it was XSLT/XPath
import re
from collections import namedtuple

search_pattern = "//item[@name='Young']/item[@name='Rex']"

Attr = \
  namedtuple('Attr', ['name', 'value'  ])
Node = \
  namedtuple('Node', ['name', 'attr', 'text' ])

ancestors1 = [
  Node(name='root', attr=None, text=None),
  Node(name='data', attr=None, text=None),
  Node(name='items', attr=None, text=None),
  Node(name='item', attr=Attr(name='name', value='Orange'), text=None),
  Node(name='item', attr=Attr(name='name', value='Young'), text=None),
  Node(name='item', attr=Attr(name='name', value='Rex'), text='Hit'),
]

ancestors2 = [
  Node(name='root', attr=None, text=None),
  Node(name='data', attr=None, text=None),
  Node(name='items', attr=None, text=None),
  Node(name='item', attr=Attr(name='name', value='Orange'), text=None),
  Node(name='item', attr=Attr(name='name', value='Young'), text=None),
  Node(name='item', attr=Attr(name='name', value='Bob'), text='Hit'),
]

# - [x] defined
# - [x] parameters
# - [x] ported
# - [ ] tested
def tokenize_reverse_search(search_pattern):
  temp = search_pattern.split('/')
  result = []
  for item in temp:
    if len(item) > 0:
      result.append(item)
  result.reverse()
  return result

# - [x] defined
# - [x] parameters
# - [ ] ported
# - [ ] tested
def reverse_ancestors(ancestors):
  _ancestors = ancestors[:]
  _ancestors.reverse()
  return _ancestors

# - [x] defined
# - [x] parameters
# - [ ] ported
# - [ ] tested
def create_node_for_search_item(item):
  m = re.search('(.+)\[', item)
  if m:
    node_name = m.group(1)
  else:
    node_name = None

  m = re.search('\[@(.+)=', item)
  if m:
    attr_name = m.group(1)
  else:
    attr_name = None

  m = re.search("='(.+)'", item)
  if m:
    attr_value = m.group(1)
  else:
    attr_value = None
  n = Node(name=node_name, attr=Attr(name=attr_name, value=attr_value), text=None)
  return n

# - [x] defined
# - [x] parameters
# - [ ] ported
# - [ ] tested
def create_reversed_search_nodes(search_pattern):
  reverse_search_sequence = \
    tokenize_reverse_search(search_pattern)
  search_nodes = []
  for i in range(0, len(reverse_search_sequence)):
    search_nodes.append(
        create_node_for_search_item(reverse_search_sequence[i])
    )
  return search_nodes

# - [x] defined
# - [x] parameters
# - [ ] ported
# - [ ] tested
def compare_ancestors_to_search_pattern(ancestors, search_pattern):
  reverse_search_nodes = create_reversed_search_nodes(search_pattern)
  reversed_ancestor_nodes = reverse_ancestors(ancestors)
  count = len(reverse_search_nodes)
  array = [0]*count
  for i in range(0, count):
    search_node = reverse_search_nodes[i]
    ancestor_node = reversed_ancestor_nodes[i]
    if search_node.name == ancestor_node.name and \
       search_node.attr.name == ancestor_node.attr.name and \
       search_node.attr.value == ancestor_node.attr.value:
      array[i] = 1
  result = True if sum(array) == count else False
  return result

if __name__ == '__main__':
  print(
    compare_ancestors_to_search_pattern(ancestors1, search_pattern)
  )
  print(
    compare_ancestors_to_search_pattern(ancestors2, search_pattern)
  )




