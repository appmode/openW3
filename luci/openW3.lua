-- Contributed by T-Labs, Deutsche Telekom Innovation Laboratories
local ipkg  = require "luci.model.ipkg"
local sys	= require "luci.sys"
local io	= require "io"
local os	= require "os"
local fs	= require "nixio.fs"
local ubus	= require "ubus".connect()
local uci	= require "luci.model.uci".cursor()
local ip	= require "luci.ip"
-- local string	= require "string"
-- local table	= require "table"
local table	= table
local string	= string
local tonumber	= tonumber
local tostring  = tostring
local pairs = pairs
local ipairs = ipairs
local type = type
local math = math
local unpack = unpack
local uptime = require "luci.sys".uptime()
local loadstring = loadstring
local next = next
local wait_for_complete_reg_info_max = 10 -- in seconds
local intMaxWait = 10 -- default max wait time before returning something to the ui 

module "luci.openW3"

--------------------------------------------------------------------------------
-- local functions
--------------------------------------------------------------------------------

local function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- remove trailing and leading whitespace from string.
-- http://en.wikipedia.org/wiki/Trim_(8programming)
function trim(s)
  -- from PiL2 20.4
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- remove leading whitespace from string.
-- http://en.wikipedia.org/wiki/Trim_(8programming)
function ltrim(s)
  return (s:gsub("^%s*", ""))
end

-- remove trailing whitespace from string.
-- http://en.wikipedia.org/wiki/Trim_(8programming)
function rtrim(s)
  local n = #s
  while n > 0 and s:find("^%s", n) do n = n - 1 end
  return s:sub(1, n)
end

--------------------------------------------------------------------------------
-- VALIDATION
--------------------------------------------------------------------------------

local val_err_invalid         = { error = true, _msg = "invalid" }
local val_err_invalid_type    = { error = true, _msg = "invalid type" }
local val_err_uci_call        = { error = true, _msg = "uci call error" }
local val_err_not_found       = { error = true, _msg = "not found"}
local val_err_internal_error  = { error = true, _msg = "internal error" }
local val_err_offline         = { error = true, _msg = "offline" }
local val_err_missing         = { error = true, _msg = "required value missing" }
local val_err_not_implemented = { error = true, _msg = "validation not implemented" }

valid = {
  password_internet = {t = "string", lmin = 1, lmax = 8},
  password_device   = {t = "string", lmin = 1, lmax = 12},
  password_provider = {t = "string", lmin = 1, lmax = 12}, -- TODO
  password_provider_anonym = {t = "string", lmin = 0, lmax = 12}, -- TODO
  t_mbnr      = {t = "table", l = {4}, i = {nil, "t_mbnr_item"}}, -- refers to an array of t_mbnr_item
  t_mbnr_item = {t = "number", v = {0,1}},
  demand      = {t = "number", vmin = 180},
  bool        = {t = "number", v = {0,1}},
  encryption  = {t = "string", v = {"none", "wep", "psk", "mixed-psk", "psk2"}},
  wep_key     = {t = "string", l = {10,26}},
  wpa_key     = {t = "string", lmin = 8, lmax = 63},
  ssid        = {t = "string", lmin = 1, lmax = 32},
  voip_number = {t = "string", lmin = 1, lmax = 64}, -- TODO
  voip_ext    = {t = "string"},
  voip_trunk  = {t = "string"},
  addr_ipv4   = {t = "string", p = "%d?%d?%d%.%d?%d?%d%.%d?%d?%d%.%d?%d?%d"},
  mail        = {t = "string", lmin = 1, p = ".+@.+"},
  
	wireless_key = function (strValue, objContext)
		if objContext.encryption == "wep" then
			return validate(strValue, "wep_key")
		elseif objContext.encryption ~= "none" then
			return validate(strValue, "wpa_key")
		end
	end
}

---
-- generic validation funtion
-- @param item item to validate
-- @param val "validation" object or key in global valid object or validation method name
function validate (item, val, objContext)
	if item == nil then
		local val_err = shallowcopy(val_err_invalid)
		val_err['_msg'] = val_err['_msg'] .. " : item is nil"
		return val_err
	end
	
	if type(val) == "string" then
		if valid[val] ~= nil then
			val = valid[val]
		else
			local val_err = shallowcopy(val_err_not_implemented)
			val_err['_msg'] = val_err['_msg'] .. " for '" .. val .. "'"
			return val_err
		end
	end 

	if val == nil then
		local val_err = shallowcopy(val_err_internal_error)
		val_err['_msg'] = val_err['_msg'] .. " : validation object is nil"
		return val_err
	end

	-- custom validation method
	if type(val) == "function" then
		return val(item, objContext)
	end
	
	-- generic validation
	local validation = valid
	local valid      = val

	-- convert numbers from strings (numbers are always stored as strings)
	if valid["t"] == "number" then
		item = tonumber(item)
	end

  if valid["t"] ~= type(item) then return val_err_invalid_type end

  if valid["t"] == "string" then
    if valid["lmin"] ~= nil and string.len(item) < valid["lmin"] then return val_err_invalid end
    if valid["lmax"] ~= nil and string.len(item) > valid["lmax"] then return val_err_invalid end
    if valid["l"] ~= nil then
      local sl = string.len(item)
      local match = false
      for _,v in pairs(valid["l"]) do
        if sl == v then match = true; break end
      end
      if not match then return val_err_invalid end
    end
    if valid["v"] ~= nil then
      local match = false
      for _,v in pairs(valid["v"]) do
        if item == v then match = true; break end
      end
      if not match then return val_err_invalid end
    end
    if valid["p"] ~= nil then
      if item ~= string.match(item, valid["p"]) then
        val_err_invalid["_reason"] = "item '" .. item .. "' does not match pattern : " .. valid["p"]
        return val_err_invalid
      end
    end
  elseif valid["t"] == "number" then
    if valid["vmin"] ~= nil and item < valid["vmin"] then return val_err_invalid end
    if valid["vmax"] ~= nil and item > valid["vmax"] then return val_err_invalid end
    if valid["v"] ~= nil then
      local match = false
      for _,v in pairs(valid["v"]) do
        if item == v then match = true; break end
      end
      if not match then return val_err_invalid end
    end
  elseif valid["t"] == "table" then
    if valid["l"] ~= nil then
      local l = #item
      local match = false
      for _,v in pairs(valid["l"]) do
        if l == v then match = true; break end
      end
      if not match then return val_err_invalid end
    end
    -- also check table items
    if valid["i"] ~= nil then
      local err = false
      for k,v in pairs(item) do
        -- validate key
        if valid["i"][1] ~= nil then
          local valid_res = validate(k, valid["i"][1])
          if valid_res ~= nil then
            err = true
            item[k] = res
          end
        end
        -- validate value
        if valid["i"][2] ~= nil then
          local valid_res = validate(v, valid["i"][2])
          if valid_res ~= nil then
            err = true
            item[k] = res
          end
        end
      end
      if err then return item end
    end
  end
end

-- validate_data
local function validate_data(objData, objValid, objReturn, objRequire)
	if objReturn == nil then
		objReturn = {}
	end
	local objError
	
	-- for each valid key
	for key, value in pairs(objValid) do
		-- if key exists in data
		if objData[key] ~= nil then
			-- validate
			if (value == true) then
				-- true : validate with key
				objError = validate(objData[key], key, objData)
			elseif (value == false) then
				-- false : do not validate
				objError = nil
			else
				-- object|string : validate with validation object or named function|validation object
				objError = validate(objData[key], value, objData)
			end
			-- if key is invalid
			if objError ~= nil then
				objReturn[key] = objError
			end
		elseif objRequire ~= nil and (objRequire == true or objRequire[key] ~= nil) then
			objReturn[key] = val_err_missing
		end
	end
	
	return objReturn
end

-- validate_exists_in
local function validate_exists_in(key, object)
	if object[key] == nil then
		return val_err_not_found
	end
end

-- validate_exists_in_any
local function validate_exists_in_any(key, ...)
	arg.n = nil
	for _,object in pairs(arg) do
		if object ~= nil and object[key] ~= nil then
			return
		end
	end
	return val_err_not_found
end

-- validate_exists
local function validate_exists(value)
	if value == nil then
		return val_err_not_found
	end
end

--------------------------------------------------------------------------------
-- RPC helpers
--------------------------------------------------------------------------------

-- append_error
local function append_error(objParent, strKey, objError)
	if objError ~= nil then
		if next(objError) ~= nil then
			objParent[strKey] = objError
			return true
		end
	end
	return false
end

-- is_empty
local function is_empty(object)
	if object ~= nil then
		if next(object) ~= nil then
			return false
		end
	end
	return true
end

-- has_error
local function has_error(objError)
	return not is_empty(objError)
end

-- format_error_return
local function format_error_return(objError)
	if has_error(objError) then
		objError.error = true
	end
	return objError
end


-- get_anon_secs
local function get_anon_secs(config, section)
	local anon_secs = {}
	uci:foreach(config, section,
		function(s)
			table.insert(anon_secs, s['.name'])
		end
	)
	return anon_secs
end

-- uci_set_data
local function uci_set_data(strFile, strSection, objData, objValid, objReturn, objRequire)
	if objReturn == nil then
		objReturn = {}
	end
	local objError
	
	-- for each valid key
	for key, validator in pairs(objValid) do
		-- if key exists in data
		if objData[key] ~= nil then
			local value = objData[key]
			-- convert bool value to string
			if value == false then
				value = "0"
			elseif value == true then
				value = "1"
			-- convert number value to string
			elseif type(value) == "number" then
				value = tostring(value)
			end
			-- validate
			if (validator == true) then
				-- true : validate with key
				objError = validate(value, key, objData)
			elseif (validator == false) then
				-- false : do not validate
				objError = nil
			else
				-- object|string : validate with validation object or named function|validation object
				objError = validate(value, validator, objData)
			end
			-- if key is valid
			if objError == nil then
				-- set key
				if not uci:set(strFile, strSection, key, value) then
					-- set key failed
					objReturn[key] = val_err_uci_call
				end
			-- if key is invalid
			else
				objReturn[key] = objError
			end
		elseif objRequire ~= nil and (objRequire == true or objRequire[key] ~= nil) then
			objReturn[key] = val_err_missing
		end
	end
	
	return objReturn
end

-- uci_commit_data
local function uci_commit_data(strFile, objReturn)
	if next(objReturn) ~= nil then
		uci:revert(strFile)
		return false
	end
	
	uci:commit(strFile)
	return true
end

-- copy_keys
local function copy_keys(objFrom, objTo, arrKeys)
	for _,key in pairs(arrKeys) do
		objTo[key] = objFrom[key]
	end
	return objTo
end

-- is_network_up
local function is_network_up(strNetwork)
	local objNet = ubus:call(string.format("network.interface.%s", strNetwork), "status", {})
	if objNet and objNet.up then
		return true
	else
		return false
	end
end

-- get_cur_network
local function get_cur_network(ifaces)
	local interfaces = ifaces or { "lan", "wan" }
	local tmp = {}
	local res = {}
	for _,elem in pairs(interfaces) do
		res[elem] = {}
		tmp[elem] = ubus:call(string.format("network.interface.%s", elem), "status", {})
		if tmp[elem] and tmp[elem].up then
			res[elem] = {
				up		= tmp[elem].up,
				pending	= tmp[elem].pending,
				ipaddr	= tmp[elem]['ipv4-address'][1] and tmp[elem]['ipv4-address'][1]['address'] or nil,
				netmask	= tmp[elem]['ipv4-address'][1] and ip.IPv4("0.0.0.0/" .. tmp[elem]['ipv4-address'][1]['mask']):mask():string() or nil,
				-- ipaddr6	= tmp[elem]['ipv6-address'][1] and tmp[elem]['ipv6-address'][1]['address'] or nil,
				proto	= tmp[elem]['proto'],
				route	= tmp[elem]['route'][1] and tmp[elem]['route'][1]['nexthop'] or nil,
				dns		= tmp[elem]['dns-server'] and tmp[elem]['dns-server'][1] or nil,
				dns2	= tmp[elem]['dns-server'] and tmp[elem]['dns-server'][2] or nil,
			}
		else
			res[elem] = {
				up	= false
			}
		end
	end

	return res
end

--[[
local function get_datetime(format)
	return os.date(format)
end
]]

local function get_timestamp()
	return os.time()
end

local function get_version()
	-- return fs.readfile("/etc/openwrt_version") -- includes final newline
	return io.open("/etc/openwrt_version", "r"):read()
end

local function get_releasedate()
	return io.open("/etc/openwrt_releasedate", "r"):read()
end

local function get_macaddress()
	local mac_address = sys.exec("ifconfig eth0 | grep HWaddr")
	local index_hwaddr = mac_address:find("HWaddr ") + #"HWaddr "
	local mac_addr_length = 17
	return mac_address:sub(index_hwaddr, index_hwaddr + mac_addr_length-1);
end

local function get_uptime()
	return uptime
end

-- get_sip_registry
--
-- here we assume that the voip number will always be used as the name for a
-- line section in the voip config, and if the username for a line is different
-- from the voip number it will be stored in the line config section as 
-- "username"
--
-- returns an object containing the sip registry data, keyed by voip number.
-- for example :
-- {
--      "03021965820" :
--      {
--           "host"     : "tel.t-online.de:5060"
--           "username" : "03021965820"
--           "state"    : "Rejected"
--      }
--      ...
-- }
--
local function get_sip_registry(objAsterisk)
	local objAsterisk  = objAsterisk or uci:get_all("asterisk")
	local objNumbers   = {}
	local objRegistry  = {}
	local strRegistry  = sys.exec("/usr/sbin/asterisk -rx 'sip show registry'")
	
	-- get username to number mapping from asterisk conf
	for id,objSection in objAsterisk do
		if objSection.type == "external" and objSection.username ~= nil then
			objNumbers[objSection.username] = id
		end
	end
	
	-- process registry data
	for strLine in string.gmatch(strRegistry, "[^\n]+") do
		if strLine ~= nil and string.len(rtrim(strLine)) > 102 then
			local objLine = {}
			-- get data from sip registry
			objLine["host"]     = rtrim(strLine:sub(0, 40))
			objLine["username"] = rtrim(strLine:sub(48, 66))
			objLine["state"]    = rtrim(strLine:sub(71, 91))
			
			-- match username to number
			local strName = objNumbers[objLine["username"]] or objLine["username"]
			
			-- store data
			objRegistry[strName] = objLine
		end
	end
	
	return objRegistry
end


-- check_sip_registration
local function check_sip_registration()
	local objReturn = {}
	local wanUp     = is_network_up("wan")
	local intWait   = wait_for_complete_reg_info_max
	
	-- if wan is up we can check sip registration
	if wanUp then
		-- get asterisk config
		local objAsterisk  = uci:get_all("asterisk")
		
		-- wait for all numbers to be registered or rejected
		local i = 0
		local objSip
		local bolWait = true
		local objSip  = {}
		while bolWait == true and i < intWait do
			os.execute("sleep 1")
			bolWait = false
			
			-- get sip registry
			objSip = get_sip_registry(objAsterisk)
			
			-- check if lines are registered
			for strId,_ in pairs(objData.line or {}) do
				if objSip[strId] == nil or objSip[strId].state == "Auth. Sent" then
					bolWait = true
				end
			end
			
			i = i + 1
		end
		
		-- check if lines are registered
		local objError = {}
		for strId,_ in pairs(objData.line or {}) do
			if objSip[strId] == nil or objSip[strId].state ~= "Registered" then
				append_error(objError, strId, val_err_invalid)
			end
		end
		append_error(objReturn, "line", objError)
	end
	
	return format_error_return(objReturn)
end


local function dsl_control(start) -- used by set_external_modem
	local action = ""
	if start == 0 then
		action = "stop"
	elseif start == 1 then
		action = "start"
	else
		return
	end

	os.execute("/etc/init.d/dsl_control " .. action .. " > /dev/null 2>&1")
end

--------------------------------------------------------------------------------
-- RPC GET calls
--------------------------------------------------------------------------------

-- GET WIRELESS ----------------------------------------------------------------

-- get_wireless :)
local function _get_wireless()
	local wireless   = {}
	local _wireless  = uci:get_all("wireless")
	local ifaceKeys  = {"ssid", "hidden", "encryption", "key"}
	local deviceKeys = {"disabled", "macaddr", "channel"}
	
	-- add iface keys
	for _,sec in pairs(get_anon_secs("wireless", "wifi-iface")) do
		local device = _wireless[sec]["device"]
		wireless[device] = copy_keys(_wireless[sec], {}, ifaceKeys)
	end
	
	-- add device keys
	for _,sec in pairs(get_anon_secs("wireless", "wifi-device")) do
		copy_keys(_wireless[sec], wireless[sec], deviceKeys)
	end
	
	-- check if wireless is up
	for _,sec in pairs(get_anon_secs("wireless", "wifi-device")) do
		--TODO!!!! : maybe we should actually check if wireless is up and not just fake it ???? 
		if wireless[sec].disabled == "1" then
			wireless[sec].up = false
		else
			wireless[sec].up = true
		end
	end
	
	return wireless
end
function get_wireless()
	return {wireless = _get_wireless()}
end

-- GET LAN ---------------------------------------------------------------------

-- get_lan :)
local function _get_lan()
	local res = get_cur_network({"lan"}).lan
	res.mac_address = get_macaddress()
	return res
end
function get_lan()
	return {lan = _get_lan()}
end

-- GET WAN ---------------------------------------------------------------------

-- get_wan
local function _get_wan()
	local network = uci:get_all("network", "wan")
	if not network then
	--TODO!!!! : does this really ever not exist ????
		return nil
	end
	
	local res = get_cur_network({"wan"}).wan
	local keys = {"t_callident", "t_number", "t_mbnr", "username", "password", "demand"}
	copy_keys(network, res, keys)
	
	return res
end
function get_wan()
	return {wan = _get_wan()}
end

-- GET VOIP --------------------------------------------------------------------

-- get_voip
local function _get_voip()
	local wanUp     = is_network_up("wan")
	local asterisk  = uci:get_all("asterisk")
	local voip      = {line = {}, ext = {}, trunk = {}}
	local lineKeys  = {"disabled", "ring", "trunk", "clir"}
	local extKeys   = {"target", "cid"}
	local trunkKeys = {"disabled", "type", "t_mail", "t_password", "use_wan_credentials"}
	
	-- if wan is up, get registered voip numbers
	if wanUp then
		local registered = get_sip_registry()
	end
	
	for id,section in pairs(asterisk or {}) do
		if section.type == "external" then
			-- line
			voip.line[id] = copy_keys(section, voip.line[id] or {}, lineKeys)
			if wanUp and registered[id] == nil then
				-- wan is up & line is not registered, so we have a sip error
				voip.line[id].sip_error = 1
			end
		elseif section.target ~= nil then
			-- ext
--[[ --TODO!!!! : is this needed ????	
			if section.cid ~= nil and section.cid ~= "0" then
				-- make sure cid line exists
				voip[section.cid] = voip[section.cid] or {}
				-- add ext target to line
				voip[section.cid]["ext_target"] = section.target
				-- add ext id to line
				voip[section.cid]["ext_id"]     = id 
			end
]]
			voip.ext[id] = copy_keys(section, {}, extKeys)
		elseif section[".type"] == "trunk" then
			voip.trunk[id] = copy_keys(section, {}, trunkKeys)
		end
	end
	
	return voip
end
function get_voip()
	return {voip = _get_voip()}
end


-- GET INFO --------------------------------------------------------------------

local function _get_systeminfo()
	return {
		firmware_version  = get_version(),
		router_date       = get_timestamp(),
		uptime            = get_uptime(),
		release_date      = get_releasedate(),
		modified_packages = get_modified_packages(),
		dsl_status        = get_dsl_status(),
		system_log        = sys.exec("logread")
	}
end
function get_systeminfo()
	return {systeminfo = _get_systeminfo()}
end

local function _get_systeminfo_time()
	return {
		router_date = get_timestamp(),
		uptime      = get_uptime()
	}
end
function get_systeminfo_time()
	return {systeminfo = _get_systeminfo_time()}
end

-- get_modified_packages
local function _get_modified_packages()
	local packages = {}
	-- local status = io.open("/usr/lib/opkg/status"):read("*all")
	local status = fs.readfile("/usr/lib/opkg/status")
	for str in status:gmatch("(Package: .-)\n\n") do
		str:gsub(
			"Package: (.-)\n.-Version: (.-)\n.-Status: install user installed\n",
			function(pkg_name,pkg_version)
				-- table.insert(packages, { pkg_name = pkg_version } )
				packages[pkg_name] = pkg_version
			end
		)
	end
	return packages
end
function get_modified_packages()
	return {modified_packages = _get_modified_packages()}
end

local function _get_openrouter_config()
    return uci:get_all("openrouter")
end
function get_openrouter_config()
	return {openrouter_config = _get_openrouter_config()}
end

-- get_external_modem
local function _get_external_modem()
	local wan_mode = uci:get("ppa", "ppa", "wan_mode")

	if wan_mode == "eth" then
		return {enabled = 1}
	else
		return {enabled = 0}
	end
end
function get_external_modem()
	return {external_modem = _get_external_modem()}
end

local function _get_dsl_status()
	local dsl_stat = sys.exec("/etc/init.d/dsl_control lucistat")
	local dsl_func = loadstring(dsl_stat)

	return dsl_func()
end
function get_dsl_status()
	return {dsl_status = _get_dsl_status()}
end

-- GET OVERVIEW ----------------------------------------------------------------

function get_overview()
    return {
        wan      = _get_wan(), 
        lan      = _get_lan(),
        wireless = _get_wireless(),
        voip     = _get_voip(),
        external_modem    = _get_external_modem(),
        openrouter_config = _get_openrouter_config(),
    }
end

--------------------------------------------------------------------------------
-- RPC SET calls
--------------------------------------------------------------------------------

-- SET LAN ---------------------------------------------------------------------

-- _set_lan :)
local function _set_lan(objData, objValid)
	objData         = objData or {}
	objValid        = objValid or {}
	local objReturn = {}
	
	
	-- define valid data keys
	local objValidLan = {
		ipaddr      = valid.addr_ipv4
	}
	
	-- set data
	uci_set_data("network", "lan", objData, objValid.lan or objValidLan, objReturn)
	
	-- commit data
	if uci_commit_data("network", objReturn) then
		-- reboot if data was commited
		reboot()
	end
	
	return format_error_return(objReturn)
end

-- set_lan :)
function set_lan(objData)
	return { lan = _set_lan(objData)}
end

-- SET VOIP --------------------------------------------------------------------

-- _set_voip
-- NOTE : does not commit config changes (this must be done in the wrapper 
--        method.
local function _set_voip(objData, objValid)
	objData         = objData or {}
	objValid        = objValid or {}
	local objReturn = {}
	local asterisk  = uci:get_all("asterisk")
	
	
	local objValidTrunk = { --TODO!!!! : add generic keys
		disabled            = false, --TODO!!!! : add validation
		type                = false, --TODO!!!! : add validation
		use_wan_credentials = false --TODO!!!! : add validation
	}
	
	local objValidExt = {
		cid       = false --TODO!!!! : add validation
	}
	
	local objValidLine = {
		trunk    = false, --TODO!!!! : add validation
		ring     = false, --TODO!!!! : add validation
		clir     = false, --TODO!!!! : add validation
		disabled = false --TODO!!!! : add validation
	}

	-- add trunk(s)
	local objError = {}
	for strId,objItem in pairs(objData.trunk or {}) do
		-- validate name (strId)
		local objItemError = validate(strId, valid.voip_trunk)
		if not has_error(objItemError) then
			-- add section
			uci:set("asterisk", strId, "trunk")
			objItemError = uci_set_data("asterisk", strId, objItem, objValid.trunk or objValidTrunk)
		end
		append_error(objError, strId, objItemError)
	end
	append_error(objReturn, "trunk", objError)
	
	-- add lines
	local objError = {}
	for strId,objItem in pairs(objData.line or {}) do
		-- validate number (strId)
		local objItemError = validate(strId, valid.voip_number) or {}
		if not has_error(objItemError) then
			local objKeyError
			-- check trunk exists for line
			if objItem.trunk then
				-- trunk is set in data
				objKeyError = validate_exists_in_any(objItem.trunk, asterisk, objData.trunk)
			elseif asterisk[strId] and asterisk[strId].trunk then
				-- trunk is set in current config (and therefore should exist, but we check anyway)
				objKeyError = validate_exists_in_any(asterisk[strId].trunk, asterisk, objData.trunk)
			else
				-- trunk... what trunk... I don't see any trunk around here.
				objKeyError = validate_exists(objItem.trunk)
			end
			append_error(objItemError, "trunk", objKeyError)
			-- check extension(s) exists for line
			for _,number in pairs(objItem.ring or {}) do
				objKeyError = validate_exists_in(number, asterisk)
				append_error(objItemError, "ring", objKeyError)
			end
		end
		if not has_error(objItemError) then
			-- add section
			uci:set("asterisk", strId, "ext")
			uci:set("asterisk", strId, "type", "external")
			err = uci_set_data("asterisk", strId, objItem, objValid.line or objValidLine)
		end
		append_error(objError, strId, objItemError)
	end
	append_error(objReturn, "line", objError)
	
	-- update extentions
	local objError = {}
	for strId,objItem in pairs(objData.ext or {}) do
		-- validate id & check extension exists
		local objItemError = validate(strId, valid.voip_ext) or validate_exists_in(strId, asterisk) or {}
		if not has_error(objItemError) then
			-- check line exists for extension
			if objItem.cid ~= nil and tonumber(objItem.cid) ~= 0 then
				local objKeyError = validate_exists_in_any(objItem.cid, asterisk, objData.line)
				append_error(objItemError, "cid", objKeyError)
			end
		end
		if not has_error(objItemError) then
			-- update section
			objItemError = uci_set_data("asterisk", strId, objItem, objValid.ext or objValidExt)
		end
		append_error(objError, strId, objItemError)
	end
	append_error(objReturn, "ext", objError)
	
	-- reload voip
	if not has_error(objReturn) then
		-- reload voip if there is no error
		voip_reload()
	end
	
	return format_error_return(objReturn)
end

-- set_voip
function set_voip(objData)
	-- set voip config
	local  objReturn = _set_voip(objData)
	
	-- if config was set without error
	if not has_error(objReturn) then
		-- check sip registration
		objReturn = check_sip_registration()
	end
	
	-- commit data
	if uci_commit_data("asterisk", objReturn) then
		-- if there was an error, revert the voip config
		uci:revert("asterisk")
		voip_reload()
	end
	
	return {voip = objReturn}
end

-- _set_voip_all
local function _set_voip_all(objData, objValid)
	-- get asterisk config (we will require this later if we need to restore the config)
	local objAsterisk  = uci:get_all("asterisk")
	
	-- remove existing config
	for id,section in pairs(objAsterisk or {}) do
		if section.type == "external" then
			uci:delete("asterisk", id)
		elseif section.target ~= nil then
			if section.cid ~= nil then
				uci:delete("asterisk", id, "cid")
			end
		elseif section[".type"] == "trunk" then
			uci:delete("asterisk", id)
		end
	end

	-- set voip config
	local  objReturn = _set_voip(objData)
	
	-- if config was set without error
	if not has_error(objReturn) then
		-- check sip registration
		objReturn = check_sip_registration()
	end
	
	-- commit data
	if uci_commit_data("asterisk", objReturn) then
		-- if there was an error, revert the voip config
		uci:revert("asterisk")
		voip_reload()
	end
	
	return objReturn
end

-- set_voip_all
function set_voip_all(objData)
	return {voip = _set_voip_all(objData)}
end

-- SET WAN ---------------------------------------------------------------------

-- _set_wan
local function _set_wan(objData, objValid)
	objData         = objData or {}
	objValid        = objValid or {}
	local wanUp     = is_network_up("wan")
	local objReturn = {}
	
	-- default valid keys
		objValidWan = {
			proto		= false, --TODO!!!! : add validation
			username    = false, --TODO!!!! : add validation
			ifname      = false, --TODO!!!! : add validation
			auto        = false, --TODO!!!! : add validation
			trigger     = false, --TODO!!!! : add validation
			password    = valid.password_internet,
			demand      = false  --TODO!!!! : add validation
		}

	-- in case section 'wan' of type 'interface' doesn't exist yet, create
	uci:set("network", "wan", "interface") -- TODO!!!! : does this really ever not exist ????
	
	-- set data
	uci_set_data("network", "wan", objData, objValid.wan or objValidWan, objReturn)
	
	-- commit data
	if not uci_commit_data("network", objReturn) then
		-- return error
		return format_error_return(objReturn)
	end
	
	-- reload network
	if (wanUp == true and objData.up == nil) or objData.up == true then
		--TODO!!!! : does this actually bring up wan iface if it is currently down ?
		ubus:call("network", "reload", {})
	
		-- wait for wan to come up
		wanUp = false
		local i = 0
		while wanUp ~= true and i < intMaxWait do
			os.execute("sleep 1")
			wanUp = is_network_up("wan")
			i = i + 1
		end
	elseif wanUp == true then
		-- bring wan iface down
		ubus:call("network.interface.wan", "down", {})
	end
	
	-- return current network settings
	return get_cur_network({"wan"}).wan
end

-- set_wan
function set_wan(objData)
	return {wan = _set_wan(objData)}
end

-- _set_wan_clean
function _set_wan_clean(objData, objValid)
	local objWan = uci:get_all("network", "wan")
	
	-- define required keys
	local objRequired = {
		ifname  = true,
		auto    = true,
		trigger = true
	}
	-- ifname  : set by target/linux/ltqcpe/base-files/etc/init.d/ppa
	-- auto    : set by target/linux/ltqcpe/base-files/etc/init.d/ppa
	-- trigger : set by ?
	
	-- remove keys
	if objWan then
		for strKey,_ in pairs(objWan) do
			if objRequired[strKey] == nil then
				uci:delete("network", "wan", strKey)
			end
		end
	end
	
	-- set wan
	return {wan = _set_wan(objData, objValid)}
end

-- set_wan_clean
function set_wan_clean(objData)
	return {wan = _set_wan_clean(objData)}
end

-- SET WIRELESS ----------------------------------------------------------------

-- _set_wireless
local function _set_wireless(objData, objValid)
	objData         = objData or {}
	objValid        = objValid or {}
	local objReturn = {}
	local objUp
	
	-- get all wireless conf
	local _wireless  = uci:get_all("wireless")
	-- valid keys for iface
	local objValidIface = {
		ssid       = true,
		hidden     = valid.bool,
		encryption = true,
		key        = valid.wireless_key
	}
	-- valid keys for device
	local objValidDevice = {
		disabled   = valid.bool
	}
	
	-- for each iface in existing conf
	for _,sec in pairs(get_anon_secs("wireless", "wifi-iface")) do
		-- get device id
		local device = _wireless[sec]["device"]
		-- id device exists in data
		if objData[device] ~= nil then
			local objError = {}
			-- set iface keys 
			uci_set_data("wireless", sec, objData[device], objValid.iface or objValidIface, objError)
			-- set device keys
			uci_set_data("wireless", device, objData[device], objValid.device or objValidDevice, objError)
			-- append any errors
			append_error(objReturn, device, objError)
		end
	end

	-- commit data
	if not uci_commit_data("wireless", objReturn) then
		return format_error_return(objReturn)
	end
	
	-- restart wireless
	restart_wireless()
	
	-- check if wireless is up
	_wireless  = uci:get_all("wireless")
	for _,sec in pairs(get_anon_secs("wireless", "wifi-device")) do
		objReturn[sec] = {}
		--TODO!!!! : maybe we should actually check if wireless is up and not just fake it ???? 
		if _wireless[sec].disabled == "1" then
			objReturn[sec].up = false
		else
			objReturn[sec].up = true
		end
	end
	
	return objReturn
end

-- set_wireless
function set_wireless(objData)
	return {wireless = _set_wireless(objData)}
end

-- SET PASSWORD ----------------------------------------------------------------

-- set_password
local function _set_password(objData)
	objData = objData or {}
	
	-- validate input
	local objValid = {
		old    = valid.password_device,
		new    = valid.password_device
	}
	local objReturn = validate_data(objData, objValid, nil, true)
	
	-- if we have valid data
	if is_empty(objReturn) then
		-- check old password
		if not sys.user.checkpasswd("root", old) then
			objReturn.old = val_err_not_found
		else
			-- set new password
			if sys.user.setpasswd("root", new) ~= 0 then
				objReturn.new = val_err_uci_call
			end
		end
	end
	
	return format_error_return(objReturn)
end
function set_password(objData)
	return {password = _set_password(objData)}
end

-- SET EXTERNAL MODEM ----------------------------------------------------------

-- set_external_modem
function set_external_modem(objData)
	objData         = objData or {}
	local enabled   = objData.enabled
	local valid_res = validate(enabled, "bool")
	if valid_res ~= nil then return valid_res end

	local wanstate = get_cur_network({"wan"}).wan

	if wanstate.up or wanstate.pending then
		os.execute("ifdown wan")
	end

	if enabled == 0 then
		uci:set("ppa", "ppa", "wan_mode", "ptm")
	elseif enabled == 1 then
		dsl_control(0)
		uci:set("ppa", "ppa", "wan_mode", "eth")
	else
		return
	end

	uci:commit("ppa")
	os.execute("/etc/init.d/ppa restart > /dev/null 2>&1")

	if enabled == 0 then
		dsl_control(1)
	end

	if wanstate.up or wanstate.pending then
		os.execute("ifup wan")
	end
	
	--TODO!!!! : should return something useful ????
end

--------------------------------------------------------------------------------
-- RPC ACTION calls
--------------------------------------------------------------------------------

function reboot()
	-- give the file system time to finish writing (workaround for flashdrive bug)
	os.execute("sleep 5")
	os.execute("reboot > /dev/null 2>&1")
end

-- disconnect_wan
function disconnect_wan()
	ubus:call("network.interface.wan", "down", {})
	return {wan = get_cur_network({"wan"}).wan}
end

-- restart_wireless
function restart_wireless()
	os.execute("wifi > /dev/null 2>&1 &")
end

function network_restart()
	ubus:call("network", "reload", {})
	restart_wireless()
end

function voip_reload()
	os.execute("/etc/init.d/asterisk-uci reload > /dev/null 2>&1") -- asynchronous
end
