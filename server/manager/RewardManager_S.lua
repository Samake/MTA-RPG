RewardManager_S = inherit(Singleton)

function RewardManager_S:constructor()

	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("RewardManager_S was loaded.")
	end
end


function RewardManager_S:init()

end


function RewardManager_S:giveXPReward(attackerClass, xp, x, y, z)
	if (attackerClass) and (xp) and (x) and (y) and (z) then
		local xpReward = xp
		
		if (EventManager_S:getSingleton():isDoubleXPEvent() == true) then
			xpReward = xpReward * 2
		end
		
		attackerClass:changeXP(xpReward)
		Text3DManager_S:sendText(attackerClass.player, "+" .. xpReward .. " XP" , x, y, z + 0.5, 90, 220, 90, 1.5)
	end
end


function RewardManager_S:giveLootReward(attackerClass, money, level, x, y, z)
	if (attackerClass) and (money) and (level) and (x) and (y) and (z) then
		local moneyReward = money * level * attackerClass:getLevel()
		
		if (EventManager_S:getSingleton():isDoubleMoneyEvent() == true) then
			moneyReward = moneyReward * 2
		end
		
		LootManager_S:getSingleton():addLoot(attackerClass.player, moneyReward, x, y, z)
	end
end


function RewardManager_S:clear()

end


function RewardManager_S:destructor()
	self:clear()

	if (Settings.showManagerDebugInfo == true) then
		sendMessage("RewardManager_S was deleted.")
	end
end