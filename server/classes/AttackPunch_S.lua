AttackPunch_S = inherit(Attack_S)

function AttackPunch_S:constructor(player, slot, slotContent)
	
	self.player = player
	self.slot = slot
	self.settings = slotContent
	self.name = self.settings.name
	self.damage = self.settings.damage
	self.costs = self.settings.costs
	self.delay = self.settings.delay
	
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
			outputChatBox(self.player:getName() .. " attacks with " .. self.name .. " on slot " .. self.slot .. "!")
			
			if (self.player) and (isElement(self.player))then
				self.player:setAnimation("fight_b", "fightb_1", -1, false, false, true, false, 250)
			end
		end
	end
end


function AttackPunch_S:update()

end


function AttackPunch_S:clear()
	removeEventHandler("DOSLOTACTION", root, self.m_DoSlotAction)
end


function AttackPunch_S:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("AttackPunch_S for player " .. self.player:getName() .. " was deleted on slot " .. self.slot .. ".")
	end
end