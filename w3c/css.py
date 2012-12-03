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

#----------------------------------------------------------------------#
# compiler class
#----------------------------------------------------------------------#
class compiler(dotDict):
	def __init__(self, bolSafeMode=False):
		dotDict.__init__(self)
		self.bolSafeMode	= bolSafeMode
	
	#------------------------------------------------------------------#
	# compile css
	#------------------------------------------------------------------#
	def compile(self, objPage):
		strReturn = ''

		# compile w3
		strReturn += self.compileW3(objPage.css)
		
		# compile widgets
		strReturn += self.compileWidgets(objPage.widget)
		
		return strReturn
		
	#------------------------------------------------------------------#
	# compile w3
	#------------------------------------------------------------------#
	def compileW3(self, arrFiles):
		# set the path
		strPath 	= '../../w3c/inc/w3/css/'
		
		strReturn	= ''
		
		# for each file
		for strName in arrFiles:
			strFile = "%s.css" % strName
			strReturn += open(strPath + strFile).read()
		
		#return strReturn
		return strReturn
		
	#------------------------------------------------------------------#
	# compile widgets
	#------------------------------------------------------------------#	
	def compileWidgets(self, arrWidget):

		strReturn = ''

		# for each widget type used in the application
		for strWidget in arrWidget:
			strReturn += self.compileWidget(strWidget)
			
		return strReturn
		
	#------------------------------------------------------------------#
	# compile widget
	#------------------------------------------------------------------#	
	def compileWidget(self, strWidget):
		
		# get widget
		objWidget = filesystem.getWidget(strWidget, self.bolSafeMode)
		
		# return css
		return objWidget.css
