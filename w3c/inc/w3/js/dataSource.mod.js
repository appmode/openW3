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
// dataSource.mod.js
//----------------------------------------------------------------------------//
/*
 * Module for managing data sources
 */

W3_dataSource_module = function()
{
	// module name
	this.name	= 'dataSource';
	
	// module alias
	this.alias	= 'ds';
	
	// object to hold dataSources
	this._objDataSource = {};

	// register a widget to a dataSource (the widget must be configured for dataSource registration)
	this.registerWidget = function($wgtTarget)
	{
		// check if the widget has a dataSource set
		// also checks the parentWidget then parentView for a dataSource (so that 
		// all widgets in a parent or view can share the same dataSource)
		var $strDataSource = $wgtTarget.property('dataSource') || $wgtTarget.parentWidget.property('dataSource') || $wgtTarget.parentView.property('dataSource');
		if ($strDataSource)
		{
			// check if the widget has a dataField set
			var $arrDataField  = $wgtTarget.property('dataField');
			if ($arrDataField)
			{
				// check for sub-dataField, for example:
				//     dataField = "fieldName.subFieldName"
				//     or
				//     dataField = ["fieldName", "subFieldName"]
				if (typeof($arrDataField) != 'object')
				{
					$arrDataField = $arrDataField.split(".");
				}

				var $strDataField = $arrDataField.shift();
				if ($arrDataField.length > 0)
				{
					// set subField on widget
					$wgtTarget.property('dataSubField', $arrDataField);
				}
				var $strDataKey = $arrDataField.join('.');
				
				// get the dataField object
				var $objDataField = this.touchDataField($strDataSource, $strDataField);
				// add the dataMember to the dataField (based on dataMemberType : input|output|io)
				switch ($wgtTarget.property('dataMemberType'))
				{
					case 'input':
						// there can be only 1 input per subField
						$objDataField.input[$strDataKey] = $wgtTarget;
						break;
					case 'output':
						// there can be multiple outputs
						$objDataField.output.push($wgtTarget);
						break;
					default:
						// io is default
						$objDataField.input[$strDataKey] = $wgtTarget;
						$objDataField.output.push($wgtTarget);
				}
			
				return true;
			}
			//TODO!!!! : handle other types of data enabled widgets (eg. dataControl, dataConnector)
		}
		return false;
	}
	
	// create dataSource if it does not already exist
	this.touchDataSource = function($strName)
	{
		if (!($strName in this._objDataSource))
		{
			this._objDataSource[$strName] = {'field':{}};
		}
		return this._objDataSource[$strName];
	}
	
	// create dataField if it does not already exist
	this.touchDataField = function($strDataSource, $strDataField)
	{
		var $objDataSource = this.touchDataSource($strDataSource);
		if (!($strDataField in $objDataSource.field))
		{
			$objDataSource.field[$strDataField] = {'input':{}, 'output':[]};
		}
		return $objDataSource.field[$strDataField];
	}

	// set data (push to dataMembers)
	this.setData = function($strDataSource, $objDataSet)
	{
		var $objDataSource = this.touchDataSource($strDataSource);
		var $strDataField;
		var $arrDataMembers;
		var $wgtDataMember;
		var $strDataProperty;
		var $mixValue;
		// for each field in the inbound dataSet
		for ($strDataField in $objDataSet)
		{
			// get the field value
			$mixValue = $objDataSet[$strDataField];
			// if the field exists in the dataSource
			if ($strDataField in $objDataSource.field)
			{
				// get array of output dataMembers
				$arrDataMembers = $objDataSource.field[$strDataField].output;
				// for each output dataMember
				var i = 0;
				for ( ; $wgtDataMember = $arrDataMembers[i++] ; )
				{
					// see if the widget has a dataSubField set
					var $arrField = $wgtDataMember.property('dataSubField');
					var $mixOutput = $mixValue;
					if (typeof($arrField) == 'object')
					{
						// use the dataSubField
						$arrField = $arrField.slice(0);
						while ($arrField.length > 0)
						{
							$mixOutput = $mixOutput[$arrField.shift()];
						}
					}
					// get dataProperty from dataMember (widget) : default = 'value' 
					$strDataProperty = $wgtDataMember.property('dataProperty') || 'value';
					// set the dataProperty
					$wgtDataMember.property($strDataProperty, $mixOutput);

					//TODO!!!! : dataStyle property to set a style? (would this be useful?)
//console.log($strDataSource, $wgtDataMember.name, $mixOutput);					
					// triger set data event
					$wgtDataMember.trigger('datasourceset');
				}
			}
		}
		//TODO!!!! : handle other types of data enabled widgets (eg. dataGrid)
		
		// handle widgets that request the entire dataSet : dataField = "*"
		// if the * field exists in the dataSource
		if ('*' in $objDataSource.field)
		{
			// get array of output dataMembers
			$arrDataMembers = $objDataSource.field['*'].output;
			// for each output dataMember
			var i = 0;
			for ( ; $wgtDataMember = $arrDataMembers[i++] ; )
			{
				// get dataProperty from dataMember (widget) : default = 'value' 
				$strDataProperty = $wgtDataMember.property('dataProperty') || 'value';
				// set the dataProperty
				$wgtDataMember.property($strDataProperty, $objDataSet);
				// triger set data event
				$wgtDataMember.trigger('datasourceset');
			}
		}
	}
	
	// get data (pull from dataMembers)
	this.getData = function($strDataSource, $objDataFields)
	{
		var $objDataSource = this.touchDataSource($strDataSource);
//console.log($objDataSource);
		var $objDataSet = {};
		var $objDataParent;
		var $strDataField;
		var $strSubField;
		var $objDataMembers
		var $wgtDataMember;
		var $strDataProperty;
		
		// handle widgets that request the entire dataSet : dataField = "*"
		// if the * field exists in the dataSource
		if ('*' in $objDataSource.field)
		{
			// for each input dataMember
			$objDataMembers = $objDataSource.field['*'].input;
			var $bolHasStarInput = false;
			for ($strSubField in $objDataMembers)
			{
				// get the dataMember (widget)
				$wgtDataMember = $objDataMembers[$strSubField];
				// get dataProperty from dataMember (widget) : default = 'value' 
				$strDataProperty = $wgtDataMember.property('dataProperty') || 'value';
				// get the dataProperty
				$objDataSet = $wgtDataMember.property($strDataProperty);
				
				$bolHasStarInput = true;
			}
			if ($bolHasStarInput)
			{
				return $objDataSet;
			}
		}
		
		// for each field in the dataSource
		for ($strDataField in $objDataSource.field)
		{
			// get input dataMember
			$objDataMembers = $objDataSource.field[$strDataField].input;
			for ($strSubField in $objDataMembers)
			{
//console.log($strDataField, $strSubField);
				$objDataParent = $objDataSet;
				$wgtDataMember = $objDataMembers[$strSubField];
				
				if ($objDataFields)
				{
/* UNTESTED
					// if we were pased a dataFields object
					var $strField = $wgtDataMember.property('dataField');
					// skip fields not requested
					if (!($strField in $objDataFields))
					{
						continue;
					}
					// set field alias
					if ($objDataFields[$strField])
					{
						$strDataField = $objDataFields[$strField];
					}
*/
				}
				else
				{
					// see if the widget has a dataSubField set
					var $strField = $strDataField;
					if ($strSubField != '')
					{
						var $arrField = $strSubField.split('.');
						while ($arrField.length > 0)
						{
							if (!($strField in $objDataParent))
							{
								$objDataParent[$strField] = {};
							}
							$objDataParent = $objDataParent[$strField];
							$strField = $arrField.shift();
						}
					}
				}
				
				// get dataProperty from dataMember (widget) : default = 'value' 
				$strDataProperty = $wgtDataMember.property('dataProperty') || 'value';
				// get the dataProperty
				$objDataParent[$strField] = $wgtDataMember.property($strDataProperty);

				//TODO!!!! : dataStyle property to set a style? (would this be useful?)
			}
		}
		//TODO!!!! : handle other types of data enabled widgets (eg. dataGrid)
//console.log($objDataSet);
		return $objDataSet;
	}
	
	// get an object containing all of the input widgets registered to a dataSource
	this.getInputs = function($strDataSource)
	{
		var $objDataSource = this.touchDataSource($strDataSource);
		var $objInputs = {};
		var $strDataField;
		var $wgtDataMember;
		var $objDataMembers;
		
		// for each field in the dataSource
		for ($strDataField in $objDataSource.field)
		{
			var $strField = $strDataField;
			// get input dataMember
			$objDataMembers = $objDataSource.field[$strDataField].input;
			for ($strSubField in $objDataMembers)
			{
				if ($strSubField != '')
				{
					$strField = $strDataField + '.' + $strSubField;
				}
				$objInputs[$strField] = $objDataMembers[$strSubField];
			}
		}
		return $objInputs;
	}

} 

// register module
w3.registerModule(new W3_dataSource_module());

// Remove Class Definition
delete(W3_dataSource_module);
