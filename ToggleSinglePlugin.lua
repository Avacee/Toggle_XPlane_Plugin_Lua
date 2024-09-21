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
idYourPlugin = XPLM_NO_PLUGIN_ID

create_command("TogglePlugin/Plugin/CommandName","Enable or Disable YourPlugin","DoToggleYourPlugin()","","")

function DoToggleYourPlugin()
	if idYourPlugin == XPLM_NO_PLUGIN_ID then
		idYourPlugin = TP_XPLM.XPLMFindPluginBySignature("Your.Plugin.Signature")   --Update this with YourPlugin Signature
		logMsg("TP_XPLM: Found YourPlugin with PluginID " .. idYourPlugin)
	end
	if idYourPlugin ~= XPLM_NO_PLUGIN_ID then
		if TP_XPLM.XPLMIsPluginEnabled(pluginID) == 1 then
			logMsg("TP_XPLM: Disabling YourPlugin with ID " .. pluginID)
			TP_XPLM.XPLMDisablePlugin(idYourPlugin)
		else
			logMsg("TP_XPLM: Enabling YourPlugin with ID " .. pluginID)
			TP_XPLM.XPLMEnablePlugin(idYourPlugin)
		end
  else
		logMsg("TP_XPLM: Failed to find YourPlugin ID is: " .. idYourPlugin)
	end

end

