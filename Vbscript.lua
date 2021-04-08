--Code Written by JelleWho https://github.com/jellewie/

--█Change the below values to EXACTLY match the names/numbers set in Domoticz as device Name/Idx. Can either the name '<exact name>' |or| number <Number>
local DEVICE_BUTTONS = 31

local DEVICES = {
--█Change the below values to EXACTLY match the names/numbers set in Domoticz as device Name/Idx. LightName can either the name '<exact name>' |or| number <Number>
--Random, ButtonState,LightName
	['a'] = {'+' ,29},
	['b'] = {'>' ,24},
	['c'] = {'-' ,26},
	['d'] = {'<' ,25},
	['e'] = {'On',0},
	--['f'] = {''  ,75},
--Idx <0> is switch all on/off (based on the first light on the list)
--ButtonState'' is a dummby light, only used when turning whole group on/off
}

local LogChecking = true																--Set to TRUE to log when the button is pressed
local LogDebugging = false																--Set to TRUE to receive more information in the log

return {
	logging = {
		--level = domoticz.LOG_INFO,													--█Uncomment to override the dzVents global logging setting
		marker = 'BUT'
	},
	on = {
		devices = {DEVICE_BUTTONS}
	},
	execute = function(domoticz, switch)
		if LogChecking then domoticz.log(' - Switch state='..tostring(switch.state)) end

		for i, item in pairs(DEVICES) do												--Loop through all the devices
			if (switch.state == item[1]) then											--If we have a Trigger Action match
				if item[2] == 0 then													--If this is the global ON/OFF action
					TurnOff = false if domoticz.devices(29).state == 'On' then TurnOff = true end	--Save if we must turn everything off or on
					for i, item in pairs(DEVICES) do
						if LogDebugging then domoticz.log(' - Switch '..tostring(item[2])..' to '..tostring(TurnOff)) end
						if item[2] ~= 0 then
							if TurnOff then
								domoticz.devices(item[2]).switchOff()
							else
								domoticz.devices(item[2]).switchOn()
							end
						end
					end
					return
				end

				domoticz.devices(item[2]).toggleSwitch()								--Toggle the LightName attached to the ButtonState
				return
			end
		end
	end
}