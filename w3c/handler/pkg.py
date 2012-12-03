#------------------------------------------------------------------------------#
#  
# (c) Copyright 2012 APPMO LTD
# 
# author    : Flame Herbohn (and contributors)
# download  : https://github.com/appmode/
# license   : GNU AGPL 3.0 (see license/agpl-3.0.txt for details)
#
#------------------------------------------------------------------------------#
    
from google.appengine.dist import use_library
use_library('django', '1.2')

from w3.base	import *
from w3c		import filesystem
import os
import mimetypes

# get path
strPath	= os.environ.get('PATH_INFO').strip('/')

# open folder
objFolder	= filesystem.openPackageFolder(strPath)

# return file
print "Content-Type: %s" % mimetypes.guess_type(strPath)[0]
print ''
try:
	print objFolder.getFileStr()
except:
	for strFile in objFolder.listFiles():
		print "<a href=\"%s\">%s</a><br>" % (objFolder.getAlias(strFile), strFile)
