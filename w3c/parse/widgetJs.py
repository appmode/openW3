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
_objRegEx.method = re.compile(r"^[ \t]*this\.([\w_]+)[ \t]*=[ \t]*function[ \t]*\(", re.M)

# regex to find //# commands
# returns: (strCommand, strPath)
#	strCommand	command	eg 'USE'
#	strPath		path	eg. 'lib/publisher/libname' | 'lib/publisher/setName/mediaName.ext'
_objRegEx.command = re.compile(r"^[ \t]*//#[ \t]*([\w]+)[ \t]+([/\w\._\-\{\}\*]+)", re.M)

# regex to find subsitution name
# returns:
#		group(0)	entire match
#		group(1)	substitution name
_objRegEx.sub = re.compile(r"\{([\w_\.\*]+)\}")


#----------------------------------------------------------------------#
# parser
#----------------------------------------------------------------------#
def parse(strInput):
	objReturn = dotDict()
	objReturn.method		= dict()
	objReturn.event			= dict()
	objReturn.command		= []
	objReturn.dynCommand	= []
	
	try:
		objReturn.code = strInput.read()
	except:
		objReturn.code = strInput
	
	# find //# commands	
	for strCommand, strPath in _objRegEx.command.findall(objReturn.code):
		strCommand = strCommand.lower()
		if strCommand == 'extends':
			if strPath.lower() == "none":
				objReturn.extends = None
			else:
				objReturn.extends = strPath
		elif strCommand.startswith('dyn'):
			strSub = _objRegEx.sub.search(strPath).group(1)
			objReturn.dynCommand.append((strCommand[3:], strSub, strPath))
		else:
			objReturn.command.append((strCommand, strPath))
		
	# find method names ????
	for strMethod in _objRegEx.method.findall(objReturn.code):
		objReturn.method[strMethod] = True
		if strMethod.startswith("_on"):
			objReturn.event[strMethod.lstrip('_')] = True
		
	return objReturn
