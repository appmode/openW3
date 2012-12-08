//----------------------------------------------------------------------------//
/*  
 * Contributed by T-Labs, Deutsche Telekom Innovation Laboratories
 * 
 * author    : Flame Herbohn
 * 
 */
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// luciRpc.mod.js
//----------------------------------------------------------------------------//
/*
 * Module for luci RPC
 */
 
W3_luciRpc_module = function()
{
	// module name
	this.name	= 'luciRpc';
	
	// module alias
	this.alias	= 'lr';
	
	// RPC target
	this._strTarget = '/cgi-bin/luci/rpc/';
	
	// RPC module name
	this._strModule = 'openW3';
	
	// RPC Auth token
	this._strAuthToken = '';
	
	// RPC version
	this._strRpcVersion = "1.0";
	
	// object to store dataSource relationships
	this._objDataSource = {};
	
	// object to store rpc relationships
	this._objRpc = {};
	
	// data converter object
	this._objDataConverter = {};
	
	// rpc converter object
	this._objRpcConverter = {};
	
	// reply handler
	this._handleReply = function($objRequest, $arrTarget)
	{	
		// get method
		var $strMethod     = $arrTarget[0];
		
		// get dataSource
		var $strSingleDataSource = $arrTarget[1];
		
		// check for a response
		if (!$objRequest.responseText)
		{
			//send an error to the dataSource
			this.dataSourceError($strSingleDataSource, 0, 'Empty responseText');
			return false;
		}
		
		// convert response to object
		var $objResponse = JSON.parse($objRequest.responseText);
			
		// check for an error
		if ($objResponse.error)
		{
			console.log($objResponse.error);
			
			// set error details
			var $intStatus = $objResponse.error.code;
			var $strError  = $objResponse.error.message + " : " + $objResponse.error.data;
			
			//send an error to the dataSource
			this.dataSourceError($strSingleDataSource, $intStatus, $strError);
			return false;
		}
		
		// login
		if ($strMethod == 'login')
		{
			if ('result' in $objResponse && $objResponse.result)
			{
				this._strAuthToken = '?auth=' + $objResponse.result;
				if ('app' in this.w3 && this.w3.app.onlogin)
				{
					this.w3.app.onlogin();
				}
			}
			else
			{
				if ('app' in this.w3 && this.w3.app.onloginfail)
				{
					this.w3.app.onloginfail();
				}
			}
			return;
		}

		// check for a result
		if ('result' in $objResponse)
		{
			var $strType;
			var $objData;
			var $objMeta;
			var $strDataSource;
			for ($strType in $objResponse.result)
			{
				// check if we have any dataSource(s) registered to this type
				if (!($strType in this._objDataSource))
				{
					continue;
				}
				
				$objData = $objResponse.result[$strType];

				// set meta data
				$objMeta = {};
				$objMeta.method = $strMethod;
				
				// convert empty data array to null
				if ($objData instanceof Array && $objData.length == 0)
				{
					$objData = {};
					$objMeta.emptyResult = true;
				}
				
				// add meta data
				$objData[".meta"] = $objMeta;
				
				// check for a data converter
				if ($strType in this._objDataConverter)
				{
					// convert data
					$objData = this._objDataConverter[$strType]($objData);
				}
							
				// send data to registered dataSources
				var $objDataSource = this._objDataSource[$strType];
				if ($strSingleDataSource && $strSingleDataSource in $objDataSource)
				{
					// if there is an error in the data :
					if ('error' in $objData && $objData.error === true)
					{
						// don't update any other datasources of the same type as 
						// the dataSource that called the RPC method
						$objDataSource = {};
						$objDataSource[$strSingleDataSource] = this._objDataSource[$strType][$strSingleDataSource];
					}
				}
				for ($strDataSource in $objDataSource)
				{
console.log($strDataSource, $objData);
					// send to dataSource
					this.w3.dataSource.setData($strDataSource, $objData);
				}
			}
		}
	}
	
	// error handler
	this._handleError = function($objRequest, $arrTarget)
	{
		var $strError;
		
		// get method
		var $strMethod     = $arrTarget[0];
		
		// get dataSource
		var $strDataSource = $arrTarget[1];
		
		switch ($objRequest.status)
		{
			case 403:
				console.log("computer says \"no\"");
				this.logout();
				return;
				break;
			case 500:
				$strError = "server error (500) for RPC call : " + $strMethod;
				break;
			default:
				$strError = "unexpected error (" + $objRequest.status + ") for RPC call : "  + $strMethod;
				break;
		}
		
		console.log($strError);
		
		//send an error to the dataSource
		this.dataSourceError($strDataSource, $objRequest.status, $strError);
	}
	
	//------------------------------------------------------------------------//
	// RPC Calls
	//------------------------------------------------------------------------//
	
	// login
	this.rpcLogin = function($strPassword)
	{
		var $objData = {"method":"login","params":["root", $strPassword]};
		return this.parent.requestPost(this.path, this._strTarget + 'auth', $objData, ['login',null]);
	}
	
	// logout
	this.logout = function()
	{
		this._strAuthToken = "";
		if ('app' in this.w3 && this.w3.app.onlogout)
		{
			this.w3.app.onlogout();
		}
	}
	
	// run an RPC method
	// if $strDataSource is specified, and there is an error in the data 
	// returned for any dataSource type that $strDataSource is registered to,
	// then $strDataSource will be the only dataSource of that type to be 
	// updated (any dataSources of a different type to $strDataSource would
	// still be updated). This allows error status to be displayed only for
	// widgets registered to the dataSource which called the RPC method.
	this.rpcMethod = function($strMethod, $arrParams, $strDataSource)
	{
		var $objData = {"jsonrpc": this._strRpcVersion, "method": $strMethod};
		
		// params are optional
		if ($arrParams)
		{
			if (!($arrParams instanceof Array))
			{
				$arrParams = [$arrParams];
			}
			$objData.params = $arrParams;
		}
console.log($strMethod, $arrParams);
		return this.rpcCall($objData, $strDataSource);
	}
	
	// make an RPC call
	this.rpcCall = function($objData, $strDataSource)
	{
		return this.parent.requestPost(this.path, this._strTarget + this._strModule + this._strAuthToken, $objData, [$objData.method, $strDataSource]);
	}
	
	//------------------------------------------------------------------------//
	// DataSource registration
	//------------------------------------------------------------------------//
	
	// register a datasource to be updated by the return value of an RPC methods
	this.registerDataSource = function($strDataSource, $strType, $strRpcSetMethod)
	{
		// ensure type exists in dataSource cache
		if (!($strType in this._objDataSource))
		{
			this._objDataSource[$strType] = {};
		}
		
		// add dataSource to cache
		this._objDataSource[$strType][$strDataSource] = true;
		this._objRpc[$strDataSource] = $strRpcSetMethod;
	}

	// register an rpc converter function
	this.registerRpcConverter = function($strMethod, $fncConverter)
	{
		this._objRpcConverter[$strMethod] = $fncConverter;
	}
	
	// register a data converter function
	this.registerDataConverter = function($strMethod, $fncConverter)
	{
		this._objDataConverter[$strMethod] = $fncConverter;
	}
	
	// cancel any changes to the input widgets registered to a dataSource
	this.cancelDataInput = function($strDataSource)
	{
		var $objInputs = this.w3.dataSource.getInputs($strDataSource);
		var $strInput;
		for ($strInput in $objInputs)
		{
			$objInputs[$strInput].cancelInput();
		}
	}
	
	// submit a dataSource to an RPC call
	this.submitDataSource = function($strDataSource)
	{
		var $arrParams;
		
		// get data
		var $objData = this.w3.dataSource.getData($strDataSource);

		// get RPC method
		var $strMethod = this._objRpc[$strDataSource];
		
		// convert data to params
		if ($strMethod in this._objRpcConverter)
		{
			$objData = this._objRpcConverter[$strMethod]($objData);
		}
		
		// make RPC call
		this.rpcMethod($strMethod, $objData, $strDataSource);
	}
	
	// send an error to a dataSource
	this.dataSourceError = function($strDataSource, $intError, $strError)
	{
		if ($strDataSource)
		{
			var $objData =
			{
				"error" : true, 
				".meta" :
				{
					"errorCode" : $intError,
					"errorMsg"  : $strError
				}
			};
			this.w3.dataSource.setData($strDataSource, $objData);
		}
	}
} 

// register module
window[W3_NAMESPACE].registerModule(new W3_luciRpc_module());

// Remove Class Definition
delete(W3_luciRpc_module);
