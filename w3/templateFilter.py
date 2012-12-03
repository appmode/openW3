#------------------------------------------------------------------------------#
#  
# (c) Copyright 2012 APPMO LTD
# 
# author    : Flame Herbohn (and contributors)
# download  : https://github.com/appmode/
# license   : GNU AGPL 3.0 (see license/agpl-3.0.txt for details)
#
#------------------------------------------------------------------------------#

from django.utils.safestring import mark_safe
from google.appengine.ext import webapp
 
register = webapp.template.create_template_register()

# multiply
def filterMultiply(value, arg):
    return int(value) * int(arg)
register.filter('multiply', filterMultiply)

# divide
def filterDivide(value, arg):
    return int(value) / int(arg)
register.filter('divide', filterDivide)

# subtract
def filterSubtract(value, arg):
    return int(value) - int(arg)
register.filter('subtract', filterSubtract)

# addPx
def filterAddPx(value):
	strValue = str(value).lower().strip()
	
	# don't add px in some cases
	if (strValue	== '' 
	or strValue 	== 'auto'
	or strValue.endswith('%')
	or strValue.endswith('px')
	or strValue.endswith('em')):
		return strValue
	
	# add px to anything else
	return strValue + 'px'
filterAddPx.is_safe = True
register.filter('addPx', filterAddPx)

# indent
def filterIndent(value, arg):
    return str(value).strip().replace("\n", "\n" + "".ljust(int(arg),"\t")) 
filterIndent.is_safe = True
register.filter('indent', filterIndent)

#def style(value, arg):

# optional
def filterOptional(value, arg="%s"):
	if not value:
		return ""
	if value == True:
		value = "true"
	else:
		#!!!!
		pass
	try:
		return mark_safe(arg % value)
	except:
		return mark_safe(arg)
register.filter('optional', filterOptional)

# optional if true
def filterOptionalIfTrue(value, arg="%s"):
	if value == True or value == "True" or value == "true":
		return ""
	if value == False or value == "False":
		value = "false"
	else:
		#!!!!
		pass
	try:
		return mark_safe(arg % value)
	except:
		return mark_safe(arg)
register.filter('optionalIfTrue', filterOptionalIfTrue)

# only if true
def filterIfTrue(value, arg="%s"):
	if value == True or value == "True" or value == "true":
		try:
			return mark_safe(arg % 'true')
		except:
			return mark_safe(arg)
	return ""
register.filter('ifTrue', filterIfTrue)

# only if false
def filterIfFalse(value, arg="%s"):
	if value == False or value == "False" or value == "false":
		try:
			return mark_safe(arg % 'false')
		except:
			return mark_safe(arg)
	return ""
register.filter('ifFalse', filterIfFalse)

# bool
def filterBool(value):
	if not value or value == "false" or value == "False":
		return "false"
	return "true"
filterBool.is_safe = True
register.filter('bool', filterOptional)

# return empty if None or False
def filterEmptyNone(value):
	if not value:
		return ""
	return value
filterEmptyNone.is_safe = True
register.filter('emptyNone', filterEmptyNone)

# split path & return a single element of the path
def filterPathPart(value, arg=0):
	value = value.strip('/')
	return value.split('/')[arg]
register.filter('pathPart', filterPathPart)

# describe a path
def filterStartswith(value, arg=0):
	value = value.strip('/')
	return value.split('/')[arg]
register.filter('pathPart', filterPathPart)

# add a data-i18n attribute
def filterDataI18n(value):
	if value:
		return "data-i18n=%s" % value
	return ""
register.filter('dataI18n', filterDataI18n)

# add a span with data-i18n attribute (and optional title)
def filterSpanI18n(value, arg=None):
	if value:
		if arg:
			return mark_safe("<span data-i18n=%s>%s</span>" % (value, arg))
		return mark_safe("<span data-i18n=%s></span>" % value)
	if arg:
		return mark_safe("<span>%s</span>" % arg)
	return ""
register.filter('spanI18n', filterSpanI18n)

# force a value to be a list
def filterMakeList(value):
	if value and type(value) != list:
		value = [value]
	return value
register.filter('makeList', filterMakeList)

# map 2 lists to form a list of tuples
def filterZipLongest(value, arg):
	if value == None:
		value = []
	elif type(value) != list:
		value = [value]
		
	if arg == None:
		arg = [] 
	elif type(arg) != list:
		arg = [arg]

	return map(None, value, arg)
register.filter('zipLongest', filterZipLongest)
