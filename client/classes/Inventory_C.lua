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
	for i = 1, Settings.inventorySize, 1 do
		for j = 1, Settings.inventorySize, 1 do
			local id = i .. ":" .. j
			
			if (not self.slots[id]) then
				self.slots[id] = {}
			end
		end
	end
end


function Inventory_C:update()

end


function Inventory_C:getSlots()
	return self.slots
end


function Inventory_C:clear()

end


function Inventory_C:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("Inventory_C for player " .. self.player:getName() .. " was deleted")
	end
end