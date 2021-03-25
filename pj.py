#!/usr/bin/python

#
# pip install jinja2 pyyaml
#

import jinja2, yaml, sys, hashlib

data = yaml.load(open('./data.yml'), Loader=yaml.FullLoader)
loader = jinja2.FileSystemLoader('./')
env = jinja2.Environment(
    loader=loader, autoescape=False, trim_blocks=False, lstrip_blocks=False, extensions=['jinja2.ext.do'])

## User functions


def merge(x, y):
    z = x.copy()
    z.update(y)
    return z


# https://github.com/ansible/ansible/blob/devel/test/lib/ansible_test/_internal/encoding.py
ENCODING = 'utf-8'
Text = type(u'')

def to_bytes(value, errors='strict'):  # type: (t.AnyStr, str) -> bytes

    """Return the given value as bytes encoded using UTF-8 if not already bytes."""
    if isinstance(value, bytes):
        return value

    if isinstance(value, Text):
        return value.encode(ENCODING, errors)

    raise Exception('value is not bytes or text: %s' % type(value))

# https://github.com/ansible/ansible/blob/devel/lib/ansible/plugins/filter/core.py
def get_hash(data, hashtype='sha1'): 
    try:
        h = hashlib.new(hashtype)
    except Exception as e:
        # hash is not supported?
        raise e

    h.update(to_bytes(data, errors='surrogate_or_strict'))
    return h.hexdigest()


env.globals.update(merge=merge)
env.globals.update(get_hash=get_hash)

## - User functions

env.filters['merge'] = merge
env.filters['hash'] = get_hash

template = env.get_template(sys.argv[1])

print(template.render(data))
