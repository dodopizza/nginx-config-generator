#!/usr/bin/python

#
# pip install jinja2 pyyaml
#

import jinja2, yaml, sys

data = yaml.load(open('./data.yml'))
loader = jinja2.FileSystemLoader('./')
env = jinja2.Environment( loader=loader, autoescape=False, trim_blocks=False, lstrip_blocks=False, extensions=['jinja2.ext.do'] )

## User functions

def merge(x,y):
    z = x.copy()   
    z.update(y)
    return z

env.globals.update(merge=merge)

## - User functions

env.filters['merge'] = merge

template = env.get_template( sys.argv[1] )

print( template.render(data) )