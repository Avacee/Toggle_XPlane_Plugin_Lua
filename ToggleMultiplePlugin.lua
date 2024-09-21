-- A LUA Script to create 2 custom commands that will Enable/Disable the requested plugin.
-- To enable/disable your plugin enter the signature in the TP_XPLM.XPLMFindPluginBySignature() function.
TP_ffi = require("ffi")

TP_XPLM = nil

TP_ffi.cdef([[
	/* XPLMDefs.h" */
	typedef int XPLMPluginID;
	/* XPLMPlugin*/
	XPLMPluginID XPLMFindPluginBySignature(const char * inSignature); 
	int XPLMEnablePlugin(XPLMPluginID inPluginID);
	void XPLMDisablePlugin(XPLMPluginID inPluginID);
	int XPLMIsPluginEnabled(XPLMPluginID inPluginID);
 ]])
 
--[[ Load XPLM library ]]
if SYSTEM == "IBM" then TP_XPLM = TP_ffi.load("XPLM_64")  -- Windows 64bit
    elseif SYSTEM == "LIN" then TP_XPLM = TP_ffi.load("Resources/plugins/XPLM_64.so")  -- Linux 64bit (Requires "Resources/plugins/" for some reason)
    elseif SYSTEM == "APL" then TP_XPLM = TP_ffi.load("Resources/plugins/XPLM.framework/XPLM") -- 64bit MacOS (Requires "Resources/plugins/" for some reason)
    else return
end
if TP_XPLM ~= nil then 
	logMsg("TP_XPLM: Initialised!") 
else
	logMsg("TP_XPLM: Failed to Initialise - Unable to continue") 
	return
end

XPLM_NO_PLUGIN_ID = -1
idToggleSkyscapes = XPLM_NO_PLUGIN_ID
idToggleCloudscapes = XPLM_NO_PLUGIN_ID

create_command("TogglePlugin/Plugin/Skyscapes","Enable or Disable Skyscapes","DoToggleSkyscapes()","","")
create_command("TogglePlugin/Plugin/Cloudscapes","Enable or Disable Cloudscapes","DoToggleCloudscapes()","","")

function DoToggleSkyscapes()
	if idToggleSkyscapes == XPLM_NO_PLUGIN_ID then
		--idToggleSkyscapes = TP_XPLM.XPLMFindPluginBySignature("com.leecbaker.datareftool")
		idToggleSkyscapes = TP_XPLM.XPLMFindPluginBySignature("BiologicalNanobot.enhanced_skyscapes")
		logMsg("TP_XPLM: Found Skyscapes with PluginID " .. idToggleSkyscapes)
	end
	DoEnableDisable(idToggleSkyscapes)
end

function DoToggleCloudscapes()
	if idToggleCloudscapes == XPLM_NO_PLUGIN_ID then
		idToggleCloudscapes = TP_XPLM.XPLMFindPluginBySignature("FarukEroglu2048.enhanced_cloudscapes")
		logMsg("TP_XPLM: Found Cloudscapes with PluginID " .. idToggleCloudscapes)
	end
	DoEnableDisable(idToggleCloudscapes)
end

function DoEnableDisable(pluginID)
	if pluginID ~= XPLM_NO_PLUGIN_ID then
		if TP_XPLM.XPLMIsPluginEnabled(pluginID) == 1 then
			logMsg("TP_XPLM: Disabling Plugin with ID " .. pluginID)
			TP_XPLM.XPLMDisablePlugin(pluginID)
		else
			logMsg("TP_XPLM: Enabling Plugin with ID " .. pluginID)
			TP_XPLM.XPLMEnablePlugin(pluginID)
		end
	end
end
