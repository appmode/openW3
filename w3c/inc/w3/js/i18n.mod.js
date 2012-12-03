//----------------------------------------------------------------------------//
/*  
 * (c) Copyright 2012 APPMO LTD
 * 
 * author    : Flame Herbohn (and contributors)
 * download  : https://github.com/appmode/
 * license   : see files in license/ for details
 */
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// i18n.mod.js
//----------------------------------------------------------------------------//
/*
 * Module for translating to different languages
 */
 
W3_i18n_module = function()
{
	// module name
	this.name	= 'i18n';
	
	// language file target
	this._strTarget = 'app/js/i18n/';
	
	// current language
	this._strLang = false;
	
	// object to hold language files
	this._objLang = {};
	
	// object to hold widgets waiting to be translated
	this._objQueue = {};
	
	// register a widget to be translated
	this.registerWidget = function($wgtTarget)
	{
		return this.translate($wgtTarget);
	}
	
	// translate a widget (and all of its children)
	// returns undefined   if no language is set
	//         false       if language is set but not yet loaded
	this.translate = function($wgtTarget)
	{
		if (this._strLang == false)
		{
			// return undefined if no language is set
			console.log('call to i18n.translate() with no language set');
			return;
		}
		else if (this._strLang in this._objLang)
		{
			// get language array
			var $arrI18n = this._objLang[this._strLang];
		}
		else
		{
			// return false if language file is not loaded yet
			console.log('call to i18n.translate() while waiting for ' + this._strLang + ' language to load');
			if ($wgtTarget)
			{
				// queue widget to be notified when language changes
				this._objQueue[$wgtTarget.id] = $wgtTarget;
			}
			return false;
		}
		
		if ($wgtTarget)
		{
			// translate widget
			var $elmTarget = $wgtTarget.getElement();
		}
		else
		{
			// translate everything
			var $elmTarget = document;
		}
		
		// get elements to translate
		var $arrElements =  $elmTarget.querySelectorAll('[data-i18n]');
		
		// translate each element
		var i = 0;
		var $elmTemp;
		var $strId;
		for ( ; $elmTemp = $arrElements[i++] ; )
		{
			$strId = $elmTemp.getAttribute('data-i18n');
			if ($arrI18n[$strId])
			{
				this.setElementTranslation($elmTemp, $arrI18n[$strId]);
			}
			else
			{
				console.log('missing i18n translation : ' + this._strLang + '.' + $strId);
			}
		}
		
		// trigger translation events
		if ($wgtTarget)
		{
			$wgtTarget.trigger('ontranslate');
			delete(this._objQueue[$wgtTarget.id]);
		}
		else
		{
			var $strId;
			for ($strId in this._objQueue)
			{
				this._objQueue[$strId].trigger('ontranslate');
				delete(this._objQueue[$strId]);
			}
		}
	}
	
	// get a single translation value in the current language
	// returns undefined   if no language is set
	//         false       if language is set but not yet loaded
	this.getTranslation = function($strId)
	{
		if (this._strLang == false)
		{
			// return undefined if no language is set
			console.log('call to i18n.getTranslation() with no language set');
			return;
		}
		else if (this._strLang in this._objLang)
		{
			return this._objLang[this._strLang][$strId];
		}
		else
		{
			// return false if language file is not loaded yet
			console.log('call to i18n.getTranslation() while waiting for ' + this._strLang + ' language to load');
			return false;
		}
		
	}
	
	// set the current language
	this.setLanguage = function($strLang)
	{
		this._strLang = $strLang;
		
		// cached language in local storage
		if (window.localStorage)
		{
			localStorage.setItem('i18n.language', $strLang);
		}
		
		if ($strLang in this._objLang)
		{
			this.translate();
		}
		else
		{
			// load new language
			this.w3.loadJS(this._strTarget +  $strLang + '.js')
		}
	}
	
	// guess (and set) the current language
	// use $strDefaultLang if we can't guess the language
	// $arrLanguages is an optional array of available languages
	this.guessLanguage = function($strDefaultLang, $arrLanguages)
	{
		var $strLang = null;
		
		// look for language cached in local storage
		if (window.localStorage)
		{
			$strLang = localStorage.getItem('i18n.language');
		}
		// try to get language from browser
		if (!$strLang)
		{
			$strLang = window.navigator.language || window.navigator.browserLanguage;
		}
		
		// check if language is available
		if ($arrLanguages && $strLang)
		{
			if ($arrLanguages.indexOf($strLang) == -1)
			{
				if ($strLang.length > 2)
				{
					$strLang = $strLang.substr(0, 2);
					if ($arrLanguages.indexOf($strLang) == -1)
					{
						$strLang = null;
					}
				}
				else
				{
					$strLang = null;
				}
			}
		}
		
		// use default language
		$strLang = $strLang || $strDefaultLang;
		
		// set language
		this.setLanguage($strLang);
	}
	
	// get the current language
	this.getLanguage = function()
	{
		return this._strLang;
	}
	
	// load a language, set it as the default language, and translate the entire UI to the new language
	this.loadLanguage = function($strLang, $objLang)
	{
		this._objLang[$strLang] = $objLang;
		if (this._strLang == $strLang)
		{
			this.translate();
		}
	}
	
	// set the i18n id of an element (and translate it to the current language)
	this.setElementI18nId = function($elmTarget, $strId)
	{
		$elmTarget.setAttribute('data-i18n', $strId);
		var $strTranslation = this.getTranslation($strId);
		if ($strTranslation)
		{
			this.setElementTranslation($elmTarget, $strTranslation);
			return true;
		}
		return $strTranslation;
	}
	
	// set the translation value of an element
	this.setElementTranslation = function($elmTarget, $strTranslation)
	{
		switch ($elmTarget.tagName)
		{
			case 'INPUT':
				switch ($elmTarget.type)
				{
					case 'text':
					case 'password':
					case 'search':
					case 'url':
					case 'tel':
					case 'email':
						// set placeholder for inputs that support a placeholder
						$elmTarget.setAttribute('placeholder', $strTranslation);
						break;
				}
				break;
			default:
				// by default set innerHTML
				$elmTarget.innerHTML = $strTranslation;
		}
	}
	
} 

// register module
w3.registerModule(new W3_i18n_module());

// Remove Class Definition
delete(W3_i18n_module);
