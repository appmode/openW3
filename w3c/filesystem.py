#------------------------------------------------------------------------------#
#  
# (c) Copyright 2012 APPMO LTD
# 
# author    : Flame Herbohn (and contributors)
# download  : https://github.com/appmode/
# license   : GNU AGPL 3.0 (see license/agpl-3.0.txt for details)
#
#------------------------------------------------------------------------------#

import sys
import os
import zlib
import zipfile
import cStringIO
from google.appengine.api import urlfetch
from w3.base	import *

#----------------------------------------------------------------------#
# cache object
#----------------------------------------------------------------------#
_objFSCache			= dotDict()
_objFSCache.widget	= dotDict()

W3C_BASE_PATH		= "../../w3c/inc/"

#----------------------------------------------------------------------#
# clear cache
#----------------------------------------------------------------------#
def clearCache():
	_objFSCache.widget	= dotDict()

#----------------------------------------------------------------------#
# get widget
#----------------------------------------------------------------------#
def getWidget(strPath, bolSafeMode=False):
	if bolSafeMode:
		checkSafe(strPath)
		
	# get uncached widget
	if strPath not in _objFSCache.widget:
		
		# open widget folder
		objFolder = openWidgetFolder(strPath)
			
		# create widget container
		objWidget = dotDict()
		
		# type & name
		objWidget.type = strPath
		objWidget.name = strPath.split('/').pop()
		
		# template
		try:
			objWidget.phtml = objFolder.getFileStr("%s.phtml" % objWidget.name)
		except:
			objWidget.phtml = False
				
		# jhtml template
		try:
			objWidget.jhtml = objFolder.getFileStr("%s.jhtml" % objWidget.name)
		except:
			objWidget.jhtml = ""
		
		# default
		try:
			objWidget.default = objFolder.getFileStr("%s.default" % objWidget.name)
		except:
			objWidget.default = ""
			objWidget.objDefault = {}
		
		# jsc
		try:
			objWidget.jsc = objFolder.getFileStr("%s.jsc" % objWidget.name)
		except:
			objWidget.jsc = False
				
		# js
		try:
			objWidget.js = objFolder.getFileStr("%s.js" % objWidget.name)
		except:
			objWidget.js = False
		
		#.extends ??
		#.events
		#.commands
		
		# css
		try:
			objWidget.css = objFolder.getFileStr("%s.css" % objWidget.name)
		except:
			objWidget.css = ''
		
		# add widget to cache
		_objFSCache.widget[strPath] = objWidget
	
		# close folder
		objFolder.close()
	
	# return widget from cache
	return _objFSCache.widget[strPath]
		
#----------------------------------------------------------------------#
# open a widget folder
#----------------------------------------------------------------------#
def openWidgetFolder(strAlias, bolSafeMode=False):
	if bolSafeMode:
		checkSafe(strAlias)
		
	# get fs path
	arrPath = strAlias.strip('/').split('/')
	strPath	= "widget/%s/%s/%s" % (arrPath.pop(0), arrPath.pop(0), arrPath.pop(0))
	
	# open folder
	return folder(strPath, strPath)
		
#----------------------------------------------------------------------#
# open a package folder
#----------------------------------------------------------------------#
def openPackageFolder(strAlias, bolSafeMode=False):
	if bolSafeMode:
		checkSafe(strAlias)
		
	# get fs path
	arrPath			= strAlias.strip('/').split('/')
	strType			= arrPath.pop(0)
	strPublisher	= arrPath.pop(0)
	strFolder		= arrPath.pop(0)
	if strType == 'widget':
		strFolder	= "%s/%s"				% (strFolder, arrPath.pop(0))
	strPath			= "pkg/%s/%s/%s"	% (strPublisher, strType, strFolder)
	strAlias		= "%s/%s/%s"			% (strType, strPublisher, strFolder)
	
	# open file
	if len(arrPath):
		return folder(strPath, strAlias, "/".join(arrPath))
	
	# open folder
	return folder(strPath, strAlias)

#----------------------------------------------------------------------#
# check if the requested path is safe
#----------------------------------------------------------------------#
def checkSafe(strPath):
	arrPath	= strPath.strip('/').split('/')[0:2]
	while arrPath:
		if arrPath.pop(0).startswith('_'):
			raise IOError("attempt to open protected folder")
	
#----------------------------------------------------------------------#
# folder class
#----------------------------------------------------------------------#
#
# provides an abstraction layer to transparently load files from either
# a zip file (prefered) or from a folder.
#
#----------------------------------------------------------------------#
class folder(dotDict):
	def __init__(self, strPath, strAlias, strFile=None, bolSafeMode=False):
		dotDict.__init__(self)

		self.strPath		= W3C_BASE_PATH + strPath.strip('/')
		self.strAlias		= strAlias.strip('/')
		if strFile:
			self.strFile	= strFile.strip('/')
			self.arrFiles	= [self.strFile]
		
		# check path
		self._checkPath(strPath)
		
		# block private folders
		if bolSafeMode:
			checkSafe(self.strPath)
		
		strZipPath = "%s.zip" % self.strPath
		
		#open remote file
		# widget/[user@]service:<publisher>/<collection/<widget>
		# pkg/[user@]service:<publisher>/<type>/<collection>[/<path>]
		# pkg/[user@]service:<publisher>/widget/<collection/<widget>
		arrPath = strPath.strip('/').split('/')
		arrPub  = arrPath[1].split(':')
		if len(arrPub) == 2:
			arrService = arrPub[0].split('@')
			if len(arrService) == 2:
				strUser    = arrService[0]
				strService = arrService[1]
			else:
				strUser    = 'appmode'
				strService = arrPub[0]
			# check for valid service types & build URL
			if strService == 'github':
				#'https://raw.github.com/<user>/appMode/master/w3c/inc/widget/<publisher>/<collection>/<widget>'
				#'https://raw.github.com/<user>/appMode/master/w3c/inc/pkg/<publisher>/<type>/<collection>'
				self.strRemote = 'https://raw.github.com/%s/appMode/master/w3c/inc/%s/%s/%s/%s' % (strUser, arrPath[0], arrPub[1], arrPath[2], arrPath[3])
				if arrPath[0] == 'pkg' and arrPath[2] == 'widget':
					# special case for widget packages
					self.remote = '%s/%s' % (self.remote, arrPath[4])
			else:
				raise IOError("unknown remote service : %s" % arrPath[0])
		# open zip file
		elif os.path.isfile(strZipPath):
			self.zipFolder = zipfile.ZipFile(strZipPath, 'r')		
		# or open file system
		elif os.path.isdir(self.strPath):
			self.strFolder = self.strPath
		# bad folder
		else:
			raise IOError("folder not found : %s" % self.strPath)
		
	def __del__(self):
		self.close()
		
	#------------------------------------------------------------------#
	# unlock (allow private files to be loaded)
	#------------------------------------------------------------------#
	def unlock(self):
		self.bolLocked = False
			
	#------------------------------------------------------------------#
	# close folder
	#------------------------------------------------------------------#
	def close(self):
		if self.zipFolder:
			self.zipFolder.close()
		
	#------------------------------------------------------------------#
	# get the path for a file in a package
	#------------------------------------------------------------------#
	def getAlias(self, strFile=None):
		if strFile:
			return "%s/%s" % (self.strAlias, strFile)
		else:
			return "%s/" % (self.strAlias)
			
	#------------------------------------------------------------------#
	# list the files contained in a folder
	#------------------------------------------------------------------#
	#
	# lists files recursively
	#
	#------------------------------------------------------------------#
	def listFiles(self):
		if not self.arrFiles:
			# list files in zip
			if self.zipFolder:
				self.arrFiles = self.zipFolder.namelist()
				
			# list files in file system
			elif self.strFolder:
				self.arrFiles = []
				intLen = len(self.strFolder) + 1
				for strFolder, arrVoid, arrFiles in os.walk(self.strFolder):
					for strFile in arrFiles:
						self.arrFiles.append(os.path.join(strFolder[intLen:], strFile))
				
		return self.arrFiles
				
	#------------------------------------------------------------------#
	# get file (object)
	#------------------------------------------------------------------#
	def getFile(self, strPath=None):
		# check path
		strPath = self._checkPath(strPath)
			
		# get file from zip
		if self.zipFolder:
			return cStringIO.StringIO(self.zipFolder.read(strPath))
				
		# get file from file system
		elif self.strFolder:
			strFilePath = "%s/%s" % (self.strFolder, strPath)
			return  open(strFilePath, 'rb')
			
		# get remote file
		elif self.strRemote:
			return cStringIO.StringIO(self.getFileStr(strPath))
		
	#------------------------------------------------------------------#
	# get file (string)
	#------------------------------------------------------------------#
	def getFileStr(self, strPath=None):
		# check path
		strPath = self._checkPath(strPath)
			
		# get file from zip
		if self.zipFolder:
			return self.zipFolder.read(strPath)
				
		# get file from file system
		elif self.strFolder:
			strFilePath = "%s/%s" % (self.strFolder, strPath)
			objFile = open(strFilePath, 'rb')
			strFile = ''
			for strLine in objFile:
				strFile += strLine
			objFile.close()
			return strFile
		
		# get remote file
		elif self.strRemote:
			#return '%s/%s' % (self.strRemote, strPath)
			strUrl = '%s/%s' % (self.strRemote, strPath)
			objFile = urlfetch.fetch(strUrl)
			if objFile.status_code == 200:
				return objFile.content
 			raise IOError("file not found : %s" % strUrl)
 			
	#------------------------------------------------------------------#
	# check path
	#------------------------------------------------------------------#
	def _checkPath(self, strPath):
		if not strPath:
			strPath = self.strFile
		
		if not strPath:
			raise IOError("missing path")
		
		strPath = strPath.strip('/')
		
		if ".." in strPath:
			raise IOError("attempt to open parent folder")
				
		return strPath
