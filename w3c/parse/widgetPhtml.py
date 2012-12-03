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

# set regular expression to find element ids (in widget .phtml file)
# .group(1) will contain the element id (including the leading underscore)
_objRegEx.element = re.compile(r"\sid\s*=\s*['\"]\{\{\s*widget\.id\s*\}\}(_[a-zA-Z0-9]+)['\"]")

# set regular expression to find style groups
# .group(1) will contain the name of the style group
_objRegEx.styleGroup = re.compile(r"{\{\s*style.([a-zA-Z]+)\s*(:?\|[^\}]+)*\}\}")

# set regular expression to find a style
# .group(1) will contain the name of the style
_objRegEx.style = re.compile(r"{\{\s*widget.style.([a-zA-Z]+)\s*(:?\|[^\}]+)*\}\}")


#----------------------------------------------------------------------#
# parser
#----------------------------------------------------------------------#
def parse(strInput):
	objReturn = dotDict()
	
	strElementId = ''
	objStyle = dict()
	objStyleGroup = dict()
	for strLine in strInput.split("\n"):
		# find the current element id
		objMatch = _objRegEx.element.search(strLine)
		if objMatch:
			strElementId = objMatch.group(1)
		# find style group
		objMatch = _objRegEx.styleGroup.search(strLine)
		if objMatch:
			strMatch = objMatch.group(1)
			if strMatch not in objStyleGroup:
				objStyleGroup[strMatch] = list()
			objStyleGroup[strMatch].append(strElementId)
		# find style
		objMatch = _objRegEx.style.search(strLine)
		if objMatch:
			strMatch = objMatch.group(1)
			if strMatch not in objStyle:
				objStyle[strMatch] = list()
			objStyle[strMatch].append(strElementId)
	objReturn.styleGroup	= objStyleGroup
	objReturn.style			= objStyle
	
	return objReturn
