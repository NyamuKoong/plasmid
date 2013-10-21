import os
lesses = os.listdir('./less')
for less in lesses:
	less = less.split('.')[0]
	os.system('lessc ./less/%s.less > ./css/%s.css' % (less, less))
