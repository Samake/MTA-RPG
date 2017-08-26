Attacks = {}

addEventHandler("onClientResourceStart", root, function()
	triggerServerEvent("GETATTACKSETTINGS", root)
end)

addEvent("SENDATTACKSETTINGS", true)
addEventHandler("SENDATTACKSETTINGS", root, function(attackSettings)
	if (attackSettings) then
		Attacks = attackSettings
	end
end)