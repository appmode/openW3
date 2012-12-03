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
from django.utils.safestring import mark_safe
from w3			import template
from w3.base 	import *
from w3c		import javascript
from w3c 		import filesystem

#------------------------------------------------------------------#
# convert a widget id to a js reference
#------------------------------------------------------------------#
def id2js(strId):
	return strId.replace(ID_PREFIX, 'ui', 1).replace(ID_SEPARATOR, '.')

#------------------------------------------------------------------#
# convert a widget path to an id
#------------------------------------------------------------------#
def path2id(arrPath):
	return ID_PREFIX + ID_SEPARATOR + ID_SEPARATOR.join(arrPath)

#------------------------------------------------------------------#
# add px to a value
# allowed  : '', px, em, %, auto
#------------------------------------------------------------------#
def addPx(strValue):
	strValue = str(strValue).lower().strip()

	if (strValue	== ''
	or strValue 	== 'auto'
	or strValue.endswith('%')
	or strValue.endswith('px')
	or strValue.endswith('em')):
		return strValue

	return strValue + 'px'

#----------------------------------------------------------------------#
# compiler class
#----------------------------------------------------------------------#
class compiler(dotDict):
	def __init__(self, bolSafeMode=False):
		dotDict.__init__(self)
		self.strPath		= '../../w3c/inc/widget/'
		self.bolSafeMode	= bolSafeMode

		# ordered list (object) of widgets used by the compiler
		self.objWidgetTypes	= dotDict()

		self.compiler		= dotDict()
		self.compiler.js	= javascript.compiler(bolSafeMode)
		self.command		= []

		# register our custom template filters
		template.register_template_library('w3.templateFilter')

	#------------------------------------------------------------------#
	# compile widget
	#------------------------------------------------------------------#
	def compile(self, objDef, strParent=None, strPrefix=None, objParent={}):
		strPath		= self.strPath
		objReturn 	= dotDict()

		# cache flags
		#if '_FLAGS' in objDef:
		#	self._FLAGS = objDef._FLAGS
		#else:
		#	self._Flags = False

		# get name
		objReturn.name 	= objDef.name

		# fix type
		objDef.type = objDef.type.lower()

		# set ID
		if not objDef.id:
			objDef.id		= ID_PREFIX + ID_SEPARATOR + objDef.name
		objReturn.id		= objDef.id

		# set parent name
		if strPrefix:
			strNewParent 		= strPrefix
			if not strParent:
				strParent 		= strPrefix
		elif strParent:
			# normal widget
			strNewParent 		= strParent + '.' + objDef.name
		else:
			# no parent (single widget?)
			strParent 		= '"none"'
			strNewParent 	= objDef.name

		# merge in default properties
		objDef 			= self.mergeDefaults(objDef)

		# make sure widget has a className
		if not objDef.className:
			objDef.className = CSS_PREFIX + CSS_SEPARATOR + objDef.type.replace("/", CSS_SEPARATOR)

		# get properties
		objProperties 	= self.getProperties(objDef)

		# render children
		objChildren 	= self.renderChildren(objDef, strNewParent)

		# render style
		objStyle 		= self.renderStyle(objDef)

		# render events
		objEvents 		= self.renderEvents(objDef)
		objReturn.event	= objEvents.event.all

		# render html
		objTemplateData 			= dotDict()
		objTemplateData.parent 		= objParent
		objTemplateData.widget 		= objDef
		objTemplateData.children 	= mark_safe(objChildren.html)
		objTemplateData.style		= objStyle
		objTemplateData.event		= objEvents.event
		objReturn.html 				= self.renderTemplate(objDef, objTemplateData)

		# render js
		objReturn.js 				= objProperties
		objReturn.js.name			= objProperties.property.name
		objReturn.js.id				= objProperties.property.id
		objReturn.js.type			= objDef.type
		objReturn.js.Python			= objEvents.py

		if objChildren.js:
			objReturn.js.Children	= objChildren.js

		#if strPrefix:
		#	objReturn.js += strPrefix + " = "

		#objReturn.js = ''
		#strCreate = self.useFlag(objDef, 'jsCreateCommand', 'w3.w.create')
		#objReturn.js += strCreate + "(\"" + objDef.type + "\"," + json.dumps(objProperties) + "," + strParent + "," + objEvents.py + ");\n"

		#if objChildren.js:
		#	objReturn.js += objChildren.js



		# add in properties (used for DM widgets)
		objReturn.properties = objProperties;

		# extract widget compiler commands
		self.extractCommands(objDef)

		# return
		return objReturn

	#------------------------------------------------------------------#
	# render widget
	#------------------------------------------------------------------#
	def render(self, objWidget):
		# render the widget
		print '['
		print json.dumps(objWidget)
		print ']'

	#------------------------------------------------------------------#
	# dump widget
	#------------------------------------------------------------------#
	def dump(self, objWidget):
		print "###############################################################################################"
		print "HTML"
		print "###############################################################################################"
		print ""
		print objWidget.html
		print ""
		print "###############################################################################################"
		print "JavaScript"
		print "###############################################################################################"
		print ""
		print objWidget.js
		print ""

	#------------------------------------------------------------------#
	# get list of used widgets (as an ordered object)
	#------------------------------------------------------------------#
	def getUsedWidgets(self):
		return self.objWidgetTypes

	#------------------------------------------------------------------#
	# get (and cache) widget
	#------------------------------------------------------------------#
	def getWidget(self, strType, objDef=None):
		strType			= strType.lower().replace('.', '/')

		if strType not in self.objWidgetTypes:
			objWidget = filesystem.getWidget(strType, self.bolSafeMode)

			# defaults
			if 'objDefault' not in objWidget:
				objWidget.objDefault = json.loads(objWidget.default, object_pairs_hook=dotDict)

			# compile widget js if it's not already compiled
			if not objWidget.jsc:
				self.compiler.js.compileWidget(strType)

			# command
			if not objWidget.command:
				objWidget.command		= []

			# dynCommand
			if not objWidget.dynCommand:
				objWidget.dynCommand	= []

			# event
			if not objWidget.event:
				objWidget.event			= {}

			# methods
            #do we need them????

			# extends
			if objWidget.extends:
				objExtends = self.getWidget(objWidget.extends)
				# add extended events
				for i in objExtends.event:
					if i not in objWidget.event:
						objWidget.event[i] = objExtends.event[i]

			# py events
			#TODO!!!!

			# cache the widget (we do this at the end so widgets we extend from are cached before us)
			self.objWidgetTypes[strType] = objWidget

		return self.objWidgetTypes[strType]

	#------------------------------------------------------------------#
	# set events
	#------------------------------------------------------------------#
	def setEvents(self, objSystemEvents, objJsEvents, objPyEvents):
		# system events
		self.objSystemEvents = (
			{
				'onblur'		: 0,
				'onchange'		: 1,
				'onclick'		: 0,
				'ondblclick'	: 0,
				'onerror'		: 0,
				'onfocus'		: 0,
				'onkeydown'		: 0,
				'onkeyup'		: 0,
				'onkeypress'	: 0,
				'onmousedown'	: 0,
				'onmousemove'	: 0,
				'onmouseout'	: 0,
				'onmouseover'	: 0,
				'onmouseenter'	: 0,
				'onmouseleave'	: 0,
				'onmouseup'		: 0,
				'onresize'		: 0,
				'onselect'		: 0,
				'onunload'		: 0,
				'oncontextmenu'	: 0,
				'onselectstart'	: 0
			})
		if objSystemEvents:
			for n in objSystemEvents:
				if objSystemEvents[n]:
					self.objSystemEvents[n] = True

		# event alias list
		self.objEventAlias = (
		{
			'onmouseenter'	: 'onmouseover',
			'onmouseleave'	: 'onmouseout'
		})

		# event still list (no bubbles)
		self.objStillEvent = (
		{
			'onfocus'	: True,
			'onblur'	: True,
			'onchange'	: True
		})

		# js events
		if objJsEvents:
			self.objJsEvents	= objJsEvents
		else:
			self.objJsEvents	= dict()

		# py events
		if objPyEvents:
			self.objPyEvents	= objPyEvents
		else:
			self.objPyEvents	= dict()

	#------------------------------------------------------------------#
	# render template
	#------------------------------------------------------------------#
	def renderTemplate(self, objDef, objTemplateData):

		# work out the template to use
		strType	= objDef.type
		#strMode	= self.useFlag(objDef, 'templateMode', 'phtml')
		strMode	= 'phtml'
		strName = "widget/%s.%s" % (strType, strMode)

		# load/cache the template
		if not template.isCached(strName):
			try:
				template.loadString(strName, self.getWidget(strType)[strMode])
			except:
				return ''

		# render html from template
		strHtml = template.render(strName, objTemplateData)

		# tags to be replaced
		objReplace = {'[[':'{{',']]':'}}','[%':'{%','%]':'%}'}

		# replace template tags in html
		# note: use of .replace() should be up to 5 x faster than using
		# a single pass regex due to the small number of keys we are
		# replacing. so don't get smart and go trying to replace this.
		for n in objReplace:
			strHtml = strHtml.replace(n, objReplace[n])

		return strHtml

	#------------------------------------------------------------------#
	# render children
	#------------------------------------------------------------------#
	def renderChildren(self, objDef, strParent=None):
		objReturn 		= dotDict()
		objReturn.html	= ''
		objReturn.js	= dotDict()

		if objDef.Children:
			for strChild in objDef.Children:
				objDef.Children[strChild]		= dotDict(objDef.Children[strChild])
				# add id & name to child
				objDef.Children[strChild].id	= objDef.id + ID_SEPARATOR + strChild
				objDef.Children[strChild].name	= strChild

				# add compiler flags
				if objDef._CHILDFLAGS:
					objDef.Children[strChild]._CHILDFLAGS 	= objDef._CHILDFLAGS
					objDef.Children[strChild]._FLAGS 		= objDef._CHILDFLAGS

				# render child
				objChild 		 = self.compile(objDef.Children[strChild], strParent, None, objDef)
				objReturn.html 	+= self.renderChildHtml(objDef.Children[strChild], objChild.html, objChild.event)
				objReturn.js[strChild] 	= objChild.js
		return objReturn


	#------------------------------------------------------------------#
	# render child HTML
	#------------------------------------------------------------------#
	def renderChildHtml(self, objDef, strChildHtml, strEvents=None):

		# add html container

		# start div
		strHtml = "<div"

		# id
		strHtml += ' id="%s"\n' % objDef.id

		# class
		bolClassName = True
		if 'className' in objDef:
			strHtml += ' class="%s"\n' 	% (objDef['className'])
		else:
			bolClassName = False

		# title (tooltip)
		if 'tooltip' in objDef:
			strHtml += ' title="%s"\n' 	% (objDef['tooltip'])

		"""
		# disabled
		if objDef.disabled:
			strHtml += ' disabled="disabled"'
		elif ('style' in objDef
		and objDef.style.disabled):
			strHtml +=  disabled="disabled"'
		"""

		# render style
		objStyle 		= self.renderStyle(objDef)

		# start style
		strHtml += '	style="'

		if not 'style' in objDef:
			if bolClassName == False:
				# no style or class set for widget, set defaults
				strHtml += " position:absolute;\n"
				strHtml += " overflow:hidden;\n"
		else:
			# position
			if objDef.style.position:
				strHtml += " position: %s;\n" % (objDef.style.position)
			else:
				strHtml += " position: absolute;\n"
			if not ('ignorePosition' in objDef) or objDef.ignorePosition == False:
				if 'left' in objDef.style:
					strHtml += 		"	left:         %s;\n" 	% addPx(objDef.style.left)
				if 'right' in objDef.style:
					strHtml += 		"	right:        %s;\n" 	% addPx(objDef.style.right)
				if 'top' in objDef.style:
					strHtml += 		"	top:          %s;\n" 	% addPx(objDef.style.top)
				if 'bottom' in objDef.style:
					strHtml += 		"	bottom:       %s;\n" 	% addPx(objDef.style.bottom)

			# size
			if objDef.style.height:
				strHtml += 		"	height:       %s;\n" 	% addPx(objDef.style.height)
			if objDef.style.width:
				strHtml += 		"	width:        %s;\n" 	% addPx(objDef.style.width)

			# float
			if objDef.style.float:
				strHtml += 		"	float:        %s;\n" 	% (objDef.style.float)

			# clear
			if 'clear' in objDef.style:
				strHtml += 		"	clear:        %s;\n" 	% (objDef.style['clear'])

			# overflow
			if 'overflow' in objDef.style:
				strHtml += 		"	overflow:     %s;\n" 	% (objDef.style['overflow'])
			else:
				strHtml += 		"	overflow:     hidden;\n"

			# min & max size
			if objDef.style.maxHeight:
				strHtml += 		"	max-height:   %s;\n" 	% (objDef.style.maxHeight)
			if objDef.style.maxWidth:
				strHtml += 		"	max-width:    %s;\n" 	% (objDef.style.maxWidth)
			if objDef.style.minHeight:
				strHtml += 		"	min-height:   %s;\n" 	% (objDef.style.minHeight)
			if objDef.style.minWidth:
				strHtml += 		"	min-width:    %s;\n" 	% (objDef.style.minWidth)

			# margin
			if 'margin' in objDef.style:
				strHtml += 		"	margin:       %s;\n" 	% (objDef.style.margin)
			if 'marginTop' in objDef.style:
				strHtml += 		"	margin-top:    %s;\n" 	% (objDef.style.marginTop)
			if 'marginBottom' in objDef.style:
				strHtml += 		"	margin-bottom: %s;\n" 	% (objDef.style.marginBottom)
			if 'marginLeft' in objDef.style:
				strHtml += 		"	margin-left:   %s;\n" 	% (objDef.style.marginLeft)
			if 'marginRight' in objDef.style:
				strHtml += 		"	margin-right:  %s;\n" 	% (objDef.style.marginRight)

			# visibility
			if objDef.style.visible == False:
				strHtml += 		"	visibility:   hidden;\n"
			else:
				strHtml += 		"	visibility:   inherit;\n"
			
			# display
			if 'display' in objDef.style:
				strHtml += 		"	display:      %s;\n" % (objDef.style.display)
				
			# cursor
			if objDef.style.cursor:
				strHtml += 		"	cursor:       %s;\n" 	% (objDef.style.cursor)

			# select
			if objDef.preventSelect == True:
				strHtml  += 	"	-moz-user-select: none;\n";

		strHtml += '	'

		# styles from rendered style
		if objStyle.background:
			strHtml  += objStyle.background.replace("\n", "\n\t")
		if objStyle.border:
			strHtml  += objStyle.border.replace("\n", "\n\t")
		if objStyle.outline:
			strHtml  += objStyle.outline.replace("\n", "\n\t")
		if objStyle.opacity:
			strHtml  += objStyle.opacity.replace("\n", "\n\t")
		if objStyle.text:
			strHtml  += objStyle.text.replace("\n", "\n\t")


		# end style
		strHtml += '"'

		#events
		if strEvents:
			strHtml += "\n	"
			strHtml += strEvents.strip().replace("\n", "\n\t")

		# end div
		strHtml += "\n>\n"

		# child
		strHtml += "\t"
		strHtml += strChildHtml.strip().replace("\n", "\n\t")
		strHtml += "\n"
		# close div
		strHtml += "</div>\n"

		# return the child
		return strHtml

	#------------------------------------------------------------------#
	# render events
	#------------------------------------------------------------------#
	def renderEvents(self, objDef):
		objReturn 			= dotDict()
		objReturn.event		= dotDict()
		objReturn.event.all = ""

		objEvents	= dict()
		strId		= objDef.id
		strJsRef	= id2js(strId)

		# events may be rendered from a different widget type
		strType		= self.useFlag(objDef, 'eventType', objDef.type)

		# find events with handlers
		for strEvent in self.objSystemEvents:
			# check if we have an event handler
			if not self.objSystemEvents[strEvent]:
				# there is no default system event handler
				if not strEvent in self.getWidget(strType).event:
					# there is no widget system event handler
					if (strId not in self.objJsEvents
					or strEvent not in self.objJsEvents[strId]):
						# there is no js event handler
						if (strId not in self.objPyEvents
						or strEvent not in self.objPyEvents[strId]):
							# there is no py event handler
							# there is no event handler of this type for this widget
							continue

			# we have an event handler!
			if strEvent in self.objEventAlias:
				strEvent = self.objEventAlias[strEvent]
			objEvents[strEvent] = True

		# render html
		for strEvent in self.objSystemEvents:
			if strEvent in objEvents:
				objReturn.event[strEvent] 	 = mark_safe("%s = \"%s.trigger(event, '%s');\"" % (strEvent, strJsRef, strEvent))
				objReturn.event.all			+= objReturn.event[strEvent] + "\n";
			else:
				objReturn.event[strEvent] 	 = mark_safe("")
		objReturn.event.all = mark_safe(objReturn.event.all)

		# prevent select
		if 'preventSelect' in objDef and objDef['preventSelect']:
			strEvent = 'onselectstart'
			objReturn.event[strEvent] 	 = mark_safe("%s = \"%s.trigger(event, '%s');\"" % (strEvent, strJsRef, strEvent))

		# render py (send all .py events as there may be non-dom events
		if strId in self.objPyEvents:
			objReturn.py = json.dumps(self.objPyEvents[strId])
		else:
			objReturn.py = "{}"
		return objReturn

	#------------------------------------------------------------------#
	# get properties
	#------------------------------------------------------------------#
	def getProperties(self, objDef):
		objProperties = dotDict()
		objProperties['property'] = dotDict()

		for strProperty in objDef:
			if (strProperty == 'style'
			or strProperty == 'dhtml'
			or strProperty == 'Register'):
				objProperties[strProperty] = objDef[strProperty]
			# ignore special properties
			elif (strProperty != 'Children'
			and strProperty != 'Parent'
			and strProperty != 'Form'
			and strProperty != "Items"):
				# ignore private properties
				if strProperty[:1] != '_':
					objProperties['property'][strProperty] = objDef[strProperty]

		return objProperties

	#------------------------------------------------------------------#
	# merge defaults
	#------------------------------------------------------------------#
	def mergeDefaults(self, objDef):
		objDefault = self.getWidget(objDef.type).objDefault
		self.mergeDict(objDefault, objDef)
		return objDef

	def mergeDict(self, objFrom, objTo):
		if isinstance(objFrom, dict) and isinstance(objTo, dict):
			for i in objFrom:
				if i not in objTo:
					if isinstance(objFrom[i], dotDict):
						objTo[i] = dotDict()
					elif isinstance(objFrom[i], dict):
						objTo[i] = dict()
					elif isinstance(objFrom[i], list):
						objTo[i] = list()
					else:
						objTo[i] = objFrom[i]
						continue
				elif isinstance(objFrom[i], list):
					continue
				self.mergeDict(objFrom[i], objTo[i])
			return True
		elif isinstance(objFrom, list) and isinstance(objTo, list):
			for i in objFrom:
				if i not in objTo: #TODO!!!! : this needs some work (i will never be in objTo ????)
					if isinstance(i, dotDict):
						n = dotDict()
					elif isinstance(i, dict):
						n = dict()
					elif isinstance(i, list):
						n = list()
					else:
						objTo.append(i)
						continue
					objTo.append(n)
					self.mergeDict(i, n)
			return True
		return False

	#------------------------------------------------------------------#
	# extract commands
	#------------------------------------------------------------------#
	def extractCommands(self, objDef):
		# dynamic commands
		for strCommand, strSub, strPath in self.getWidget(objDef.type).dynCommand:
			self.extractCommand(strCommand, strSub, strPath, strSub.split('.'), objDef)
			#if strSub in objDef:
			#	if isinstance(objDef[strSub], dict) or isinstance(objDef[strSub], list):
			#		for strValue in objDef[strSub]:
			#			self.command.append((strCommand, strPath.replace("{%s}" % strSub, strValue)))
			#	else:
			#		self.command.append((strCommand, strPath.replace("{%s}" % strSub, objDef[strSub])))

		# style load commands
		if objDef.style and 'backgroundImage' in objDef.style and objDef.style.backgroundImage:
			if objDef.style.backgroundImage.startswith('image') or objDef.style.backgroundImage.startswith('icon') or objDef.style.backgroundImage.startswith('/'):
				self.command.append(('use', objDef.style.backgroundImage))

	def extractCommand(self, strCommand, strSub, strPath, arrMatch, objValue):
		strSearch = arrMatch.pop(0)
		if arrMatch:
			for i in objValue:
				if isinstance(objValue, dict):
					mixValue	= objValue[i]
				else:
					mixValue	= i
				if strSearch == '*' or strSearch == i:
					self.extractCommand(strCommand, strSub, strPath, arrMatch[:], mixValue)
		else:
			if strSearch == '*':
				for i in objValue:
					self.command.append((strCommand, strPath.replace("{%s}" % strSub, objValue[i])))
			elif isinstance(objValue[strSearch], dict) or isinstance(objValue[strSearch], list):
				for i in objValue[strSearch]:
					self.command.append((strCommand, strPath.replace("{%s}" % strSub, i)))
			else:
				self.command.append((strCommand, strPath.replace("{%s}" % strSub, objValue[strSearch])))

	#------------------------------------------------------------------#
	# render style
	#------------------------------------------------------------------#
	def renderStyle(self, objDef):

		if '_objStyle' in objDef:
			return objDef._objStyle

		objStyle = dotDict()
		objDef._objStyle = objStyle

		# disabled div to cover widget
		objStyle.disabled = ""

		objStyle.disabled += '<div id="%s_Disabled"\n' % objDef.id
		objStyle.disabled += 'style="position:absolute; left:0px; right:0px; top:0px; bottom:0px;\n';
		objStyle.disabled += 'background-color: #CCCCCC; /* for IE */ filter:alpha(opacity=60);\n';
		objStyle.disabled += '/* CSS3 standard */ opacity:0.6; /* for Mozilla */ -moz-opacity:0.6;\n';
		if objDef.disabled:
			objStyle.disabled += ' visibility:inherit;\n'
		elif ('style' in objDef
		and objDef.style.disabled):
			objStyle.disabled += ' visibility:inherit;\n'
		else:
			objStyle.disabled += ' visibility:hidden;\n'
		objStyle.disabled += '"></div>'


		if 'style' not in objDef:
			return objStyle

		# ICON (BACKGROUND IMAGE) --------------------------------------------------#
		# CSS 1; Firefox 1; Safari 1; IE 4; Netscape 4; Konqueror 3.4
		objStyle.icon = ""
		if objDef.style.icon:
			objStyle.icon += 	"background-image:                   url('%s');\n" % (str(objDef.style.icon))


		# Background	######################################################
		objStyle.background = ""

		# BACKGROUND ATTACHMENT ---------------------------------------------#
		# CSS 1; Firefox 1; Safari 1; IE 4; Netscape 6; Konqueror 3.4
		if objDef.style.backgroundAttachment:
			objStyle.background += 	"background-attachment:              %s;\n" % str(objDef.style.backgroundAttachment)

		# BACKGROUND CLIP ---------------------------------------------------#
		# CSS 3;
		if objDef.style.backgroundClip:
			objStyle.background += 	"background-clip:                    %s;\n" % str(objDef.style.backgroundClip)
			# CSS 3; Firefox 2;
			objStyle.background += 	"-moz-background-clip:               %s;\n" % str(objDef.style.backgroundClip)
			# CSS 3; Safari 3;
			objStyle.background += 	"-webkit-background-clip:            %s;\n" % str(objDef.style.backgroundClip)

		# BACKGROUND COLOR --------------------------------------------------#
		# CSS 1; Firefox 1; Safari 1; IE 4; Netscape 4; Konqueror 3.4
		if objDef.style.backgroundColor:
			objStyle.background += 	"background-color:                   %s;\n" % str(objDef.style.backgroundColor)

		# BACKGROUND IMAGE --------------------------------------------------#
		# CSS 1; Firefox 1; Safari 1; IE 4; Netscape 4; Konqueror 3.4
		if objDef.style.backgroundImage:
			objStyle.background += 	"background-image:                   url('%s');\n" % (str(objDef.style.backgroundImage))

		# BACKGROUND ORIGIN --------------------------------------------------#
		# CSS 3;
		if objDef.style.backgroundOrigin:
			objStyle.background += 	"background-origin:                  %s;\n" % str(objDef.style.backgroundOrigin)
			# CSS 3; Firefox 2;
			objStyle.background += 	"-moz-background-origin:             %s;\n" % str(objDef.style.backgroundOrigin)
			# CSS 3; Safari 3;
			objStyle.background += 	"-webkit-background-origin:          %s;\n" % str(objDef.style.backgroundOrigin)

		# BACKGROUND POSIITON -----------------------------------------------#
		# CSS 1; Firefox 1; Safari 1; IE 4; Netscape 6; Konqueror 3.4
		if objDef.style.backgroundPosition:
			objStyle.background += 	"background-position:                %s;\n" % str(objDef.style.backgroundPosition)

		# BACKGROUND REPEAT -------------------------------------------------#
		# CSS 1; Firefox 1; Safari 1; IE 4; Netscape 4;
		if objDef.style.backgroundRepeat:
			objStyle.background += 	"background-repeat:                  %s;\n" % str(objDef.style.backgroundRepeat)

		# BACKGROUND SIZE ---------------------------------------------------#
		# CSS 3;
		if objDef.style.backgroundSize:
			objStyle.background += 	"background-size:                    %s;\n" % str(objDef.style.backgroundSize)
			# CSS 3; Safari 3;
			objStyle.background += 	"webkit-background-size:             %s;\n" % str(objDef.style.backgroundSize)
			# CSS 3; Opera 9.5;
			objStyle.background += 	"o-background-size:                  %s;\n" % str(objDef.style.backgroundSize)
			# CSS 3; Konqueror 3.4;
			objStyle.background += 	"khtml-background-size:              %s;\n" % str(objDef.style.backgroundSize)

		# Borders	##########################################################
		objStyle.border = ""

		if objDef.style.border:
			objStyle.border  = 		"border:                             %s;\n" % str(objDef.style.border)

		# BORDER COLOR ------------------------------------------------------#
		# CSS 1; Firefox 1; Safari 1; IE 4; Netscape 6; Konqueror 3.4
		# CSS 3; (UPDATED)
		if objDef.style.borderColor:
			objStyle.border  = 		"border-color:                       %s;\n" % str(objDef.style.borderColor)
		if objDef.style.borderTopColor:
			objStyle.border += 		"border-top-color:                   %s;\n" % str(objDef.style.borderTopColor)
		if objDef.style.borderLeftColor:
			objStyle.border += 		"border-left-color:                  %s;\n" % str(objDef.style.borderLeftColor)
		if objDef.style.borderBottomColor:
			objStyle.border += 		"border-bottom-color:                %s;\n" % str(objDef.style.borderBottomColor)
		if objDef.style.borderRightColor:
			objStyle.border += 		"border-right- color:                %s;\n" % str(objDef.style.borderRightColor)

		# CSS 3; Firefox 2;
#		objStyle.border += "-moz-border-top-colors: 		%s;\n" % str(objDef.style.borderTopColor)
#		objStyle.border += "-moz-border-left-colors: 		%s;\n" % str(objDef.style.borderLeftColor)
#		objStyle.border += "-moz-border-bottom-colors: 		%s;\n" % str(objDef.style.borderBottomColor)
#		objStyle.border += "-moz-border-right-colors: 		%s;\n" % str(objDef.style.borderRightColor)

		# BORDER IMAGE ------------------------------------------------------#
		# CSS 3;
		if objDef.style.borderImage:
			objStyle.border  += 	"border-image:                       %s;\n" % str(objDef.style.borderImage)
			# CSS 3; Firefox 3.1 Alpha;
			objStyle.border += 		"-moz-border-image:                  %s;\n" % str(objDef.style.borderImage)
			# CSS 3; Safari 3;
			objStyle.border += 		"-khtml-border-image:                %s;\n" % str(objDef.style.borderImage)

#		objStyle.border += "border-top-image: 				%s;\n" % str(objDef.style.borderTopImage)
#		objStyle.border += "border-right-image: 			%s;\n" % str(objDef.style.borderRightImage)
#		objStyle.border += "border-bottom-image: 			%s;\n" % str(objDef.style.borderLeftImage)
#		objStyle.border += "border-top-image: 				%s;\n" % str(objDef.style.borderRightImage)

#		objStyle.border += "border-top-left-image: 			%s;\n" % str(objDef.style.borderTopLeftImage)
#		objStyle.border += "border-top-right-image: 		%s;\n" % str(objDef.style.borderTopRightImage)
#		objStyle.border += "border-bottom-left-image: 		%s;\n" % str(objDef.style.borderBottomLeftImage)
#		objStyle.border += "border-bottom-right-image: 		%s;\n" % str(objDef.style.borderBottomRightImage)


		# BORDER STYLE ------------------------------------------------------#
		# CSS 1; Firefox 1; Safari 1; IE 4; Netscape 6;
		if objDef.style.borderStyle:
			objStyle.border +=  	"border-style:                       %s;\n" % str(objDef.style.borderStyle)
		if objDef.style.borderTopStyle:
			objStyle.border +=  	"border-top-style:                   %s;\n" % str(objDef.style.borderTopStyle)
		if objDef.style.borderLeftStyle:
			objStyle.border +=  	"border-left-style:                  %s;\n" % str(objDef.style.borderLeftStyle)
		if objDef.style.borderBottomStyle:
			objStyle.border +=  	"border-bottom-style:                %s;\n" % str(objDef.style.borderBottomStyle)
		if objDef.style.borderRightStyle:
			objStyle.border +=  	"border-right-style:                 %s;\n" % str(objDef.style.borderRightStyle)

		# BORDER RADIUS (CURVED CORNERS) ------------------------------------#
		# CSS 3;
		if objDef.style.borderRadius:
			objStyle.border 	+=	"border-radius:                      %s;\n" % str(objDef.style.borderRadius)
		if objDef.style.borderTopLeftRadius:
			objStyle.border 	+=	"border-top-left-radius:             %s;\n" % str(objDef.style.borderTopLeftRadius)
		if objDef.style.borderBottomLeftRadius:
			objStyle.border 	+=	"border-bottom-left-radius:          %s;\n" % str(objDef.style.borderBottomLeftRadius)
		if objDef.style.borderTopRightRadius:
			objStyle.border 	+=	"border-top-right-radius:            %s;\n" % str(objDef.style.borderTopRightRadius)
		if objDef.style.borderBottomRightRadius:
			objStyle.border 	+=	"border-bottom-right-radius:         %s;\n" % str(objDef.style.borderBottomRightRadius)

		# CSS 3; Firefox 1;
		if objDef.style.borderRadius:
			objStyle.border 	+=	"-moz-border-radius:                 %s;\n" % str(objDef.style.borderRadius)
		if objDef.style.borderTopLeftRadius:
			objStyle.border		+=	"-moz-border-radius-topleft:         %s;\n" % str(objDef.style.borderTopLeftRadius)
		if objDef.style.borderTopRightRadius:
			objStyle.border 	+=	"-moz-border-radius-topright:        %s;\n" % str(objDef.style.borderTopRightRadius)
		if objDef.style.borderBottomLeftRadius:
			objStyle.border 	+=	"-moz-border-radius-bottomleft:      %s;\n" % str(objDef.style.borderBottomLeftRadius)
		if objDef.style.borderBottomRightRadius:
			objStyle.border 	+=	"-moz-border-radius-bottomright:     %s;\n" % str(objDef.style.borderBottomRightRadius)

		# CSS 3; Safari 1;
		if objDef.style.borderRadius:
			objStyle.border 	+=	"-webkit-border-radius:              %s;\n" % str(objDef.style.borderRadius)
		if objDef.style.borderTopLeftRadius:
			objStyle.border 	+=	"-webkit-border-top-left-radius:     %s;\n" % str(objDef.style.borderTopLeftRadius)
		if objDef.style.borderBottomLeftRadius:
			objStyle.border 	+=	"-webkit-border-bottom-left-radius:  %s;\n" % str(objDef.style.borderBottomLeftRadius)
		if objDef.style.borderTopRightRadius:
			objStyle.border 	+=	"-webkit-border-top-right-radius:    %s;\n" % str(objDef.style.borderTopRightRadius)
		if objDef.style.borderBottomRightRadius:
			objStyle.border 	+=	"-webkit-border-bottom-right-radius: %s;\n" % str(objDef.style.borderBottomRightRadius)

		# BORDER WIDTH ------------------------------------------------------#
		# CSS 1; Firefox 1; Safari 1; IE 4; Netscape 4;
		if objDef.style.borderWidth:
			objStyle.border += 		"border-width:                       %s;\n" % str(objDef.style.borderWidth)
		if objDef.style.borderTopWidth:
			objStyle.border += 		"border-top-width:                   %s;\n" % str(objDef.style.borderTopWidth)
		if objDef.style.borderLeftWidth:
			objStyle.border += 		"border-left-width:                  %s;\n" % str(objDef.style.borderLeftWidth)
		if objDef.style.borderBottomWidth:
			objStyle.border += 		"border-bottom-width:                %s;\n" % str(objDef.style.borderBottomWidth)
		if objDef.style.borderRightWidth:
			objStyle.border += 		"border-right-width:                 %s;\n" % str(objDef.style.borderRightWidth)

		# Border Radius	##########################################################
		objStyle.borderRadius = ""


			# BORDER RADIUS (CURVED CORNERS) ------------------------------------#
		# CSS 3;
		if objDef.style.borderRadius:
			objStyle.borderRadius 	+=	"border-radius:                      %s;\n" % str(objDef.style.borderRadius)
		if objDef.style.borderTopLeftRadius:
			objStyle.borderRadius 	+=	"border-top-left-radius:             %s;\n" % str(objDef.style.borderTopLeftRadius)
		if objDef.style.borderBottomLeftRadius:
			objStyle.borderRadius 	+=	"border-bottom-left-radius:          %s;\n" % str(objDef.style.borderBottomLeftRadius)
		if objDef.style.borderTopRightRadius:
			objStyle.borderRadius 	+=	"border-top-right-radius:            %s;\n" % str(objDef.style.borderTopRightRadius)
		if objDef.style.borderBottomRightRadius:
			objStyle.borderRadius 	+=	"border-bottom-right-radius:         %s;\n" % str(objDef.style.borderBottomRightRadius)

		# CSS 3; Firefox 1;
		if objDef.style.borderRadius:
			objStyle.borderRadius 	+=	"-moz-border-radius:                 %s;\n" % str(objDef.style.borderRadius)
		if objDef.style.borderTopLeftRadius:
			objStyle.borderRadius		+=	"-moz-border-radius-topleft:         %s;\n" % str(objDef.style.borderTopLeftRadius)
		if objDef.style.borderTopRightRadius:
			objStyle.borderRadius 	+=	"-moz-border-radius-topright:        %s;\n" % str(objDef.style.borderTopRightRadius)
		if objDef.style.borderBottomLeftRadius:
			objStyle.borderRadius 	+=	"-moz-border-radius-bottomleft:      %s;\n" % str(objDef.style.borderBottomLeftRadius)
		if objDef.style.borderBottomRightRadius:
			objStyle.borderRadius 	+=	"-moz-border-radius-bottomright:     %s;\n" % str(objDef.style.borderBottomRightRadius)

		# CSS 3; Safari 1;
		if objDef.style.borderRadius:
			objStyle.borderRadius 	+=	"-webkit-border-radius:              %s;\n" % str(objDef.style.borderRadius)
		if objDef.style.borderTopLeftRadius:
			objStyle.borderRadius 	+=	"-webkit-border-top-left-radius:     %s;\n" % str(objDef.style.borderTopLeftRadius)
		if objDef.style.borderBottomLeftRadius:
			objStyle.borderRadius 	+=	"-webkit-border-bottom-left-radius:  %s;\n" % str(objDef.style.borderBottomLeftRadius)
		if objDef.style.borderTopRightRadius:
			objStyle.borderRadius 	+=	"-webkit-border-top-right-radius:    %s;\n" % str(objDef.style.borderTopRightRadius)
		if objDef.style.borderBottomRightRadius:
			objStyle.borderRadius 	+=	"-webkit-border-bottom-right-radius: %s;\n" % str(objDef.style.borderBottomRightRadius)

		# Margins	##########################################################
		objStyle.margin  = ""

		# MARGINS -----------------------------------------------------------#
		# CSS 1; Firefox 1; Safari 1; IE 4; Netscape 4;
		if objDef.style.margin:
			objStyle.margin  = 		"margin:                             %s;\n" % str(objDef.style.margin)
		if objDef.style.marginLeft:
			objStyle.margin  += 	"margin-left:                        %s;\n" % str(objDef.style.marginLeft)
		if objDef.style.marginRight:
			objStyle.margin += 		"margin-right:                       %s;\n" % str(objDef.style.marginRight)
		if objDef.style.marginTop:
			objStyle.margin += 		"margin-top:                         %s;\n" % str(objDef.style.marginTop)
		if objDef.style.marginBottom:
			objStyle.margin += 		"margin-bottom:                      %s;\n" % str(objDef.style.marginBottom)

		# Outline	##########################################################
		objStyle.outline = ""

		# OUTLINE COLOR -----------------------------------------------------#
		# CSS 2; Firefox 1.5; Safari 1.2; Opera 7.0; IE !=; Netscape 9; Konqueror 3.4;
		if objDef.style.outlineColor:
			objStyle.outline += 	"outline-color:                      %s;\n" % str(objDef.style.outlineColor)

		# OUTLINE STYLE -----------------------------------------------------#
		# CSS 2; Firefox 1.5; Safari 1.2; Opera 7.0; IE !=; Netscape 9; Konqueror 3.4;
		if objDef.style.outlineStyle:
			objStyle.outline += 	"outline-style:                      %s;\n" % str(objDef.style.outlineStyle)

		# OUTLINE WIDTH -----------------------------------------------------#
		# CSS 2; Firefox 1.5; Safari 1.2; Opera 7.0; IE !=; Netscape 9; Konqueror 3.4;
		if objDef.style.outlineWidth:
			objStyle.outline += 	"outline-width:                      %s;\n" % str(objDef.style.outlineWidth)

		# OUTLINE OFFSET ----------------------------------------------------#
		# CSS 2; Firefox 2; Safari 3; Opera 9.5; IE !=; Netscape 9; Konqueror !=;
		if objDef.style.outlineOffset:
			objStyle.outline += 	"outline-offset:                     %s;\n" % str(objDef.style.outlineOffset)

		# Opacity	##########################################################
		objStyle.opacity = ""

		# Opacity -----------------------------------------------------------#
		if objDef.style.opacity:
			decOpacity = int(objDef.style.opacity) / 100
			objStyle.opacity += 	"filter:                             alpha(opacity= %s);\n" % str(objDef.style.opacity)
			#objStyle.opacity += 	"-moz-opacity:                       %s;\n" % decOpacity
			objStyle.opacity += 	"opacity:                            %s;\n" % decOpacity

		# Overflow	##########################################################

		# OVERFLOW ----------------------------------------------------------#
		# CSS 2; Firefox 1; Safari 1; IE 4; Netscape 6;
		# !! Visible/hidden functionality only!
		# !! Scrollbars are handled elsewhere
		# 2012-02-01 : added scroll & auto support
		if objDef.style.overflow == 'visible':
			objStyle.overflow = 	"overflow:                           visible;\n";
		elif objDef.style.overflow == 'auto':
			objStyle.overflow = 	"overflow:                           auto;\n";
		elif objDef.style.overflow == 'scroll':
			objStyle.overflow = 	"overflow:                           scroll;\n";
		else:
			objStyle.overflow = 	"overflow:                           hidden;\n";


		# Padding	##########################################################
		objStyle.padding  = ""

		# PADDING -----------------------------------------------------------#
		# CSS 1; Firefox 1; Safari 1; IE 4; Netscape 4;
		if objDef.style.padding:
			objStyle.padding  = 	"padding:           %s;\n" % str(objDef.style.padding)
		if objDef.style.paddingLeft:
			objStyle.padding += 	"padding-left:      %s;\n" % str(objDef.style.paddingLeft)
		if objDef.style.paddingRight:
			objStyle.padding += 	"padding-right:     %s;\n" % str(objDef.style.paddingRight)
		if objDef.style.paddingTop:
			objStyle.padding += 	"padding-top:       %s;\n" % str(objDef.style.paddingTop)
		if objDef.style.paddingBottom:
			objStyle.padding += 	"padding-bottom:    %s;\n" % str(objDef.style.paddingBottom)

		# Text	##############################################################
		objStyle.text  = ""

		# TEXT ALIGNMENT ----------------------------------------------------#
		# CSS 1; Firefox 1; Safari 1; IE 4; Netscape 4;
		if objDef.style.textAlign:
			objStyle.text += 		"text-align:        %s;\n" % str(objDef.style.textAlign)

		# TEXT TRANSFORM ----------------------------------------------------#
		# CSS 1; Firefox 1; Safari 1; IE 4; Netscape 4;
		if objDef.style.textTransform:
			objStyle.text += 		"text-transform:    %s;\n" % str(objDef.style.transform)

		# TEXT DIRECTION ----------------------------------------------------#
		# CSS 1; Firefox 1; Safari 1; IE 4; Netscape 4;
		if objDef.style.direction:
			objStyle.text += 		"direction:         %s;\n" % str(objDef.style.direction)

		# FONT COLOR --------------------------------------------------------#
		# CSS 1; Firefox 1; Safari 1; IE 3; Netscape 4;
		if objDef.style.color:
			objStyle.text += 		"color:             %s;\n" % str(objDef.style.color)

		# FONT --------------------------------------------------------------#
		# CSS 1; Firefox 1; Safari 1; IE 3; Netscape 4;
		if objDef.style.fontFamily:
			objStyle.text += 		"font-family:       %s;\n" % str(objDef.style.fontFamily)

		# SIZE --------------------------------------------------------------#
		# CSS 1; Firefox 1; Safari 1; IE 3; Netscape 4;
		if objDef.style.fontSize:
			objStyle.text += 		"font-size:         %s;\n" % str(objDef.style.fontSize)

		# BOLD --------------------------------------------------------------#
		# CSS 1; Firefox 1; Safari 1; IE 4; Netscape 4;
		if objDef.style.fontWeight:
			objStyle.text += 		"font-weight:       %s;\n" % str(objDef.style.fontWeight)

		# ITALIC ------------------------------------------------------------#
		# CSS 1; Firefox 1; Safari 1; IE 4; Netscape 4;
		if objDef.style.fontStyle:
			objStyle.text += 		"font-style:        %s;\n" % str(objDef.style.fontStyle)

		# UNDERLINE ---------------------------------------------------------#
		# OVERLINE ----------------------------------------------------------#
		# STRIKEOUT ---------------------------------------------------------#
		# CSS 1; Firefox 1; Safari 1; IE 4; Netscape 4;
		if objDef.style.textDecoration:
			objStyle.text += 		"text-decoration:   %s;\n" % str(objDef.style.textDecoration)


		# SMALL CAPS --------------------------------------------------------#
		# CSS 1; Firefox 1; Safari 1; IE 4; Netscape 6;
		if objDef.style.fontVariant:
			objStyle.text += 		"font-variant:      %s;\n" % str(objDef.style.fontVariant)

		# select
		objStyle.select  = ""
		if objDef.preventSelect == True:
			objStyle.select  += 	"-moz-user-select:  none;"

		return objStyle

	#------------------------------------------------------------------#
	# use flag (or default value)
	#------------------------------------------------------------------#
	def useFlag(self, objDef, strFlag, mixDefault):
		try:
			if strFlag in objDef._FLAGS:
				return objDef._FLAGS[strFlag]
			else:
				return mixDefault
		except:
			return mixDefault
