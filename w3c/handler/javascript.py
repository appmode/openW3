#------------------------------------------------------------------------------#
#  
# (c) Copyright 2012 APPMO LTD
# 
# author    : Flame Herbohn (and contributors)
# download  : https://github.com/appmode/
# license   : GNU AGPL 3.0 (see license/agpl-3.0.txt for details)
#
#------------------------------------------------------------------------------#
    
from google.appengine.dist import use_library
use_library('django', '1.2')

from w3.base	import *
from django.utils import simplejson as json
import w3c.page
import os
import mimetypes

# get path & page
strPathInfo	= os.environ.get('PATH_INFO').strip('/')
arrPathInfo	= strPathInfo.split('/')
strFolder = arrPathInfo.pop(0)
strAppPath 	= '../../app/'

# DO NOT REMOVE
print "Content-Type: text/javascript"
print ""

#----------------------------------------------------------------------#
# W3 JS
#----------------------------------------------------------------------#

if strFolder == 'w3':
	# get page name
	strPage = arrPathInfo.pop(1).split('.').pop(0)
	
	# load source page details (json)
	strPath = '%spage/%s.w3' % (strAppPath, strPage)
	if os.path.exists(strPath):
		# load page def
		objPageDef = json.load(open(strPath), object_pairs_hook=dotDict)

		# load compiler
		objCompiler = w3c.page.compiler()
		
		# add name to page def
		objPageDef.name = strPage
			
		# add forms to page def
		for strForm in objPageDef.form:
			strPath = '%sview/%s' % (strAppPath, strForm)
			objPageDef.form[strForm] = dotDict()
			objPageDef.form[strForm].frm	= open(strPath + '.frm')
			try:			
				objPageDef.form[strForm].js = open(strPath + '.event.js')
			except:
				objPageDef.form[strForm].js = None
			try:
				objPageDef.form[strForm].py = open(strPath + '.py')
			except:
				objPageDef.form[strForm].py = None
				
		# compile page
		print objCompiler.compileW3js(objPageDef)
		
#----------------------------------------------------------------------#
# APP JS [CURRENTLY NOT USED]
#----------------------------------------------------------------------#
elif strFolder == 'js':
	# get file name
	strFile = arrPathInfo.pop(0).split('.').pop(0)
	
	# load file
	strPath = '%sjs/%s.js' % (strAppPath, strFile)
	if os.path.exists(strPath):
		print open(strPath).read()
