AttackKick_S = inherit(Attack_S)

function AttackKick_S:constructor(player, slot, slotContent)
	
	self.player = player
	self.slot = slot
	self.settings = slotContent
	self.name = self.settings.name or "Unknown"
	self.damage = self.settings.damage or 0
	self.costs = self.settings.costs or 0
	self.delay = self.settings.delay or 1000
	self.actionRadius = self.settings.radius or 1

	self.actionCol = nil
	
	self.playerPos = nil
	self.playerRot = nil
	
	self.startTick = 0
	self.currentTick = 0
	
	self.damageDelay = 250
	self.isReady = true
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("AttackKick_S for player " .. self.player:getName() .. " was loaded on slot " .. self.slot .. ".")
	end
end


function AttackKick_S:init()
	self.m_DoSlotAction = bind(self.doSlotAction, self)
	addEvent("DOSLOTACTION", true)
	addEventHandler("DOSLOTACTION", root, self.m_DoSlotAction)
end


function AttackKick_S:doSlotAction(slot)
	if (client) and (isElement(client)) and (slot) then
		if (self.slot == slot) and (client == self.player) then

			if (self.player) and (isElement(self.player))then
				self.playerClass = PlayerManager_S:getSingleton():getPlayerClass(self.player)
				local npcClass = NPCManager_S:getSingleton():getNPCClass(enemy)
				
				if (self.playerClass) then
					if (self.costs < self.playerClass:getMana()) then
						self.playerPos = self.player:getPosition()
						self.playerRot = self.player:getRotation()
						self.critChance = self.playerClass:getCritChance()
						self.levelModifier = self.playerClass:getLevelModifier()
					
						if (self.playerPos) and (self.playerRot) then
							self.player:setAnimation(Animations["Player"]["Kick"].block, Animations["Player"]["Kick"].anim, -1, false, false, true, false, 250)
							
							local x, y, z = getAttachedPosition(self.playerPos.x, self.playerPos.y, self.playerPos.z, self.playerRot.x, self.playerRot.y, self.playerRot.z, 0.8, 0, 0.2)
							
							if (not self.actionCol) then
								self.actionCol = createColSphere(x, y, z, self.actionRadius)
							else
								self.actionCol:setPosition(x, y, z)
							end
							
							self.playerClass:changeMana(-self.costs)
							
							if (self.actionCol) then
								for index, enemy in pairs(self.actionCol:getElementsWithin("ped")) do
									if (enemy) and (isElement(enemy)) then
										local npcClass = NPCManager_S:getSingleton():getNPCClass(enemy)
										
										if (npcClass) and (npcClass:isPedAlive() == true) then
											if (not npcClass:getAttacker()) then
												npcClass:setAttacker(self.playerClass)
											end
											
											local critModifier = math.random(1, 100)
											local damage = self.damage * self.levelModifier
											local enemyPos = enemy:getPosition()
											
											if (critModifier <= self.critChance) then
												damage = self.damage * 3
												Text3DManager_S:sendText(self.player, damage .. " Critical!", enemyPos.x, enemyPos.y, enemyPos.z + 0.5, 220, 200, 90, 1.5)
											else
												Text3DManager_S:sendText(self.player, damage, enemyPos.x, enemyPos.y, enemyPos.z + 0.5, 220, 220, 220, 0.5)
											end

											npcClass:changeLife(-damage)
										end
									end
								end
							end
							
							self.startTick = getTickCount()
						end
					end
				end
			end
		end
	end
end


function AttackKick_S:update()
	self.currentTick = getTickCount()

	if (self.currentTick > self.startTick + self.damageDelay) then
		self:deleteCol()
	end
end


function AttackKick_S:deleteCol()
	if (self.actionCol) then
		self.actionCol:destroy()
		self.actionCol = nil
	end
end


function AttackKick_S:clear()
	removeEventHandler("DOSLOTACTION", root, self.m_DoSlotAction)
	
	self:deleteCol()	
end


function AttackKick_S:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("AttackKick_S for player " .. self.player:getName() .. " was deleted on slot " .. self.slot .. ".")
	end
end