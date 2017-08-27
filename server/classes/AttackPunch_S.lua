AttackPunch_S = inherit(Attack_S)

function AttackPunch_S:constructor(player, slot, slotContent)
	
	self.player = player
	self.slot = slot
	self.settings = slotContent
	self.name = self.settings.name
	self.damage = self.settings.damage
	self.costs = self.settings.costs
	self.delay = self.settings.delay
	
	self.actionRadius = 1.5
	self.actionCol = nil
	
	self.playerPos = nil
	self.playerRot = nil
	
	self.startTick = 0
	self.currentTick = 0
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("AttackPunch_S for player " .. self.player:getName() .. " was loaded on slot " .. self.slot .. ".")
	end
end


function AttackPunch_S:init()
	self.m_DoSlotAction = bind(self.doSlotAction, self)
	addEvent("DOSLOTACTION", true)
	addEventHandler("DOSLOTACTION", root, self.m_DoSlotAction)
end


function AttackPunch_S:doSlotAction(slot)
	if (client) and (isElement(client)) and (slot) then
		if (self.slot == slot) and (client == self.player) then

			if (self.player) and (isElement(self.player))then
				self.playerClass = PlayerManager_S:getSingleton():getPlayerClass(self.player)
				
				if (self.playerClass) then
						if (self.costs < self.playerClass:getMana()) then
						outputChatBox(self.player:getName() .. " used " .. self.name .. " at slot " .. self.slot .. "!")
						
						self.playerPos = self.player:getPosition()
						self.playerRot = self.player:getRotation()
					
						if (self.playerPos) and (self.playerRot) then
							self.player:setAnimation("fight_b", "fightb_1", -1, false, false, true, false, 250)
							
							local x, y, z = getAttachedPosition(self.playerPos.x, self.playerPos.y, self.playerPos.z, self.playerRot.x, self.playerRot.y, self.playerRot.z, 0.8, 0, 0.2)
							
							if (not self.actionCol) then
								self.actionCol = createColSphere(x, y, z, self.actionRadius)
							else
								self.actionCol:setPosition(x, y, z)
							end
							
							self.playerClass:changeMana(-self.costs)
							
							self.startTick = getTickCount()
						end
					end
				end
			end
		end
	end
end


function AttackPunch_S:update()
	self.currentTick = getTickCount()
	
	if (self.actionCol) then
		for index, enemy in pairs(self.actionCol:getElementsWithin("ped")) do
			if (enemy) then
				enemy:kill()
			end
		end
	end
	
	if (self.currentTick > self.startTick + 250) then
		self:deleteCol()
	end
end


function AttackPunch_S:deleteCol()
	if (self.actionCol) then
		self.actionCol:destroy()
		self.actionCol = nil
	end
end


function AttackPunch_S:clear()
	removeEventHandler("DOSLOTACTION", root, self.m_DoSlotAction)
	
	self:deleteCol()	
end


function AttackPunch_S:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("AttackPunch_S for player " .. self.player:getName() .. " was deleted on slot " .. self.slot .. ".")
	end
end