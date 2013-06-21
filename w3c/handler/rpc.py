#------------------------------------------------------------------------------#
#
# Contributed by T-Labs, Deutsche Telekom Innovation Laboratories
# 
# author    : Flame Herbohn
#
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# rpc.py
#------------------------------------------------------------------------------#
#
# Test handler for RPC API calls
#

import os
import sys
from django.utils import simplejson as json
from w3.base import *
from time import sleep

# wait a second
sleep(1)

print ""

# get params
try:
	strPathInfo	= os.environ.get('PATH_INFO').strip('/')
	arrPathInfo	= strPathInfo.split('/')
	strModule	= arrPathInfo.pop(3)
	
	objParams = json.loads(sys.stdin.read(), object_pairs_hook=dotDict)
except:
	print '{"error":{"code":"-333333","message":"error","data":"INVALID RPC DATA"}';
	sys.exit()

# get path
strPath = '../../rpc_data/%s/%s.js' % (strModule, objParams.method)

# return JSON
try:
	print open(strPath).read()
except:
	print '{"error":{"code":"-333334","message":"error","data":"INVALID METHOD : %s"}' % objParams.method;
	sys.exit()
