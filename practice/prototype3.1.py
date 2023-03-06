# this took 5 minutes to write
# it will take 5 hours in XSLT
import pprint
def pp(item):
  pprint.pprint(item)

# prototype a way for XSLT to test what I want

targets  = [ 'pattern1', 'pattern2', 'pattern3' ]
realities = [ 'pattern1', 'pattern2', 'pattern3', 'pattern4' ]

# to create a functional example your variables can only
# be written once
def test_pattern(targets, realities, result=True):
  if len(targets):
    t_head, *t_tail = targets
  else:
    t_head, t_tail = targets, None

  if len(targets) > len(realities):
    return False

  if len(realities):
    r_head, *r_tail = realities
  else:
    r_head, r_tail  = realities, None

  _result = (t_head == r_head and result)
  if t_tail and _result:
    __result = test_pattern(t_tail, r_tail, _result)
  else:
    __result = _result
  return __result

if __name__ == '__main__':
  print(test_pattern(targets, realities))


