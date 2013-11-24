import os
import sys
import time

options = {
	'l' : False # Auto loop
}

if len(sys.argv) > 1:
	for argv in sys.argv:
		if argv in options:
			options[argv] = True

def build():
	os.system('coffee -b --compile --output js/ coffee/')
	lesses = os.listdir('./less')
	for less in lesses:
		less = less.split('.')[0]
		os.system('lessc ./less/%s.less > ./css/%s.css' % (less, less))

	print ('[' + time.strftime('%H:%M:%S') + '] Build')

if options['l']:
	while True:
		build()
		time.sleep(3)

else:
	build()