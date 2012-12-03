#------------------------------------------------------------------------------#
#  
# (c) Copyright 2012 APPMO LTD
# 
# author    : Flame Herbohn (and contributors)
# download  : https://github.com/appmode/
# license   : GNU AGPL 3.0 (see license/agpl-3.0.txt for details)
#
#------------------------------------------------------------------------------#

from w3.base 	import *
import re

#----------------------------------------------------------------------#
# regular expressions
#----------------------------------------------------------------------#

_objRegEx = dotDict()

# regex to find js method names
# returns: method name
_objRegEx.method = re.compile(r"^[ \t]*ui\.([\w\._]+)[ \t]*=[ \t]*function[ \t]*\(", re.M)

# regex to find //# commands
# returns: (strCommand, strPath)
#	strCommand	command	eg 'USE'
#	strPath		path	eg. '/lib/publisher/libname' | '/lib/publisher/setName/mediaName.ext'
_objRegEx.command = re.compile(r"^[ \t]*//#[ \t]*([\w]+)[ \t]+([/\w\._\-]+)", re.M)



#----------------------------------------------------------------------#
# parser
#----------------------------------------------------------------------#
def parse(strInput):
	objReturn 			= dotDict()
	#objReturn.method	= dict()
	objReturn.event		= dict()
	
	try:
		objReturn.code = strInput.read()
	except:
		objReturn.code = strInput
	
	# find //# commands	
	objReturn.command = _objRegEx.command.findall(objReturn.code)
		
	# find method names ????
	for strMethod in _objRegEx.method.findall(objReturn.code):
		#objReturn.method[strMethod] = True
		arrMethod	= strMethod.split('.')
		strEvent	= arrMethod.pop()
		if strEvent.startswith("on"):
			strId	= ID_PREFIX + ID_SEPARATOR + ID_SEPARATOR.join(arrMethod)
			if not strId in objReturn.event:
				objReturn.event[strId] = {}
			objReturn.event[strId][strEvent] = True
		
	return objReturn
