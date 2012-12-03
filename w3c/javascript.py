#------------------------------------------------------------------------------#
#  
# (c) Copyright 2012 APPMO LTD
# 
# author    : Flame Herbohn (and contributors)
# download  : https://github.com/appmode/
# license   : GNU AGPL 3.0 (see license/agpl-3.0.txt for details)
#
#------------------------------------------------------------------------------#

from w3.base	import *
from w3c 		import filesystem
from w3c.parse	import widgetPhtml
from w3c.parse	import widgetJs
import os


#----------------------------------------------------------------------#
# compiler class
#----------------------------------------------------------------------#
class compiler(dotDict):
	def __init__(self, bolSafeMode=False):
		dotDict.__init__(self)
		self.bolSafeMode	= bolSafeMode
	
	#------------------------------------------------------------------#
	# render JavaScript
	#------------------------------------------------------------------#
	def render(self, strPage):
		print self.compile(strPage)
		
	#------------------------------------------------------------------#
	# compile JavaScript
	#------------------------------------------------------------------#
	def compile(self, objPage):
		
		# get copyright notice
		strReturn = open("../../w3c/inc/w3/js/copyright.%s.js" % objPage.info.target).read()

		# compile w3
		strReturn += self.compileW3Base()
		strReturn += self.compileW3Mods(objPage.mod)

		# compile widgets
		strReturn += self.compileWidgets(objPage.widget)
		
		return strReturn
		
	#------------------------------------------------------------------#
	# compile w3 Base
	#------------------------------------------------------------------#
	def compileW3Base(self):
		# set the path
		strPath 	= '../../w3c/inc/w3/js/'

		strReturn	= ''
		
		arrFiles	= []
		arrFiles.append('prototype')
		arrFiles.append('json2')
		arrFiles.append('w3')
		
		# for each file
		for strName in arrFiles:
			strFile = "%s.js" % strName
			if os.path.isfile(strPath + strFile + 'c'):
				strFile += "c"
			strReturn += open(strPath + strFile).read()
		
		return strReturn
		
	#------------------------------------------------------------------#
	# compile w3 Mods
	#------------------------------------------------------------------#
	def compileW3Mods(self, arrFiles):
		# set the path
		strPath 	= '../../w3c/inc/w3/js/'
		
		strReturn	= ''
		
		# for each file
		for strName in arrFiles:
			strFile = "%s.mod.js" % strName
			if os.path.isfile(strPath + strFile + 'c'):
				strFile += "c"
			strReturn += open(strPath + strFile).read()
		
		return strReturn

	#------------------------------------------------------------------#
	# compile widgets
	#------------------------------------------------------------------#	
	def compileWidgets(self, arrWidget, strDefaultExtends='w3/base/style'):

		strReturn = ''

		# for each widget type used in the application
		for strWidget in arrWidget:
			strReturn += self.compileWidget(strWidget, strDefaultExtends)
			
		return strReturn
		
	#------------------------------------------------------------------#
	# compile widget
	#------------------------------------------------------------------#	
	def compileWidget(self, strWidget, strDefaultExtends='w3/base/style'):
		
		# get widget
		objWidget = filesystem.getWidget(strWidget, self.bolSafeMode)

		strReturn = ''
		
		# use a pre-compiled widget if we have one
		if objWidget.jsc:
			return objWidget.jsc
		else:
			# by default we use the default extends
			if strWidget != strDefaultExtends:
				if objWidget.name != "base":
					objWidget.extends = strDefaultExtends
			
			# send the header
			strReturn += 'var $objConstructor = function(){\n'
			
			# Add Widget Definition
			if objWidget.js:
				strReturn += objWidget.js
				
				# parse js
				objJs = widgetJs.parse(objWidget.js)
				objWidget.command		= objJs.command
				objWidget.dynCommand	= objJs.dynCommand
				objWidget.event			= objJs.event
				#objWidget.method		= objJs.method
				if 'extends' in objJs:
					objWidget.extends 	= objJs.extends
									
			# build style objects (from widget .phtml files)
			if objWidget.phtml:
				objPhtml = widgetPhtml.parse(objWidget.phtml)
				strReturn += "this._objElementsByStyleGroup = %s;"	% objPhtml.styleGroup
				strReturn += "this._objElementsByStyle = %s;" 		% objPhtml.style

			# extends
			if objWidget.extends:
				strExtends = ", \"%s\"" % objWidget.extends
			else:
				strExtends = ''
					
			# add the footer
			strReturn += '};\n'
			strReturn += 'w3.ui.register("' + strWidget + '", $objConstructor' + strExtends +');\n'

			# cache the compiled widget constructor
#			objWidget.jsc = strReturn

		return strReturn
