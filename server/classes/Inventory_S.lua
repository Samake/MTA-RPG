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
	self.m_MoveItem = bind(self.moveItem, self)
	addEvent("MOVEITEM", true)
	addEventHandler("MOVEITEM", root, self.m_MoveItem)
	
	for i = 1, Settings.inventorySize, 1 do
		for j = 1, Settings.inventorySize, 1 do		
			local slotID = i .. ":" .. j
			
			if (not self.slots[slotID]) then
				self.slots[slotID] = nil
			end
		end
	end
end


function Inventory_S:addItem(player, itemContainer)
	if (player) and (itemContainer) then
		if (player == self.player) then
			if (self:addExistingItem(itemContainer) == false) then
				local slotID = self:getFreeSlot()
				local id = self:getRandomID()

				if (slotID) and (id) then
					if (not self.slots[slotID]) then
						itemContainer.player = player
						itemContainer.id = id
						itemContainer.slotID = slotID
						itemContainer.count = 1
						
						self.slots[slotID] = Item_S:new(itemContainer)
					end
				end
			end

			self:syncSlots()
		end
	end
end


function Inventory_S:addExistingItem(itemContainer)
	if (itemContainer) then
		for index, slotItem in pairs(self.slots) do
			if (slotItem) then
				if (slotItem.itemID == itemContainer.itemID) then
					if (itemContainer.stackable == true) then
						if ((slotItem.count + 1) <= Settings.inventoryStackSize) then
							slotItem.count = slotItem.count + 1

							self:syncSlots()
							
							return true
						end
					end
				end
			end
		end
	end
	
	return false
end


function Inventory_S:moveItem(startSlotID, destinationSlotID)
	if (client) and (isElement(client)) then
		if (client == self.player) then
			if (startSlotID) and (destinationSlotID) and (count) then
				if (self.slots[startSlotID]) and (self.slots[destinationSlotID]) then
					
					local startTempItem = self.slots[startSlotID]
					local destinationTempItem = self.slots[destinationSlotID]
					
					self.slots[startSlotID] = destinationTempItem
					
					if (self.slots[startSlotID]) then
						self.slots[startSlotID].slotID = startSlotID
					end

					self.slots[destinationSlotID] = startTempItem
					
					if (self.slots[destinationSlotID]) then
						self.slots[destinationSlotID].slotID = destinationSlotID
					end
					
					self:syncSlots()
				end
			end
		end
	end
end


function Inventory_S:deleteItem(slotID)
	if (slotID) then
		if (self.slots[slotID]) then
			self.slots[slotID]:delete()
			self.slots[slotID] = nil
		end
		
		self:syncSlots()
	end
end


function Inventory_S:syncSlots()
	if (self.player) then
		local slotItems = {}
		
		for index, slotItem in pairs(self.slots) do
			if (slotItem) then
				local itemProperties = {}
				itemProperties.id = slotItem.id
				itemProperties.itemID = slotItem.itemID
				slotItem.slotID = index
				itemProperties.slotID = slotItem.slotID
				itemProperties.id = slotItem.id
				itemProperties.player = slotItem.player
				itemProperties.name = slotItem.name
				itemProperties.description = slotItem.description
				itemProperties.stats = slotItem.stats
				itemProperties.quality = slotItem.quality
				itemProperties.color = slotItem.color
				itemProperties.costs = slotItem.costs
				itemProperties.class = slotItem.class
				itemProperties.icon = slotItem.icon
				itemProperties.stackable = slotItem.stackable
				itemProperties.count = slotItem.count

				table.insert(slotItems, itemProperties)
			end
		end
		
		triggerClientEvent(self.player, "SYNCPLAYERITEMS", self.player, slotItems)
	end
end


function Inventory_S:getFreeSlot()
	for j = 1, Settings.inventorySize, 1 do
		for i = 1, Settings.inventorySize, 1 do
			local slotID = i .. ":" .. j
			
			if (not self.slots[slotID]) then
				return slotID
			end
		end
	end
	
	return nil
end


function Inventory_S:getRandomID()
	local randomID = string.random(15)
	local isFreeID = false
	 
	for index, slotItem in pairs(self.slots) do
		if (slotItem) then
			if (slotItem.id) then
				if (randomID == slotItem.id) then
					isFreeID = true 
				end
			end
		end
	end
	
	if (isFreeID == false) then
		return randomID
	end
	
	return self:getRandomID()
end


function Inventory_S:getSlots()
	return self.slots
end


function Inventory_S:clear()
	removeEventHandler("MOVEITEM", root, self.m_MoveItem)
	
	for index, slotItem in pairs(self.slots) do
		if (slotItem) then
			slotItem:delete()
			slotItem = nil
		end
	end
end


function Inventory_S:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("Inventory_S for player " .. self.player:getName() .. " was deleted.")
	end
end