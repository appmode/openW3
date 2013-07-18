#------------------------------------------------------------------------------#
#
# Contributed by T-Labs, Deutsche Telekom Innovation Laboratories
# 
# author    : Flame Herbohn
#
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# i18n.py
#------------------------------------------------------------------------------#

import os
import sys
from django.utils import simplejson as json
from w3.base import *
from w3c.compress		import json as compressJSON

# get language
strPathInfo	= os.environ.get('PATH_INFO').strip('/')
arrPathInfo	= strPathInfo.split('/')
strLang = arrPathInfo.pop().split('.').pop(0)

strPath = '../../app/i18n/%s.js' % strLang

if os.path.exists(strPath):
	# load language
	objLang = json.loads(compressJSON.compress(open(strPath).read()))

print ""

print 'w3.i18n.loadLanguage("%s",%s);' % (strLang, json.dumps(objLang))
