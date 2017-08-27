Attacks = {}

Attacks["Default"] = {}
Attacks["Default"]["Punch1"] = {name = "Punch 1", icon = "Icons|Attacks|1", damage = 50, costs = 1, class = AttackPunch_S, delay = 100}
Attacks["Default"]["Punch2"] = {name = "Punch 2", icon = "Icons|Attacks|1", damage = 200, costs = 2, class = AttackPunch_S, delay = 3000}
Attacks["Default"]["Punch3"] = {name = "Punch 3", icon = "Icons|Attacks|1", damage = 300, costs = 5, class = AttackPunch_S, delay = 4000}
Attacks["Default"]["Punch4"] = {name = "Punch 4", icon = "Icons|Attacks|1", damage = 500, costs = 8, class = AttackPunch_S, delay = 6000}
Attacks["Default"]["Punch5"] = {name = "Punch 5", icon = "Icons|Attacks|1", damage = 750, costs = 10, class = AttackPunch_S, delay = 9000}


addEvent("GETATTACKSETTINGS", true)
addEventHandler("GETATTACKSETTINGS", root, function()
	if (client) and (isElement(client)) then
		triggerClientEvent(client, "SENDATTACKSETTINGS", client, Attacks)
	end
end)