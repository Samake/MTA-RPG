AttackManager_S = inherit(Singleton)

function AttackManager_S:constructor()

	self.playerAttackClasses = {}
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("AttackManager_S was loaded.")
	end
end


function AttackManager_S:init()

end


function AttackManager_S:update()
	for index, playerClasses in pairs(self.playerAttackClasses) do
		if (playerClasses) then
			for _, class in pairs(playerClasses) do
				class:update()
			end
		end
	end
end


function AttackManager_S:setPlayerAttacks(player, attacks)
	if (player) and (attacks) then
		if (not self.playerAttackClasses[tostring(player)]) then
			self.playerAttackClasses[tostring(player)] = {}
			
			for index, slotContent in pairs(attacks) do
				if (slotContent) then
					if (not self.playerAttackClasses[tostring(player)][index]) and (slotContent.class) then
						self.playerAttackClasses[tostring(player)][index] = slotContent.class:new(player, index, slotContent)
					end
				end
			end
		else
			self:deletePlayerAttacks(player)
			
			for index, slotContent in pairs(attacks) do
				if (slotContent) then
					if (not self.playerAttackClasses[tostring(player)][index]) and (slotContent.class) then
						self.playerAttackClasses[tostring(player)][index] = slotContent.class:new(player, index, slotContent)
					end
				end
			end
		end
	end
end


function AttackManager_S:deletePlayerAttacks(player)
	if (player) then
		if (self.playerAttackClasses[tostring(player)]) then
			for _, class in pairs(self.playerAttackClasses[tostring(player)]) do
				class:delete()
				class = nil
			end
			
			self.playerAttackClasses[tostring(player)] = nil
		end
	end
end


function AttackManager_S:clear()
	for index, playerClasses in pairs(self.playerAttackClasses) do
		if (playerClasses) then
			for _, class in pairs(playerClasses) do
				class:delete()
				class = nil
			end
			
			playerClasses = nil
		end
	end
end


function AttackManager_S:destructor()
	self:clear()

	if (Settings.showManagerDebugInfo == true) then
		sendMessage("AttackManager_S was deleted.")
	end
end