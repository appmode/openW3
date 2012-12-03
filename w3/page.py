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
from w3.base import *
from django.utils import simplejson as json
from google.appengine.api import users
from google.appengine.ext.webapp import template

def requireUser():
	objUser = users.get_current_user()
	if objUser:
		return objUser
	else:
		requireLogin()

def getUser():
	return users.get_current_user()

def requireLogin():
	strUrl = getUrl()
	print "Location:", users.create_login_url(strUrl)
	sys.exit()
	
def getUrl():
	return "%s://%s%s%s" % (getProtocol(), getServerName(True), getPath(), getQueryString('?'))
	
def getQueryString(strPrefix=''):
	strQuery = os.environ.get('QUERY_STRING')
	if strQuery:
		return strPrefix + strQuery
	else:
		return ''

def getPath():
	return os.environ.get('PATH_INFO')

def getServerName(bolPort=False):
	if True == bolPort:
		strPort = os.environ.get('SERVER_PORT')
		if '443' != strPort and '80' != strPort:
			return os.environ.get('SERVER_NAME') + ":" + strPort
	return os.environ.get('SERVER_NAME')

def getProtocol():
	strPort = os.environ.get('SERVER_PORT')
	if '443' == strPort:
		return 'https'
	else:
		return 'http'
		

#----------------------------------------------------------------------#
# pageData class
#----------------------------------------------------------------------#
class pageData(dotDict):
	def __init__(self, objPage={}):
		dotDict.__init__(self)
		# html template data
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
		self.mod			= dotDict()
		self.widget			= dotDict()
		self.form			= dotDict()
		
		# decode objPage from a file or string
		if not isinstance(objPage, dict):
			try:
				objPage = json.load(objPage, object_pairs_hook=dotDict)
			except:
				objPage = json.loads(objPage, object_pairs_hook=dotDict)
		
		# values from objPage
		for strSection in objPage:
			if strSection in self:
				for strKey in objPage[strSection]:
					if strKey in self[strSection]:
						if isinstance(self[strSection][strKey], dict):
							for strItem in objPage[strSection][strKey]:
								self[strSection][strKey][strItem] = objPage[strSection][strKey][strItem]
						else:
							self[strSection][strKey] = objPage[strSection][strKey]
					else:
						self[strSection][strKey] = objPage[strSection][strKey]
		
	def useMod(self, strName):
		self.mod['strName'] = True
		
	def add(self, strSection, strItem, strKey, strValue=True):
		if isinstance(self[strSection][strItem], dict):
			self[strSection][strItem][strKey] = strValue
		else:
			if len(self[strSection][strItem]) > 0:
				self[strSection][strItem] += "\n"
			self[strSection][strItem] += strKey

	def set(self, strSection, strItem, strKey, strValue=True):
		if isinstance(self[strSection][strItem], dict):
			self[strSection][strItem] = dotDict()
			self[strSection][strItem][strKey] = strValue
		else:
			self[strSection][strItem] = strKey
