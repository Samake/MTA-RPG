Inventory_C = inherit(Class)

function Inventory_C:constructor(player)
	
	self.player = player
	self.slots = {}
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Inventory_C for player " .. self.player:getName() .. " was loaded.")
	end
end


function Inventory_C:init()
	self.m_SyncSlots = bind(self.syncSlots, self)
	addEvent("SYNCPLAYERITEMS", true)
	addEventHandler("SYNCPLAYERITEMS", root, self.m_SyncSlots)
	
	for i = 1, Settings.inventorySize, 1 do
		for j = 1, Settings.inventorySize, 1 do
			
			local slotID = i .. ":" .. j
			
			if (not self.slots[slotID]) then
				self.slots[slotID] = nil
			end
		end
	end
end


function Inventory_C:syncSlots(slotItems)
	if (slotItems) then
		for index, slotItem in pairs(slotItems) do
			if (slotItem) then
				if (slotItem.slotID) then
					if (self.slots[slotItem.slotID]) then
						if (self.slots[slotItem.slotID].id == slotItem.id) then
							self.slots[slotItem.slotID].count = slotItems.count
						else
							self:deleteSlot(slotItem.slotID)
			
							self.slots[slotItem.slotID].item = Item_C:new(slotItem)
						end
					else
						self.slots[slotItem.slotID] = Item_C:new(slotItem)
					end
				end
			end
		end
	end
end


function Inventory_C:deleteSlot(slotID)
	if (slotID) then
		if (self.slots[slotID]) then
			if (self.slots[slotID]) then
				self.slots[slotID]:delete()
				self.slots[slotID] = nil
			end
		end
	end
end


function Inventory_C:getSlots()
	return self.slots
end


function Inventory_C:clear()
	removeEventHandler("SYNCPLAYERITEMS", root, self.m_SyncSlots)
	
	for index, slotItem in pairs(self.slots) do
		if (slotItem) then
			slotItem:delete()
			slotItem = nil
		end
	end
end


function Inventory_C:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("Inventory_C for player " .. self.player:getName() .. " was deleted")
	end
end