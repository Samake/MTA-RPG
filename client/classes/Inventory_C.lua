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
				self.slots[slotID] = {}
				self.slots[slotID].item = nil
				self.slots[slotID].count = 0
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
						if (not self.slots[slotItem.slotID].item) then
							self.slots[slotItem.slotID].item = Item_C:new(slotItem)
							
							if (self.slots[slotItem.slotID].item) then
								self.slots[slotItem.slotID].count = slotItem.count
							end
						else
							if (self.slots[slotItem.slotID].item.id == slotItem.id) then
								self.slots[slotItem.slotID].count = slotItem.count
							else
								self:deleteSlot(slotItem.slotID)
								
								if (not self.slots[slotItem.slotID].item) then
									self.slots[slotItem.slotID].item = Item_C:new(slotItem)
									
									if (self.slots[slotItem.slotID].item) then
										self.slots[slotItem.slotID].count = slotItem.count
									end
								end
							end
						end
					end
				end
			end
		end
	end
end


function Inventory_C:deleteSlot(slotID)
	if (slotID) then
		if (self.slots[slotID]) then
			if (self.slots[slotID].item) then
				self.slots[slotID].item:delete()
				self.slots[slotID].item = nil
				self.slots[slotID].count = 0
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
			if (slotItem.item) then
				slotItem.item:delete()
				slotItem.item = nil
				slotItem = nil
			end
		end
	end
end


function Inventory_C:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("Inventory_C for player " .. self.player:getName() .. " was deleted")
	end
end