#!/usr/bin/env python
import os
import sys
import time

options = {
	'l' : False, # Auto loop
	'u' : False, # Uglify
}

if len(sys.argv) > 1:
	for argv in sys.argv:
		if argv in options:
			options[argv] = True

def build():
	os.system('coffee -b --compile --output js/ coffee/')

	if options['u']:
		os.chdir('./js')
		jses = [f for f in os.listdir('.') if os.path.isfile(f)]
		for js in jses:
			os.system('uglifyjs %s -m -c --screw-ie8 --source-map %s.map -o %s' % (js, js, js))
		os.chdir('./..')

	lesses = os.listdir('./less')
	for less in lesses:
		less = less.split('.')[0]
		os.system('lessc ./less/%s.less > ./css/%s.css' % (less, less))

	print ('[' + time.strftime('%H:%M:%S') + '] Build')

build()
while options['l']:
	time.sleep(3)
	build()
