#------------------------------------------------------------------------------#
#  
# (c) Copyright 2012 APPMO LTD
# 
# author    : Flame Herbohn (and contributors)
# download  : https://github.com/appmode/
# license   : GNU AGPL 3.0 (see license/agpl-3.0.txt for details)
#
#------------------------------------------------------------------------------#

from django.utils import simplejson as json
from w3.base 	import *
import re

#TODO!!!! : strings need to be tokenized before running the regex
#TODO!!!! : coments need to be removed before running the regex

#----------------------------------------------------------------------#
# regular expressions
#----------------------------------------------------------------------#

_objRegEx = dotDict()

# regex to find js method names
# returns: method name
_objRegEx.method = re.compile(r"^def[ \t]*([\w_]+)[ \t]*\(", re.M)

# regex to find //# commands
# returns: (strCommand, strPath)
#	strCommand	command	eg 'USE'
#	strPath		path	eg. '/lib/publisher/libname' | '/lib/publisher/setName/mediaName.ext'
#_objRegEx.command = re.compile(r"^[ \t]*//#[ \t]*([\w]+)[ \t]+([/\w\._\-]+)", re.M)



#----------------------------------------------------------------------#
# parser
#----------------------------------------------------------------------#
def parse(strInput):
	objReturn 			= dotDict()
	objReturn.event		= dict()

	try:
		objReturn.code = strInput.read()
	except:
		objReturn.code = strInput
		
	# find method names ????
	for strMethod in _objRegEx.method.findall(objReturn.code):
		arrMethod	= strMethod.split('_')
		strEvent	= arrMethod.pop()
		if arrMethod[0] == '':
			arrMethod.pop(0)
			arrMethod[0] = '_%s' % arrMethod[0]
		
		if strEvent.startswith("on"):
			strId	= ID_PREFIX + ID_SEPARATOR + ID_SEPARATOR.join(arrMethod)
			if not strId in objReturn.event:
				objReturn.event[strId] = {}
			objReturn.event[strId][strEvent] = True
			
	return objReturn
	
	
	
#OLD : TO BE REMOVED
	
#----------------------------------------------------------------------#
# compiler class
#----------------------------------------------------------------------#
class parser(dotDict):
	
	# regex to split py methods
	# returns [header, method_def, indent, method_name, method_contents, method_def, indent, method_name, method_contents, ...]
	# method params are discarded
	regPyMethod = re.compile(r"((^[ \t]*)def[ \t]*([\w_]+)[ \t]*\([ \t\w,]*\)[ \t]*:[ \t]*)", re.M)
	
	# regex to extract and replace js input object references in Python event handlers
	# returns: 
	#	.group(0)	whole match
	#	.group(1)	.js (where . is a single char)
	#	.group(2)	js method or property
	regJsInput 	= re.compile(r"([^\w\.\]#]js)\.([$\w]+(?:(?:\.[$\w]+)*(?:[ \t]*(?:\([^)]*\)|\[[^]]+\]))*)*)")
		
	#------------------------------------------------------------------#
	# parse py events
	#------------------------------------------------------------------#
	def parse(self, strName, strInput):
		self.strName	= strName
		self.pyEvents 	= dotDict()
		self.pyHead		= ''
		
		try:
			strCode = strInput.read()
		except:
			strCode = strInput
		
		if strCode:
			# split python methods
			arrPyMethod 	= self.regPyMethod.split(strCode)
			# get header
			self.pyHead = arrPyMethod.pop(0)
			
			# get methods
			strPrevMethod 	= ''
			intPrevIndent	= 0
			while (len(arrPyMethod) > 3):
				strDef		= arrPyMethod.pop(0)
				strIndent	= arrPyMethod.pop(0)
				intIndent 	= len(strIndent.replace("\t", "    "))
				strMethod	= arrPyMethod.pop(0)
				strBody		= arrPyMethod.pop(0).replace("\n", "\n ")
				
				if strPrevMethod and (intIndent > intPrevIndent):
					# nested def (wtf? add it to the prev method)
					self.pyEvents[strPrevName].py += "\n " + strDef + strBody
				else:
					# valid def
					self.pyEvents[strMethod]		= dotDict()
					self.pyEvents[strMethod].py	= "\n def " + strMethod + "(self, js):" + strBody
					strPrevMethod	= strMethod
					intPrevIndent	= intIndent
			
			# replace js input object references in the code
			for strMethod in self.pyEvents:
				self.jsParamClean()
				self.pyEvents[strMethod].py 	= self.regJsInput.sub(self.jsParamAdd, self.pyEvents[strMethod].py)
				self.pyEvents[strMethod].param	= self.jsParamGet()
				self.jsParamClean()
				
			
			return True
		return False
	
	#------------------------------------------------------------------#
	# clean out the js param cache
	#------------------------------------------------------------------#
	def jsParamClean(self):
		self.arrJsParam = []
	
	#------------------------------------------------------------------#
	# add a new js param to the cache
	#------------------------------------------------------------------#
	def jsParamAdd(self, objMatch):
		try:
			# check if we already have this one
			strIndex = str(self.arrJsParam.index(objMatch.group(2)))
		except:
			# if not, add it to the list
			strIndex = str(len(self.arrJsParam))
			self.arrJsParam.append(objMatch.group(2))
		# return a placeholder
		return objMatch.group(1) + "[" + strIndex + "]"
	
	#------------------------------------------------------------------#
	# return the contents of the js param cache as a js string
	#------------------------------------------------------------------#
	def jsParamGet(self):
		return json.dumps("[" + ",".join(self.arrJsParam) + "]")
		
	#------------------------------------------------------------------#
	# get a single method
	#------------------------------------------------------------------#
	def getMethod(self, strMethod):
		try:
			return self.pyEvents[strMethod].py
		except:
			return false
			
	#------------------------------------------------------------------#
	# get a single set of params
	#------------------------------------------------------------------#
	def getParams(self, strMethod):
		try:
			return self.pyEvents[strMethod].param
		except:
			return false
	
	#------------------------------------------------------------------#
	# get code
	#------------------------------------------------------------------#
	def getCode(self):
		strReturn	 = ''
		
		# header
		strReturn	+= self.pyHead
		
		# class definition
		#strReturn	+= "\nclass " + self.strName + "(object):\n"
		
		# events
		for strMethod in self.pyEvents:
			strReturn	+= self.pyEvents[strMethod].py 	

		# footer
		#strReturn	+= "\nw3Module = " + self.strName + "()\n"
		
		return strReturn
		
	#------------------------------------------------------------------#
	# get events
	#------------------------------------------------------------------#
	def getEvents(self):
		objReturn	 = dict()
		
		# events
		for strMethod in self.pyEvents:
			# get the id & event
			arrMethod	 = strMethod.rpartition('_')
			strEvent	 = arrMethod[2]
			strId		 = ID_PREFIX + ID_SEPARATOR + self.strName + ID_SEPARATOR
			strId		+= arrMethod[0].replace('_', ID_SEPARATOR)
			
			# add to the return object
			if not strId in objReturn:
				objReturn[strId] = dict()
			objReturn[strId][strEvent] = self.pyEvents[strMethod].param
		
		return objReturn
		
	#------------------------------------------------------------------#
	# dump code
	#------------------------------------------------------------------#
	def dumpCode(self):
		print self.getClass()

	#------------------------------------------------------------------#
	# dump javascript
	#------------------------------------------------------------------#
	def dumpEvents(self):
		objEvent = self.getEvents()
		for strId in objEvent:
			print strId
			for strEvent in objEvent[strId]:
				print "	" + strEvent + "	: " + objEvent[strId][strEvent]
