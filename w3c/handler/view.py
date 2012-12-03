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

from w3 import template
from w3c import form
from w3.base import dotDict

# get form name
strPathInfo		= os.environ.get('PATH_INFO').strip('/')
arrPathInfo		= strPathInfo.split('/')
strForm			= arrPathInfo[2].split('.')[0]
strPath 		= '../../app/view/'

# load the form
if strForm:
	# read in .frm
	try:
		strFrm = open(strPath + strForm + '.frm')
	except:
		strFrm = None
	
	# read in .js
	try:
		strJsEvents = open(strPath + strForm + '.js')
	except:
		strJsEvents = None
		
	# read in .py
	try:
		strPyEvents = open(strPath + strForm + '.py')
	except:
		strPyEvents = None
		
	# load the compiler
	compiler = form.compiler()
	
	# compile the form
	strView = compiler.compileW3(strForm, strFrm, strJsEvents, strPyEvents)

	# load form py
	objData = dotDict()
	if os.path.exists(strPath + strForm + '.load.py'):
		execfile(strPath + strForm + '.load.py')

	# render template
	print ''
	print template.renderString(strView, objData)
