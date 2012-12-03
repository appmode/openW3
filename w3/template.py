#------------------------------------------------------------------------------#
#  
# (c) Copyright 2012 APPMO LTD
# 
# author    : Flame Herbohn (and contributors)
# download  : https://github.com/appmode/
# license   : GNU AGPL 3.0 (see license/agpl-3.0.txt for details)
#
#------------------------------------------------------------------------------#


#----------------------------------------------------------------------#
# Template module
#----------------------------------------------------------------------#
#
# Allows rendering of templates from either a string or a filesystem 
# path. Also provides caching of template strings.
#
# usage:
#	template.loadString(strName, strTemplate)
#	template.render(strName)
#
# template.renderString() will render a template from a string without
# caching the template. It should only ever be used if rendering a
# dynamically generated template which will never need to be rendered 
# again.
#
#----------------------------------------------------------------------#

import django.template
from google.appengine.ext.webapp import template

_objTemplateCache = {}

#----------------------------------------------------------------------#
# render template (from cache)
#----------------------------------------------------------------------#
def render(strName, objData, bolDebug=False):
	if type(_objTemplateCache[strName]) == type(" "):
		# template from file (render with appEngine template method) 
		return template.render(_objTemplateCache[strName], objData, bolDebug)
	else:
		# template from string (render with django template method)
		return _objTemplateCache[strName].render(django.template.Context(objData))

#----------------------------------------------------------------------#
# render template from string (without caching)
#----------------------------------------------------------------------#
def renderString(strTemplate, objData, bolDebug=False):
	objTemplate = django.template.Template(strTemplate)
	return objTemplate.render(django.template.Context(objData))
	
#----------------------------------------------------------------------#
# load template from a string
#----------------------------------------------------------------------#
def loadString(strName, strTemplate):
	if strName not in _objTemplateCache:
		_objTemplateCache[strName] = django.template.Template(strTemplate)

#----------------------------------------------------------------------#
# load template from a path
#----------------------------------------------------------------------#
def loadPath(strName, strPath):
	_objTemplateCache[strName] = str(strPath)

#----------------------------------------------------------------------#
# check if a template is cached
#----------------------------------------------------------------------#
def isCached(strName):
	if strName in _objTemplateCache:
		return True
	return False
	
#----------------------------------------------------------------------#
# register a template library
#----------------------------------------------------------------------#
def register_template_library(strName):
	return template.register_template_library(strName)
