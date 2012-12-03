#------------------------------------------------------------------------------#
#  
# (c) Copyright 2012 APPMO LTD
# 
# author    : Flame Herbohn (and contributors)
# download  : https://github.com/appmode/
# license   : GNU AGPL 3.0 (see license/agpl-3.0.txt for details)
#
#------------------------------------------------------------------------------#
    
import os
os.environ['DJANGO_SETTINGS_MODULE'] = 'settings'

from google.appengine.dist import use_library
use_library('django', '1.2')

import sys
import cgi
import cgitb
from google.appengine.ext.webapp import template
from w3.base import *
import w3.page
import w3c.page
from django.utils import simplejson as json

########################################################################
#import w3c.filesystem
#w3c.filesystem.clearCache()
########################################################################

# enable cgi errors
cgitb.enable()

# get page name
strPathInfo	= os.environ.get('PATH_INFO').strip('/')
arrPathInfo	= strPathInfo.split('/')
strPage		= arrPathInfo.pop(0)
strAppPath 	= '../../app/'
strW3Path	= '../../w3/'

# get content name
try:
	strContent = arrPathInfo[0]
except:
	strContent = 'index'

# set default page
if strPage == '':
	strPage = 'index'
	
# register our custom template filters
template.register_template_library('w3.templateFilter')

# load source page details (json)
if os.path.exists(strAppPath + 'page/' + strPage + '.w3'):
	objCompiler = w3c.page.compiler()
	# load page def
	objPageDef = json.load(open(strAppPath + 'page/' + strPage + '.w3'), object_pairs_hook=dotDict)
	
	# add name to page def
	objPageDef.name = strPage
	
	# add path to page def
	objPageDef.path = arrPathInfo
	
	# check for ajax requests
	if os.environ.get('HTTP_X_REQUESTED_WITH') == "XMLHttpRequest":
		objPageDef.requestType = 'ajax'
	else:
		objPageDef.requestType = 'html5'
	
	# run content controler
	# if content is enabled
	if 'content' in objPageDef:
		objPageDef.contentName = strContent
		w3Content = False
		# if the requested content is allowed
		if strContent in objPageDef.content:
			# use requested content if it exists
			strFilePath = '%scontent/%s.py' % (strAppPath, objPageDef.content[strContent])
			if os.path.exists(strFilePath):
				try:
					execfile(strFilePath)
					objPageDef.contentFolder = "%s/" % strFilePath.rpartition('/')[0]
				except:
					#TODO!!!! error?
					raise
					
		# if we didn't manage to load any content
		if not w3Content:
			# use default content if it exists
			if 'default' in objPageDef.content:
				strFilePath = '%scontent/%s.py' % (strAppPath, objPageDef.content.default)
				try:
					execfile(strFilePath)
					objPageDef.contentFolder = "%s/" % strFilePath.rpartition('/')[0]
				except:
					#TODO!!!! error?
					raise

		# run the render method of the content controler
		try:
			getattr(w3Content, 'render')(objPageDef)
		except SystemExit:
			sys.exit()
		except:
			#TODO!!!! error?
			raise
	
	# don't compile forms for ajax requests
	if objPageDef.requestType == 'ajax':
		objPageDef.form = dotDict()
	else:
		# add forms to page def
		for strForm in objPageDef.form:
			objPageDef.form[strForm] = dotDict()
			objPageDef.form[strForm].frm	= open(strAppPath + 'view/' + strForm + '.frm')
			try:			
				objPageDef.form[strForm].js = open(strAppPath + 'view/' + strForm + '.event.js')
			except:
				objPageDef.form[strForm].js = None
			try:
				objPageDef.form[strForm].py = open(strAppPath + 'view/' + strForm + '.py')
			except:
				objPageDef.form[strForm].py = None
				
		# add scripts to page def
		if 'script' in objPageDef:
			if 'head' in objPageDef.script:
				for strScript in objPageDef.script.head:
					objPageDef.script.head[strScript] = open(strAppPath + 'script/' + strScript + '.js')
			if 'body' in objPageDef.script:
				for strScript in objPageDef.script.body:
					objPageDef.script.body[strScript] = open(strAppPath + 'script/' + strScript + '.js')
		
		# add html to page def		
		if 'html' in objPageDef:
			try:
				objHtml = open(strAppPath + 'html/' + objPageDef.html + '.html')
				objPageDef.html = objHtml
			except:
				pass	
		
	# compile page
	objPage = w3.page.pageData(objCompiler.compileW3(objPageDef))
	
# load default page ????
else:
	# set up empty page object
	objPage = w3.page.pageData()
	objPageDef = dotDict()

# load page
if os.path.exists(strAppPath + 'page/' + strPage + '.py'):
	# load the page details
	execfile(strAppPath + 'page/' + strPage + '.py')

# render the page template
if 'template' in objPageDef:
	strTemplate = objPageDef.template
elif 'requestType' in objPageDef:
	strTemplate = objPageDef.requestType
else:
	strTemplate = "html5"
	
print template.render('%stemplate/%s.phtml' % (strW3Path, strTemplate), objPage)
