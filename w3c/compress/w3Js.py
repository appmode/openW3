#------------------------------------------------------------------------------#
#  
# (c) Copyright 2012 APPMO LTD
# 
# author    : Flame Herbohn (and contributors)
# download  : https://github.com/appmode/
# license   : GNU AGPL 3.0 (see license/agpl-3.0.txt for details)
#
#------------------------------------------------------------------------------#

from w3.base 	import *
import re

#----------------------------------------------------------------------#
# regular expressions
#----------------------------------------------------------------------#

_objRegEx = dotDict()

# context ( " ' / \n )
_objRegEx.context = re.compile("([^\"'/\n]*)([\"'/\n]|)")

# token ( $$n$$ )
_objRegEx.token = re.compile(r"\$\$([0-9]+)\$\$")

# leading whitespace
_objRegEx.leadingWS = re.compile(r"^([ \t]+)", re.M)

# trailing whitespace
_objRegEx.trailingWS = re.compile(r"([ \t]+)$", re.M)

# symbol whitespace
_objRegEx.symbolWS = re.compile(r"[ \t]*([\(\)\[\]\+\-=\.:;\<\>,\{\}\|])[ \t]*")

# blank line
_objRegEx.blankLine = re.compile("^\n", re.M)

# else & else if
_objRegEx.elseif = re.compile("}\n*(else( if)?)\n*{")

#----------------------------------------------------------------------#
# token cache
#----------------------------------------------------------------------#

_objTokenCache = dotDict()


#----------------------------------------------------------------------#
# compressor
#----------------------------------------------------------------------#
def compress(strInput):
	objTokenizer = tokenizer()
	
	# tokenize
	strTokenized = objTokenizer.tokenize(strInput)
	
	# remove blank lines ????
	
	# remove leading whitespace
	strTokenized = _objRegEx.leadingWS.sub('', strTokenized)
	
	# remove trailing whitespace
	strTokenized = _objRegEx.trailingWS.sub('', strTokenized)
	
	# remove whitespace around symbols
	strTokenized = _objRegEx.symbolWS.sub(r'\1', strTokenized)
	
	# blank lines
	strTokenized = _objRegEx.blankLine.sub('', strTokenized)
	
	# else
	strTokenized = _objRegEx.elseif.sub(r'}\1{', strTokenized)
	
	# replace private variable names
	#TODO!!!!
	
	# detokenize & return
	return objTokenizer.detokenize(strTokenized)




#----------------------------------------------------------------------#
# tokenize strings
#----------------------------------------------------------------------#
def tokenizeString(strInput):
	pass


#----------------------------------------------------------------------#
# detokenize strings
#----------------------------------------------------------------------#
def detokenizeString(strInput):
	pass
	

	
class tokenizer():
	def __init__(self):
		self.strContext	= None
		self.objToken	= {}
		self.strToken	= ''
		self.intToken	= 0
		self.strSymbol	= ''
		
	def tokenize(self, strInput):
		return _objRegEx.context.sub(self.insertToken, strInput)
		
	def detokenize(self, strInput):
		return _objRegEx.token.sub(self.replaceToken, strInput)
		
	def replaceToken(self, objMatch):
		return self.objToken[objMatch.group(1)]

	def insertToken(self, objMatch):		
		strText		= objMatch.group(1) or ''
		strContext	= objMatch.group(2)

		# no context
		if self.strContext == None:
			return self.contextStart(strText, strContext)
		# comment/regex start
		elif self.strContext == "/":
			if strContext == "/" and not strText:
				self.strContext = "//"
				return ''
			# multiline/inline comment
			elif strText.startswith('*'):
				# inline comment
				if strText.endswith('*') and strContext == "/":
					self.strContext = None
					return ''
				# multiline comment
				self.strContext = "/*"
				if strContext == "\n":
					return "\n"
				return ''
			# regular expression
			elif self.strSymbol.strip('([{;-+=*%!><&|^~:`') == '':
				self.strContext = 'rx'
				self.strToken = '/' + strText + strContext
				if strContext == "/" and self.isQuoteEnd(strText):
					return self.cacheToken()
				return ''
			# division
			return self.contextStart('/' + strText, strContext)
		# single line comment (first hit)
		elif self.strContext == "//":
			self.strContext = "///"
			if strText.startswith('#'):
				self.strContext = "//#"
				self.strToken = '//' + strText + strContext
				if strContext == "\n":
					return self.cacheToken()
				return ""
			if strContext == "\n":
				self.strContext = None
				return "\n"
			return ''
		# single line comment
		elif self.strContext == "///":
			if strContext == "\n":
				self.strContext = None
				return "\n"
			return ''
		# compiler command
		elif self.strContext == "//#":
			self.strToken += strText + strContext
			if strContext == "\n":
				return self.cacheToken()
			return ""
		# multiline/inline comment
		elif self.strContext == "/*":
			if strText.endswith('*') and strContext == "/":
				self.strContext = None
				return ''
			if strContext == "\n":
				return "\n"
			return ''
		# regular expression
		elif self.strContext == "rx":
			self.strToken += strText + strContext
			if strContext == "/" and self.isQuoteEnd(strText):
				return self.cacheToken()
			return ''
		# single quoted string
		elif self.strContext == "'":
			self.strToken += strText + strContext
			if strContext == "'" and self.isQuoteEnd(strText):
				return self.cacheToken()
			return ''
		# double quoted string
		elif self.strContext == '"':
			self.strToken += strText + strContext
			if strContext == '"' and self.isQuoteEnd(strText):
				return self.cacheToken()
			return ''
		else:
			self.strContext = None
			return strText + strContext

	def contextStart(self, strText, strContext):
		self.strSymbol = strText.rstrip()[-1:]
		if strContext == "\n":
			self.strToken	= ''
			self.strContext = None
			return strText + "\n"
		self.strToken	= strContext
		self.strContext = strContext
		return strText

	def isQuoteEnd(self, strText):
		bolEnd = True
		while strText.endswith("\\"):
			bolEnd = not bolEnd
			strText = strText[:-1]
		return bolEnd
		
	def cacheToken(self):
		# cache token
		self.strContext = None
		self.intToken += 1
		self.objToken[str(self.intToken)] = self.strToken
		self.strToken	= ''
		return '$$%s$$' % self.intToken
	
