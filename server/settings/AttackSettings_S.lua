Attacks = {}

Attacks["Default"] = {}
Attacks["Default"]["Punch"] = {name = "Punch", icon = "Icons|Attacks|1", damage = 150, costs = 1, class = AttackPunch_S, delay = 500, radius = 1.5}
Attacks["Default"]["Kick"] = {name = "Kick", icon = "Icons|Attacks|2", damage = 800, costs = 4, class = AttackKick_S, delay = 5000, radius = 3.5}
Attacks["Default"]["Punch3"] = {name = "Punch 3", icon = "Icons|Attacks|1", damage = 500, costs = 4, class = AttackPunch_S, delay = 4000, radius = 1.5}
Attacks["Default"]["Punch4"] = {name = "Punch 4", icon = "Icons|Attacks|1", damage = 700, costs = 6, class = AttackPunch_S, delay = 6000, radius = 1.5}
Attacks["Default"]["Punch5"] = {name = "Punch 5", icon = "Icons|Attacks|1", damage = 850, costs = 7, class = AttackPunch_S, delay = 8000, radius = 1.5}


addEvent("GETATTACKSETTINGS", true)
addEventHandler("GETATTACKSETTINGS", root, function()
	if (client) and (isElement(client)) then
		triggerClientEvent(client, "SENDATTACKSETTINGS", client, Attacks)
	end
end)