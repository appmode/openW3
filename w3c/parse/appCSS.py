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
_objRegEx.url = re.compile(r"url\([\"']?(/[^)\"']+)[\"']?\)", re.M)

#----------------------------------------------------------------------#
# parser
#----------------------------------------------------------------------#
def parse(strInput):
	objReturn = dotDict()
	objReturn.command		= []
	
	if strInput:
		# find local urls and make commands
		for strPath in _objRegEx.url.findall(strInput):
			objReturn.command.append(('use', strPath))
		
	return objReturn
