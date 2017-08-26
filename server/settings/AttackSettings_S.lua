Attacks = {}

Attacks["Default"] = {}
Attacks["Default"]["Punch1"] = {icon = "Icons|Attacks|1", damage = 10, costs = 1, class = AttackPunch_S, delay = 100}
Attacks["Default"]["Punch2"] = {icon = "Icons|Attacks|1", damage = 100, costs = 1, class = AttackPunch_S, delay = 3000}
Attacks["Default"]["Punch3"] = {icon = "Icons|Attacks|1", damage = 200, costs = 1, class = AttackPunch_S, delay = 4000}
Attacks["Default"]["Punch4"] = {icon = "Icons|Attacks|1", damage = 300, costs = 1, class = AttackPunch_S, delay = 5000}
Attacks["Default"]["Punch5"] = {icon = "Icons|Attacks|1", damage = 400, costs = 1, class = AttackPunch_S, delay = 6000}

addEvent("GETATTACKSETTINGS", true)
addEventHandler("GETATTACKSETTINGS", root, function()
	if (client) and (isElement(client)) then
		triggerClientEvent(client, "SENDATTACKSETTINGS", client, Attacks)
	end
end)