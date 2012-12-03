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
from w3 import template
from w3.base 	import *
from w3c 		import widget
from w3c.parse	import formJs
from w3c.parse	import formPy

#----------------------------------------------------------------------#
# compiler class
#----------------------------------------------------------------------#
class compiler(dotDict):
	def __init__(self, bolSafeMode=False):
		dotDict.__init__(self)
		self.bolSafeMode		= bolSafeMode
		self.compiler			= dotDict()
		self.compiler.widget	= widget.compiler(bolSafeMode)
		self.command			= []
	
	#------------------------------------------------------------------#
	# set form id
	#------------------------------------------------------------------#
	def setId(self, objDef, strName):
		objDef['id'] = ID_PREFIX + ID_SEPARATOR + strName
		return objDef['id']
		
	#------------------------------------------------------------------#
	# render form
	#------------------------------------------------------------------#
	def render(self, strForm, strFrm, strJsEvents=None, strPyEvents=None):
		print ''
		print self.compileW3(strForm, strFrm, strJsEvents, strPyEvents)
		
		
	#------------------------------------------------------------------#
	# compile a W3 form
	#------------------------------------------------------------------#
	def compileW3(self, strForm, strFrm, strJsEvents=None, strPyEvents=None):
		
		# compile form
		self.compile(strForm, strFrm, strJsEvents, strPyEvents)
		
		# build return object
		objForm			= dotDict()
		objForm.name	= self.objForm.name								#
		objForm.id		= self.objForm.id								#

		#objForm.html	= template.renderString(self.objForm.html, {})	#
		objForm.js		= self.objForm.js
		#objForm.style	= self.renderStyle()							#
		objForm.event	= self.strJsEvents								#
		if 'parent' in self.objForm:									#
			objForm.parent	= self.objForm.parent						#
		
		strReturn = ''
		strReturn += '<script type="text/javascript">\n<!--\n'
		strReturn += 'if (w3.ui.views["%s"]){w3.ui.views["%s"].removeChild(w3.ui.views["%s"], true);};\n' % (objForm.name, objForm.name, objForm.name)
		strReturn += '//-->\n</script>\n'
		strReturn += self.compiler.widget.renderChildHtml(self.objFrm, self.objForm.html, self.objForm.event)
		strReturn += '<script type="text/javascript">\n<!--\n'
		strReturn += 'w3.ui.createView("%s", %s);\n' % (objForm.name, json.dumps(objForm.js))
		strReturn += objForm.event
		strReturn += "%s.trigger('load');\n" % widget.id2js(objForm.id);
		strReturn += '//-->\n</script>\n'
		
		# return the form
		return strReturn

	#------------------------------------------------------------------#
	# compile form
	#------------------------------------------------------------------#
	def compile(self, strForm, strFrm, strJsEvents=None, strPyEvents=None):
		self.strForm 		= strForm
		self.strJsEvents	= ''
		self.strPyEvents	= ''
		
		# convert form to object
		try:
			self.objFrm 	= json.load(strFrm, object_pairs_hook=dotDict)
		except:
			self.objFrm 	= json.loads(strFrm, object_pairs_hook=dotDict)

		# parse the js events
		if strJsEvents:
			objJs = formJs.parse(strJsEvents)
			self.objJsEvents		= objJs.event
			self.command			= objJs.command
			self.strJsEvents		= objJs.code
			
		# parse the py events
		if strPyEvents:
			objPy = formPy.parse(strPyEvents)
			self.strPyEvents		= objPy.code
			self.objPyEvents		= objPy.event
		
		# setup widget compiler
		self.compiler.widget.setEvents(None, self.objJsEvents, self.objPyEvents)
		
		# compile the form
		self.objForm = self.compiler.widget.compile(self.objFrm, None, 'form')
		
		# compile .py
		#self.objForm.py	= self.compilePy(self.objFrm)
		
		# parent
		if 'parent' in self.objFrm:
			self.objForm.parent = self.objFrm.parent
		else:
			self.objForm.parent = False
		
	#------------------------------------------------------------------#
	# compile .py
	#------------------------------------------------------------------#
	def compilePy(self, objFrm):
		# id
		strPy  = "objForm.id = '%s'\n" % objFrm.id 
		
		# parent
		if 'parent' in objFrm:
			strPy  += "objForm.parent = '%s'\n" % objFrm.parent
			
		
		# style
		if 'style' in objFrm:
			# px style
			arrStyle = ['left', 'right', 'top', 'bottom', 'width', 'height']
			for strStyle in arrStyle:
				if strStyle in objFrm.style:
					strPy += 'objForm.style.%s = "%s"\n' % (strStyle, widget.addPx(objFrm.style[strStyle]))
			
			# visibility
			if objFrm.style.visible == False:
				strPy += 'objForm.style.visibility = "hidden"\n'
			else:
				strPy += 'objForm.style.visibility = "inherit"\n'
				
		return strPy
		
	#------------------------------------------------------------------#
	# render style
	#------------------------------------------------------------------#
	def renderStyle(self):
		objStyle 	= dotDict();
		
		# style
		if 'style' in self.objFrm:
			# px style
			arrStyle = ['left', 'right', 'top', 'bottom', 'width', 'height', 'margin', 'marginLeft', 'marginRight', 'marginTop', 'marginBottom', 'maxWidth', 'minWidth', 'maxHeight', 'minHeight']
			for strStyle in arrStyle:
				if strStyle in self.objFrm.style:
					objStyle[strStyle] = widget.addPx(self.objFrm.style[strStyle])
			
			# non-px style
			arrStyle = ['cursor', 'overflow', 'float', 'clear']
			for strStyle in arrStyle:
				if strStyle in self.objFrm.style:
					objStyle[strStyle] = self.objFrm.style[strStyle]
			
			# visibility
			#if self.objFrm.style.visible == False:
			#	objStyle.visibility = 'hidden'
			#else:
			#	objStyle.visibility = 'inherit'
			objStyle.visible = self.objFrm.style.visible;
		return objStyle
		
		
	#------------------------------------------------------------------#
	# dump form
	#------------------------------------------------------------------#
	def dump(self):
		print "###############################################################################################"
		print self.strForm + ".py"
		print "###############################################################################################"
		print ""
		print self.objForm.py
		print ""
		print "###############################################################################################"
		print self.strForm + ".js"
		print "###############################################################################################"
		print ""
		print self.objForm.js
		print ""
		print "###############################################################################################"
		print self.strForm + ".event.js"
		print "###############################################################################################"
		print ""
		print self.strJsEvents
		print ""
		print "###############################################################################################"
		print self.strForm + ".event.py"
		print "###############################################################################################"
		print ""
		print self.strPyEvents
		print ""
		print "###############################################################################################"
		print self.strForm + ".phtml"
		print "###############################################################################################"
		print ""
		print self.objForm.html
		print ""
