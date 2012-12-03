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
# orderedDict class
#----------------------------------------------------------------------#
class orderedDict(dict):

	def __init__(self, *a, **k):
		self._keys = []
		if a or k:
			self.update(*a, **k)

	def __setitem__(self, key, item):
		dict.__setitem__(self, key, item)
		if key not in self._keys:
			self._keys.append(key)

	def __delitem__(self, key):
		dict.__delitem__(self, key)
		self._keys.remove(key)
	
	def __iter__(self):
		for key in self._keys:
			yield key
			
	def items(self):
		return zip(self._keys, self.values())

	def iteritems(self):
		for key in self._keys:
			yield (key, self.get(key))
					
	def iterKeys(self):
		for key in self._keys:
			yield key
			
	def itervalues(self):
		for key in self._keys:
			yield self.get(key)

	def keys(self):
		return self._keys[:]

	def values(self):
		return map(self.get, self._keys)
		
	def clear(self):
		self._keys = []
		dict.clear(self)
		
	def copy(self):
		return self.__class__(self)
		
	@classmethod
	def fromkeys(cls, seq, value=None):
		objReturn = cls()
		for key in seq:
			objReturn[seq[key]] = value
		return objReturn
		
	def pop(self, key, *default):
		if key in self._keys:
			self._keys.remove(key)
		return dict.pop(self, key, *default)
		
	def popitem(self):
		arrReturn = dict.popitem(self)
		self._keys.remove(arrReturn[0])
		return arrReturn
		
	def setDefault(self, key, default=None):
		if key not in self._keys:
			self._keys.append(key)
		return dict.setdefault(self, key, default)
			
	def update(self, *a, **k):
		dict.update(self, *a, **k)
		if a:
			for key in a[0]:
				if not hasattr(a[0], 'keys'):
					key = key[0]			
				if key not in self._keys:
					self._keys.append(key)
		if k:
			for key in k:
				if key not in self._keys: 
					self._keys.append(key)
				
		return None
		
	def __repr__(self):
		result = []
		for key in self._keys:
			result.append('%s: %s' % (repr(key), repr(self[key])))
		return ''.join([self.__class__.__name__, '([', ', '.join(result), '])'])

		
#----------------------------------------------------------------------#
# dotDict class
#----------------------------------------------------------------------#
class dotDict(orderedDict):
	def __getattr__(self, attr):
		return self.get(attr, None)
	
	def __setattr__(self, key, item):
		if key.startswith('_'):
			return dict.__setattr__(self, key, item)
		else:
			return self.__setitem__(key, item)
			
	def __delattr__(self, key):
		if key.startswith('_'):
			return dict.__delattr__(self, key)
		else:
			return self.__delitem__(key)

#----------------------------------------------------------------------#
# dotDictLite class
#----------------------------------------------------------------------#
class dotDictLite(dotDict):
	def __getattribute__(self, key):
		if key.startswith('_'):
			return dotDict.__getattribute__(self, key)
		else:
			return dotDict.__getitem__(self, key)
			
#----------------------------------------------------------------------#
# Constants
#----------------------------------------------------------------------#

# id stuff
ID_PREFIX		= 'w3'
ID_SEPARATOR	= '__'

# css stuff
CSS_PREFIX		= 'w3'
CSS_SEPARATOR	= '-'

# js stuff
JS_BASE			= 'w3'

# paths
IMAGEPATH 		= ''
ICONPATH 		= ''
