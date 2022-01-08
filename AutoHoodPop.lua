script_name("AutoHoodPop")
script_description("Automatically pops the hood when car health is low.")
script_version_number("1")
script_version("1.2.3")
script_authors("Masaharu Morimoto (Design & Implementation)","Brad Ringer (Boilerplate & Consulting)")

require "moonloader"
require "sampfuncs"

-- car needs repair - default to false
repairNeeded = false

-- ****START**** inicfg section - to use ini files
local inicfg = require "inicfg"

dir = getWorkingDirectory() .. "\\config\\Masaharu's Config\\"
dir2 = getWorkingDirectory() .. "\\config\\"
config = dir .. "AutoHoodPop.ini"

-- check if the config folder and ini file exists, if not, create them, enter default settings, and save
if not doesDirectoryExist(dir2) then createDirectory(dir2) end
if not doesDirectoryExist(dir) then createDirectory(dir) end
if not doesFileExist(config) then
	file = io.open(config, "w")
	file:write(" ")
	file:close()
	local directIni = config
	local mainIni = inicfg.load(inicfg.load({
		Options = {
			isScriptEnabled = true,
			dangerZone = 400,
		},
	}, directIni))

	inicfg.save(mainIni, directIni)
end

local directIni = config
local mainIni = inicfg.load(nil, directIni)
inicfg.save(mainIni, directIni)
-- ****END**** inicfg section

function main()
	while not isSampAvailable() do wait(100) end -- wait until samp is available and register commands
	sampAddChatMessage("{EC5800}| AutoHoodPop | {FFC100}Author: {4285F4}Masaharu Morimoto {FFFFFF}| [{FFC100}/ahphelp{FFFFFF}]", 0xFFC100)
	sampAddChatMessage("{EC5800}| AutoHoodPop | {FFFFFF}- {FF3333}Danger Zone Set to < {FFFFFF}" .. mainIni.Options.dangerZone .. " HP", 0xFFC100)
	sampRegisterChatCommand("ahp", cmdScriptToggle) -- toggles the script
	sampRegisterChatCommand("ahphelp", cmdHelp) -- full version of the help commmand. Requires /pagesize 14+
	sampRegisterChatCommand("ahpabout", cmdAbout) -- set the health you want the hood to pop at / notification to be announced
	sampRegisterChatCommand("ahpmini", cmdMiniHelp) -- mini version of the help command for people with small /pagesize
	sampRegisterChatCommand("ahphealth", cmdHealthChange) -- set the health you want the hood to pop at / notification to be announced
	while true do -- begin main loop
		wait(0)
	  if vehCheck() and mainIni.Options.isScriptEnabled then -- check to make sure player is in a car, boat, or heli and script is enabled
			local carHandle = storeCarCharIsInNoSave(PLAYER_PED) -- these variables are thanks to Brad
			local carDriver = getDriverOfCar(carHandle) -- these variables are thanks to Brad
	    local carHealth = getCarHealth(carHandle)
			if carHealth < mainIni.Options.dangerZone and not repairNeeded and carDriver == 1 and not isCharOnAnyBike(PLAYER_PED) and not isCharInFlyingVehicle(PLAYER_PED) then -- For vehicles that require /car hood (cars & boats)
				sampSendChat("/car hood")
				sampAddChatMessage("{EC5800}| AutoHoodPop | {FFFFFF}- {22FF22}Hood Popped!", 0xFFC100)
				repairNeeded = true
			elseif carHealth < mainIni.Options.dangerZone and not repairNeeded and carDriver == 1 and isCharOnAnyBike(PLAYER_PED) then -- I am on a bike, /car hood not required
				sampAddChatMessage("{EC5800}| AutoHoodPop | {FFC100}- {22FF22}Repair Needed!", 0xFFC100)
				repairNeeded = true
			elseif carHealth < mainIni.Options.dangerZone and not repairNeeded and carDriver == 1 and isCharInFlyingVehicle(PLAYER_PED) then -- I am in any flying vehicle, /car hood not required
				sampAddChatMessage("{EC5800}| AutoHoodPop | {FFC100}- {22FF22}Repair Needed!", 0xFFC100)
				repairNeeded = true
			elseif carHealth > mainIni.Options.dangerZone and repairNeeded and carDriver == 1 then -- used to reset the "state" of the AutoHoodPop
				repairNeeded = false
			end
		end
	end
end

function vehCheck() -- need to check if we are in any type of vehicle before running through loop
	if isCharInAnyCar(PLAYER_PED) or isCharInAnyBoat(PLAYER_PED) or isCharInAnyHeli(PLAYER_PED) or isCharInAnyPlane(PLAYER_PED) or isCharOnAnyBike(PLAYER_PED) or isCharInFlyingVehicle(PLAYER_PED) then
		return true
	else -- we aint in a car
		return false
	end
end

function cmdScriptToggle() -- enable / disable the script
	if mainIni.Options.isScriptEnabled then
		mainIni.Options.isScriptEnabled = false
		sampAddChatMessage("{EC5800}| AutoHoodPop | {FFFFFF}- {FF2222}Disabled", 0xFFC100)
		inicfg.save(mainIni, directIni)
	else
		mainIni.Options.isScriptEnabled = true
		sampAddChatMessage("{EC5800}| AutoHoodPop | {FFFFFF}- {22FF22}Enabled", 0xFFC100)
		inicfg.save(mainIni, directIni)
	end
end

function cmdHealthChange(newDangerZone) -- function to allow changing and saving of health "danger zone"
	if newDangerZone == nil or newDangerZone == "" or not isInteger(newDangerZone) then
		sampAddChatMessage("{EC5800}| AutoHoodPop | {FFFFFF}- {FF3333}Danger Zone must be an integer and not empty", 0xFFC100)
	else
		newDangerZoneNum = tonumber(newDangerZone)
		if newDangerZoneNum >= 1000 or newDangerZoneNum <= 249 then
			sampAddChatMessage("{EC5800}| AutoHoodPop | {FFFFFF}- {FF3333}Danger Zone must be between 250 HP and 999 HP", 0xFFC100)
		else
			mainIni.Options.dangerZone = newDangerZoneNum
			sampAddChatMessage("{EC5800}| AutoHoodPop | {FFFFFF}- {FF3333}Danger Zone Changed to < {FFFFFF}" .. tostring(newDangerZoneNum) .. " HP", 0xFFC100)
			inicfg.save(mainIni, directIni)
		end
	end
end

function isInteger(str) -- makes sure it's an integer
  return not (str == "" or str:find("%D"))
end

function cmdHelp()
	sampAddChatMessage("{FFFFFF}|-----------{EC5800} | AutoHoodPop | {FFFFFF}from {4285F4}MORIMOTO Industries {FFFFFF}-----------|", 0xFFC100)
	sampAddChatMessage("{FFC100}- Commands:", 0xFFC100)
	sampAddChatMessage("{EC5800}/ahp {FFFFFF}- Enable/Disable {EC5800}| AutoHoodPop |", 0xFFC100)
	sampAddChatMessage("{EC5800}/ahphelp {FFFFFF}- Show the help menu.", 0xFFC100)
	sampAddChatMessage("{EC5800}/ahpmini {FFFFFF}- Show the mini help menu.", 0xFFC100)
	sampAddChatMessage("{EC5800}/ahphealth {FFFFFF}- Set health hood will open at. E.g. [/ahphealth 350]", 0xFFC100)
	sampAddChatMessage("{EC5800}/ahpabout {FFFFFF}- Version information.", 0xFFC100)
	sampAddChatMessage(" ", 0xFFC100)
	sampAddChatMessage("{FFC100}- Description:", 0xFFC100)
	sampAddChatMessage("{FFFFFF}This script will automatically type /car hood when vehicle", 0xFFC100)
	sampAddChatMessage("{FFFFFF}health goes below a set amount. - {EC5800}Currently Set To: {FFFFFF}" .. mainIni.Options.dangerZone .. " HP", 0xFFC100)
	sampAddChatMessage(" ", 0xFFC100)
	sampAddChatMessage("{FFC100}- Author:", 0xFFC100)
	sampAddChatMessage("{FFFFFF}Masaharu Morimoto#2302", 0xFFC100)
	sampAddChatMessage("{FFFFFF}|-----------{EC5800} | AutoHoodPop | {FFFFFF}from {4285F4}MORIMOTO Industries {FFFFFF}-----------|", 0xFFC100)
end

function cmdMiniHelp()
	sampAddChatMessage("{FFFFFF}|-------------{EC5800} | AutoHoodPop | {FFFFFF}- {FF3333}Danger Zone < {FFFFFF}" .. mainIni.Options.dangerZone .. " HP {FFFFFF}-------------|", 0xFFC100)
	sampAddChatMessage("{EC5800}/ahp {FFFFFF}- Enable/Disable {EC5800}| AutoHoodPop |", 0xFFC100)
	sampAddChatMessage("{EC5800}/ahphelp {FFFFFF}- Show the help menu.", 0xFFC100)
	sampAddChatMessage("{EC5800}/ahpmini {FFFFFF}- Show the mini help menu.", 0xFFC100)
	sampAddChatMessage("{EC5800}/ahphealth {FFFFFF}- Set health hood will open at. E.g. [/ahphealth 350]", 0xFFC100)
end

function cmdAbout()
	local description = "{FFFFFF}From {4285F4}MORIMOTO Industries {FFFFFF}" .. "\n\n" .. "AutoHoodPop is a GTA:SA Moonloader modification that automatically opens your car hood at a specified HP.\nThe health danger zone is defaulted to 400 on first launch and can be changed and saved permanently by the user.\nIt handles all types of vehicles so if you are in a vehicle that does not require [/car hood] you will get a Repair Needed notification only." .. "\n\n" .. "Version Changes:\nv1.2.2\n- Now handles all types of vehicles\n- Added Repair Needed notification" .. "\n\n" .. "For more information use - {EC5800}[/ahphelp]"
	local titleBar = "{EC5800}| AutoHoodPop | v1.2.3"
	sampShowDialog(6969, titleBar, description, "Close")
end
