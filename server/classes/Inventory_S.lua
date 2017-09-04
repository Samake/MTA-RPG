Inventory_S = inherit(Class)

function Inventory_S:constructor(player)
	
	self.player = player
	self.slots = {}
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Inventory_S for player " .. self.player:getName() .. " was loaded.")
	end
end


function Inventory_S:init()
	for i = 1, Settings.inventorySize, 1 do
		for j = 1, Settings.inventorySize, 1 do
			if (not self.slots[id]) then
				self.slots[i .. ":" .. j] = {}
				self.slots[i .. ":" .. j].item = nil
				self.slots[i .. ":" .. j].count = 0
			end
		end
	end
end


function Inventory_S:addItem(player, itemContainer)
	if (player) and (itemContainer) then
		if (player == self.player) then
			for i = 1, Settings.inventorySize, 1 do
				for j = 1, Settings.inventorySize, 1 do
					if (self.slots[i .. ":" .. j]) then
						itemContainer.player = player
						
						if (not self.slots[i .. ":" .. j].item) then
							self.slots[i .. ":" .. j].item = Item_S:new(itemContainer)

							if (self.slots[i .. ":" .. j].item) then
								self.slots[i .. ":" .. j].count = 1
								break
							end
						else
							if (self.slots[i .. ":" .. j].item.id == itemContainer.id) then
								if (itemContainer.stackable == true) then
									if ((self.slots[i .. ":" .. j].count + 1) < Settings.inventoryStackSize) then
										self.slots[i .. ":" .. j].count = self.slots[i .. ":" .. j].count + 1
										break
									end
								end
							end
						end
					end
				end
			end
			
			self:syncSlots()
		end
	end
end


function Inventory_S:deleteItem(slotID)
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


function Inventory_S:syncSlots()
	if (self.player) then
		local slotItems = {}
		
		for index, slotItem in pairs(self.slots) do
			if (slotItem) then
				if (slotItem.item) and (slotItem.count) then
					local itemProperties = {}
					itemProperties.slotID = index
					itemProperties.id = slotItem.item.id
					itemProperties.player = slotItem.item.player
					itemProperties.name = slotItem.item.name
					itemProperties.description = slotItem.item.id
					itemProperties.stats = slotItem.item.stats
					itemProperties.quality = slotItem.item.quality
					itemProperties.color = slotItem.item.color
					itemProperties.costs = slotItem.item.costs
					itemProperties.class = slotItem.item.class
					itemProperties.icon = slotItem.item.icon
					itemProperties.stackable = slotItem.item.stackable
					itemProperties.count = slotItem.count

					table.insert(slotItems, itemProperties)
				end
			end
		end
		
		triggerClientEvent(self.player, "SYNCPLAYERITEMS", self.player, slotItems)
	end
end


function Inventory_S:getSlots()
	return self.slots
end


function Inventory_S:clear()
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


function Inventory_S:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("Inventory_S for player " .. self.player:getName() .. " was deleted.")
	end
end