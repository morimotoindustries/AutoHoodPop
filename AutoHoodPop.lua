script_name("AutoHoodPop")
script_description("Automatically pops the hood when car health is low.")
script_version_number("1")
script_version("1.2.0")
script_authors("Masaharu Morimoto (Design & Implementation)","Brad Ringer (Boilerplate & Consulting Only - No Script Use/Design/Implementation/Legal Responsibility or Involvement)")

require "moonloader"
require "sampfuncs"
require 'inicfg'

repairNeeded = false

-- START inicfg section - to use ini files
local inicfg = require "inicfg"

dir = getWorkingDirectory() .. "\\config\\Masaharu's Config\\"
dir2 = getWorkingDirectory() .. "\\config\\"
config = dir .. "AutoHoodPop.ini"

-- check if the config folder and ini file exists, if not, create them and save
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
-- END inicfg section

function main()
	while not isSampAvailable() do wait(100) end -- wait until samp is available and register commands
	sampAddChatMessage("{EC5800}| AutoHoodPop | {FFC100}Author: {4285F4}Masaharu Morimoto | {FFFFFF}[{FFC100}/ahphelp{FFFFFF}]", 0xFFC100)
	sampAddChatMessage("{EC5800}| AutoHoodPop | {FFFFFF}- {FF3333}Danger Zone Set to <= {FFFFFF}" .. mainIni.Options.dangerZone .. " HP", 0xFFC100)
	sampRegisterChatCommand("ahp", cmdScriptToggle)
	sampRegisterChatCommand("ahphelp", cmdHelp)
	sampRegisterChatCommand("ahpmini", cmdMiniHelp)
	sampRegisterChatCommand("ahphealth", cmdHealthChange)
	while true do -- begin main loop
	wait(0)
  if isCharInAnyCar(PLAYER_PED) and mainIni.Options.isScriptEnabled then -- check to make sure player is in a car and script is enabled
		local carHandle = storeCarCharIsInNoSave(PLAYER_PED)
		local carDriver = getDriverOfCar(carHandle)
    local carHealth = getCarHealth(carHandle)
		if carHealth <= mainIni.Options.dangerZone and not repairNeeded and carDriver == 1 then
			sampSendChat("/car hood")
			sampAddChatMessage("{EC5800}| AutoHoodPop | {FFFFFF}- {22FF22}Hood Popped!", 0xFFC100)
			repairNeeded = true
		elseif carHealth >= mainIni.Options.dangerZone and repairNeeded and carDriver == 1 then -- used to reset the "state" of the AutoHoodPop
			repairNeeded = false
		end
	end
end
end

function cmdScriptToggle()
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

function cmdHealthChange(newDangerZone)
	if newDangerZone == nil or newDangerZone == "" or not isInteger(newDangerZone) then
		sampAddChatMessage("{EC5800}| AutoHoodPop | {FFFFFF}- {FF3333}Danger Zone must be an integer and not empty", 0xFFC100)
	else
		newDangerZoneNum = tonumber(newDangerZone)
		if newDangerZoneNum >= 1000 or newDangerZoneNum <= 249 then
			sampAddChatMessage("{EC5800}| AutoHoodPop | {FFFFFF}- {FF3333}Danger Zone must be between 250 HP and 999 HP", 0xFFC100)
		else
			mainIni.Options.dangerZone = newDangerZoneNum
			sampAddChatMessage("{EC5800}| AutoHoodPop | {FFFFFF}- {FF3333}Danger Zone Changed to <= {FFFFFF}" .. tostring(newDangerZoneNum) .. " HP", 0xFFC100)
			inicfg.save(mainIni, directIni)
		end
	end
end

function isInteger(str)
  return not (str == "" or str:find("%D"))
end

function cmdHelp()
	sampAddChatMessage("{FFFFFF}|-----------{EC5800} | AutoHoodPop | {FFFFFF}from {4285F4}MORIMOTO Industries {FFFFFF}-----------|", 0xFFC100)
	sampAddChatMessage("{FFC100}- Commands:", 0xFFC100)
	sampAddChatMessage("{EC5800}/ahp {FFFFFF}- Enable/Disable {EC5800}| AutoHoodPop |", 0xFFC100)
	sampAddChatMessage("{EC5800}/ahphelp {FFFFFF}- Show the help menu.", 0xFFC100)
	sampAddChatMessage("{EC5800}/ahpmini {FFFFFF}- Show the mini help menu.", 0xFFC100)
	sampAddChatMessage("{EC5800}/ahphealth {FFFFFF}- Set health hood will open at. E.g. [/ahphealth 350]", 0xFFC100)
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
	sampAddChatMessage("{FFFFFF}|-----------{EC5800} | AutoHoodPop | {FF3333}Danger Zone <= {FFFFFF}" .. mainIni.Options.dangerZone .. " HP" {FFFFFF}-----------|", 0xFFC100)
	sampAddChatMessage("{EC5800}/ahp {FFFFFF}- Enable/Disable {EC5800}| AutoHoodPop |", 0xFFC100)
	sampAddChatMessage("{EC5800}/ahphelp {FFFFFF}- Show the help menu.", 0xFFC100)
	sampAddChatMessage("{EC5800}/ahpmini {FFFFFF}- Show the mini help menu.", 0xFFC100)
	sampAddChatMessage("{EC5800}/ahphealth {FFFFFF}- Set health hood will open at. E.g. [/ahphealth 350]", 0xFFC100)
end
