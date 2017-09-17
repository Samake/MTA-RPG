Attack_S = inherit(Class)

function Attack_S:constructor(player, slot, slotContent)
	
	self.player = player
	self.slot = slot
	self.settings = slotContent
	self.name = self.settings.name
	self.damage = self.settings.damage
	self.costs = self.settings.costs
	self.delay = self.settings.delay
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Attack_S for player " .. self.player:getName() .. " was loaded on slot " .. self.slot .. ".")
	end
end


function Attack_S:init()
	self.m_DoSlotAction = bind(self.doSlotAction, self)
	addEvent("DOSLOTACTION", true)
	addEventHandler("DOSLOTACTION", root, self.m_DoSlotAction)
end


function Attack_S:doSlotAction(slot)
	if (client) and (isElement(client)) and (slot) then
		if (self.slot == slot) and (client == self.player) then

		end
	end
end


function Attack_S:update()

end


function Attack_S:clear()
	removeEventHandler("DOSLOTACTION", root, self.m_DoSlotAction)
end


function Attack_S:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("Attack_S for player " .. self.player:getName() .. " was deleted on slot " .. self.slot .. ".")
	end
end