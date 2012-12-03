import sys
import os
import shutil

#------------------------------------------------------------------------------#
# config
#------------------------------------------------------------------------------#

PWD             = os.getcwd()

SOURCE_PATH     = "%s/" % PWD

TARGET_PATH     = "%s/compiled" % PWD

APP_ENGINE_PATH = "%s/google_appengine" % PWD

PAGE            = 'sample'

#------------------------------------------------------------------------------#
# import from w3 & AppEngine
#------------------------------------------------------------------------------#

EXTRA_PATHS = [
	SOURCE_PATH,
	APP_ENGINE_PATH,
	os.path.join(APP_ENGINE_PATH, 'lib', 'antlr3'),
	os.path.join(APP_ENGINE_PATH, 'lib', 'django_0_96'),
	os.path.join(APP_ENGINE_PATH, 'lib', 'fancy_urllib'),
	os.path.join(APP_ENGINE_PATH, 'lib', 'ipaddr'),
	os.path.join(APP_ENGINE_PATH, 'lib', 'jinja2'),
	os.path.join(APP_ENGINE_PATH, 'lib', 'protorpc'),
	os.path.join(APP_ENGINE_PATH, 'lib', 'markupsafe'),
	os.path.join(APP_ENGINE_PATH, 'lib', 'webob_0_9'),
	os.path.join(APP_ENGINE_PATH, 'lib', 'webapp2'),
	os.path.join(APP_ENGINE_PATH, 'lib', 'yaml', 'lib'),
	os.path.join(APP_ENGINE_PATH, 'lib', 'simplejson'),
	os.path.join(APP_ENGINE_PATH, 'lib', 'google.appengine._internal.graphy'),
]

sys.path = EXTRA_PATHS + sys.path

from google.appengine.dist import use_library
use_library('django', '1.2')

from w3.base import *
import w3.page
import w3c.page
from django.utils import simplejson as json
from w3c.compress	import w3Js

# change working dir so that w3 scripts will work
os.chdir("%sw3c/handler" % SOURCE_PATH)

strAppPath 	= "%sapp/" % SOURCE_PATH

strPage = PAGE

#------------------------------------------------------------------------------#
# clean target folder
#------------------------------------------------------------------------------#

print 'cleaning target folder'
shutil.rmtree(TARGET_PATH, True)

#------------------------------------------------------------------------------#
# copy i18n folder
#------------------------------------------------------------------------------#
#print 'add folder : app/js/i18n'
#shutil.copytree('%sjs/i18n' % strAppPath, '%s/app/js/i18n' % TARGET_PATH)

#------------------------------------------------------------------------------#
# compile application
#------------------------------------------------------------------------------#

objCompiler = w3c.page.compiler()

# load page def
objPageDef = json.load(open('%spage/%s.w3' % (strAppPath, strPage)), object_pairs_hook=dotDict)

# add name to page def
objPageDef.name = strPage

# add forms to page def
for strForm in objPageDef.form:
	objPageDef.form[strForm] = dotDict()
	objPageDef.form[strForm].py = None
	objPageDef.form[strForm].frm	= open('%sview/%s.frm' % (strAppPath, strForm))
	try:			
		objPageDef.form[strForm].js = open('%sview/%s.js' % (strAppPath, strForm))
	except:
		objPageDef.form[strForm].js = None

# add file structure to page def
objPageDef.file			= dotDict()
objPageDef.file.js		= dotDict()
objPageDef.file.css		= dotDict()
objPageDef.file.page	= dotDict()

# add js
for strName in objPageDef.js:
	objPageDef.file.js[strName] = w3Js.compress(open('%sjs/%s.js' % (strAppPath, strName)).read())
	
# add css
for strName in objPageDef.css:
	objPageDef.file.css[strName] = open('%scss/%s.css' % (strAppPath, strName)).read()
	
# add scripts to page def
if 'script' in objPageDef:
	if 'head' in objPageDef.script:
		for strScript in objPageDef.script.head:
			objPageDef.script.head[strScript] = open('%sscript/%s.js' % (strAppPath, strScript))
	if 'body' in objPageDef.script:
		for strScript in objPageDef.script.body:
			objPageDef.script.body[strScript] = open('%sscript/%s.js' % (strAppPath, strScript))
		
# add html to page def		
if 'html' in objPageDef:
	try:
		objHtml = open(strAppPath + 'html/' + objPageDef.html + '.html')
		objPageDef.html = objHtml
	except:
		pass

# compile GAE page
objFile = objCompiler.compileGAE(objPageDef)

# for each file
for strFile in objFile:
	# get folder
	strFolder = os.path.dirname(strFile)
	
	# skip files in the root folder
	#if strFolder == '/' or strFolder == '':
		#print 'skipping file %s' % strFile
	#	continue;
	
	# make folder	
	try:
		os.makedirs("%s/%s" % (TARGET_PATH, strFolder))
	except:
		pass
	
	# write file
	open('%s/%s' % (TARGET_PATH, strFile.strip('/')), 'w').write(objFile[strFile])
	
	print 'add file   : %s' % strFile

#------------------------------------------------------------------------------#
# copy license files
#------------------------------------------------------------------------------#
print 'add file   : w3/gpl-2.0.txt'
shutil.copy('%s/license/gpl-2.0.txt' % SOURCE_PATH, '%s/w3/' % TARGET_PATH)

#------------------------------------------------------------------------------#
# remove unneeded files
#------------------------------------------------------------------------------#

print ''
print 'removing unneeded files'
shutil.rmtree('%s/app/page' % TARGET_PATH, True)

#------------------------------------------------------------------------------#
# done
#------------------------------------------------------------------------------#

print ''
print 'deployment package built'
print ''
print 'files are located in : %s' % TARGET_PATH
print ''
