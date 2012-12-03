#------------------------------------------------------------------------------#
#  
# (c) Copyright 2012 APPMO LTD
# 
# author    : Flame Herbohn (and contributors)
# download  : https://github.com/appmode/
# license   : GNU AGPL 3.0 (see license/agpl-3.0.txt for details)
#
#------------------------------------------------------------------------------#

from w3c 		import form
from w3c 		import javascript
from w3c 		import css
from django.utils import simplejson as json
from w3c 		import filesystem
from w3c.parse	import appJs
from w3c.parse	import appCSS
from w3.base	import *
from google.appengine.ext.webapp import template

#----------------------------------------------------------------------#
# compiler class
#----------------------------------------------------------------------#
class compiler():
	def __init__(self, bolSafeMode=False):
		self._strW3Path		= '../../w3/'
		self.compiler		= dotDict()
		self.compiler.js	= javascript.compiler(bolSafeMode)
		self.compiler.css	= css.compiler(bolSafeMode)
		self.bolSafeMode	= bolSafeMode
		
		self.init(pageData())
	
	def init(self, objPage):
		self._objPage			= objPage
		self._objFile			= orderedDict()
		self._objUse			= orderedDict()
		self._objJs				= orderedDict()
		self._objCss			= orderedDict()
		self.compiler.form		= form.compiler(self.bolSafeMode)
		self.compiler.widget	= self.compiler.form.compiler.widget
	
		# compiler commands
		self.command			= []
	
	#------------------------------------------------------------------#
	# add a form
	#------------------------------------------------------------------#
	def addForm(self, strName, strFrm, strJsEvents=None, strPyEvents=None, bolLoad=False):
		# compile form
		self._objFile['/app/view/' + strName + '.w3v'] = self.compiler.form.compileW3(strName, strFrm, strJsEvents, strPyEvents)
		# check if we need to load the form
		if bolLoad:
			self._objPage.form[strName] = True
		elif self.compiler.form.objFrm.preload == True:
			self._objPage.form[strName] = True
				
	#------------------------------------------------------------------#
	# add css
	#------------------------------------------------------------------#
	def addCss(self, strName, strContent, bolLoad=True):
		if bolLoad:
			self._objCss['app/css/' + strName] = True
		self._objFile['/app/css/' + strName] = strContent
		
		objCss = appCSS.parse(strContent)
		self.command += objCss.command
		
	#------------------------------------------------------------------#
	# add javascript
	#------------------------------------------------------------------#
	def addJs(self, strName, strContent, bolLoad=True):
		if bolLoad:
			self._objJs['app/js/' + strName] = True
		self._objFile['/app/js/' + strName] = strContent
	
		objJs = appJs.parse(strContent)
		self.command += objJs.command
	
	#------------------------------------------------------------------#
	# compile Ui
	#------------------------------------------------------------------#
	def compileUi(self):	

		strAppName = self._objPage.info.name

		# load forms
		for strForm in self._objPage.form:
			self._objPage.head.script += "w3.ui.loadView(\"%s\");\n" % strForm
		
		# work out the javascript to compile
		# x w3 base
		# w3 mods (widget based requirements, and other requirements??)
		#		order may be important (eg, dhtml sub mods)
		#TODO!!!! ask the widget/form compilers if we need to load any extra w3 mods
		# for now a full list of required w3 mods must be passed to the compiler
		
		# get widgets used by the compiler
		self._objPage.widget = self.compiler.widget.getUsedWidgets()
		
		# run widget constructor commands and add supplementary files
		for strWidget in self._objPage.widget:
			# add in a //#USEFUL command for the widget supplementary files
			self.runCommand('useful', "widget/%s" % strWidget)
			# add in commands from widget
			for strCommand, strPath in self._objPage.widget[strWidget].command:
				self.runCommand(strCommand, strPath)
		
		# run compiler (//#) commands from form compiled widgets (dyn commands)
		for strCommand, strPath in self.compiler.widget.command:
			self.runCommand(strCommand, strPath)
			
		# compile w3 javascript
		strJsPath							= 'w3/js/%s.js' % strAppName
		self._objFile[strJsPath]			= self.compiler.js.compile(self._objPage)
		self._objPage.head.js[strJsPath]	= True
		
		# compile w3 css
		strCssPath							= 'w3/css/%s.css' % strAppName
		self._objFile[strCssPath]			= self.compiler.css.compile(self._objPage)	
		self._objPage.head.css[strCssPath]	= True
			
		# run compiler (//#) commands from form events .js
		for strCommand, strPath in self.compiler.form.command:
			self.runCommand(strCommand, strPath)
			
		# run any other compiler (//#) commands
		for strCommand, strPath in self.command:
			self.runCommand(strCommand, strPath)
		
		# add user css
		for strPath in self._objCss:
			self._objPage.head.css[strPath] = True
			
		#add user js
		for strPath in self._objJs:
			self._objPage.head.js[strPath] = True
			
		# compile index
		strTemplatePath = self._strW3Path + 'template/html5.phtml'
		self._objFile['/index.html'] = template.render(strTemplatePath, self._objPage)
		
		return self._objFile


	#------------------------------------------------------------------#
	# compile Google AppEngine back-end
	#------------------------------------------------------------------#
	def compileGAE(self, objPage):		
		# init w3
		self._initW3(objPage)
		
		if 'file' in objPage:
			# add js
			for strName in objPage.file.js:
				self.addJs('%s.js' % strName, objPage.file.js[strName], objPage.js[strName])
				
			# add css
			for strName in objPage.file.css:
				self.addCss('%s.css' % strName, objPage.file.css[strName], objPage.css[strName])
			
			# add page .py
			for strName in objPage.file.page:
				self._objFile['/app/page/%s.py' % strName] = objPage.file.page[strName]

		# compile UI
		self.compileUi()
		
		# add modules
		for strName in objPage.module:
			self._objFile['/app/module/%s.py' % strName] = objPage.module[strName]
			
		# add models
		for strName in objPage.model:
			self._objFile['/app/model/%s.py' % strName] = objPage.model[strName]
			
		# compile w3c
		self._objFile['/app/page/%s.w3c' % objPage.name] = json.dumps({'head':self._objPage.head, 'body':self._objPage.body})
		
		# add form loaders
		for strForm in objPage.form:
			if objPage.form[strForm].load:
				self._objFile['/app/view/%s.load.py' % strForm] = objPage.form[strForm].load.read()
		
		# return files object
		return self._objFile
	
	#------------------------------------------------------------------#
	# compile w3 page
	#------------------------------------------------------------------#
	def compileW3(self, objPage):
		# init w3
		self._initW3(objPage)
		
		# compile
		self.compileUi()
		
		# return page object
		return self._objPage
	
	#------------------------------------------------------------------#
	# compile w3 js
	#------------------------------------------------------------------#
	def compileW3js(self, objPage):
		# init w3
		self._initW3(objPage)
		
		# get widgets used by the compiler
		self._objPage.widget = self.compiler.widget.getUsedWidgets()
		
		# compile javascript
		return self.compiler.js.compile(self._objPage)
		
	#------------------------------------------------------------------#
	# compile w3 css
	#------------------------------------------------------------------#
	def compileW3css(self, objPage):
		# init w3
		self._initW3(objPage)
		
		# get widgets used by the compiler
		self._objPage.widget = self.compiler.widget.getUsedWidgets()
		
		# compile javascript
		return self.compiler.css.compile(self._objPage)
	
	#------------------------------------------------------------------#
	# init w3 page
	#------------------------------------------------------------------#
	def _initW3(self, objPage):
		if not isinstance(objPage, dict):
			try:
				objPage = json.load(objPage, object_pairs_hook=dotDict)
			except:
				objPage = json.loads(objPage, object_pairs_hook=dotDict)
			
		# init page
		objPageW3				= pageData()
		objPageW3.head.title	= objPage.title
		objPageW3.info.name		= objPage.name
		self.init(objPageW3)
		
		# add forms
		for strForm in objPage.form:
			self.addForm(strForm, objPage.form[strForm].frm, objPage.form[strForm].js, objPage.form[strForm].py)
			
		# add w3 mods
		for strMod in objPage.w3mod:
			objPageW3.useMod(strMod)
		
		# add w3 css
		for strName in objPage.w3css:
			objPageW3.useCss(strName)
		
		# add js
		for strName in objPage.js:
			self.addJs(strName + '.js', '', objPage.js[strName])
			
		# add css
		for strName in objPage.css:
			self.addCss(strName + '.css', '', objPage.css[strName])
			
		# add info
		if 'info' in objPage:
			for strName in objPage.info:
				objPageW3.info[strName] = objPage.info[strName]
				
		# add html
		if 'html' in objPage:
			try:
				objPageW3.body.html = objPage.html.read()
			except:
				objPageW3.body.html = objPage.html
		
		# add scripts
		if 'script' in objPage:
			# add head scripts
			if 'head' in objPage.script:
				for strName in objPage.script.head:
					try:
						objPageW3.head.script += "%s\n" % objPage.script.head[strName].read()
					except:
						objPageW3.head.script += "%s\n" % objPage.script.head[strName]
						
			# add body scripts
			if 'body' in objPage.script:
				for strName in objPage.script.body:
					try:
						objPageW3.body.script += "%s\n" % objPage.script.body[strName].read()
					except:
						objPageW3.body.script += "%s\n" % objPage.script.body[strName]
						
					
			
	#------------------------------------------------------------------#
	# COMPILER COMMANDS
	#------------------------------------------------------------------#

	#------------------------------------------------------------------#
	# run a command
	#------------------------------------------------------------------#
	def runCommand(self, strCommand, strPath):
		strCmd = "_command_%s" % strCommand
		if hasattr(self, strCmd):
			getattr(self, strCmd)(strPath)

	#------------------------------------------------------------------#
	# use command
	#------------------------------------------------------------------#
	def _command_use(self, strPath):
		# make sure we only use a resource once
		if strPath in self._objUse:
			return

		objFolder	= filesystem.openPackageFolder(strPath, self.bolSafeMode)
		arrFiles	= objFolder.listFiles()
		for strFile in arrFiles:
			strFilePath = objFolder.getAlias(strFile)
			if strFilePath not in self._objFile:
				self._objFile[strFilePath] = objFolder.getFileStr(strFile)
		
		# mark this resource as used
		self._objUse[strPath] = True

	#------------------------------------------------------------------#
	# useful command
	#------------------------------------------------------------------#
	def _command_useful(self, strPath):
		try:
			return self._command_use(strPath)
		except:
			pass
			
	#------------------------------------------------------------------#
	# load command
	#------------------------------------------------------------------#
	def _command_load(self, strPath):
		self._command_use(strPath)
		
		if strPath in self._objFile:
			if strPath.endswith('.css'):
				self._objPage.head.css[strPath] = True
			if strPath.endswith('.js'):
				self._objPage.head.js[strPath] = True

#----------------------------------------------------------------------#
# pageData class
#----------------------------------------------------------------------#
class pageData(dotDict):
	def __init__(self):
		dotDict.__init__(self)
		# html template data
		self.info			= dotDict()
		self.head			= dotDict()
		self.head.title		= "w3 application"
		self.head.css		= dotDict()
		self.head.js		= dotDict()
		self.head.meta		= dotDict()
		self.head.style		= ""
		self.head.script	= ""
		self.body			= dotDict()
		self.body.html		= ""
		self.body.script	= ""		
		# default html meta data
		self.head.meta.charset		= "UTF-8"
		self.head.meta.author		= "w3"
		self.head.meta.generator	= "w3"
		# use
		self.css			= dotDict()
		self.mod			= dotDict()
		self.widget			= dotDict()
		self.form			= dotDict()
		
		# info
		self.info.target	= 'mobile'
		
	def useMod(self, strName):
		self.mod[strName] = True
		
	def useCss(self, strName):
		self.css[strName] = True

		
