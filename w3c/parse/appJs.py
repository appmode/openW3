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

# regex to find //# commands
# returns: (strCommand, strPath)
#	strCommand	command	eg 'USE'
#	strPath		path	eg. '/lib/publisher/libname' | '/lib/publisher/setName/mediaName.ext'
_objRegEx.command = re.compile(r"^[ \t]*//#[ \t]*([\w]+)[ \t]+([/\w\._\-\{\}\*]+)", re.M)

#----------------------------------------------------------------------#
# parser
#----------------------------------------------------------------------#
def parse(strInput):
	objReturn = dotDict()
	objReturn.command		= []
	
	try:
		objReturn.code = strInput.read()
	except:
		objReturn.code = strInput
	
	if objReturn.code:
		# find //# commands	
		for strCommand, strPath in _objRegEx.command.findall(objReturn.code):
			strCommand = strCommand.lower()
			objReturn.command.append((strCommand, strPath))
		
	return objReturn
