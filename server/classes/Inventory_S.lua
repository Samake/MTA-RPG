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
			local id = i .. ":" .. j
			
			if (not self.slots[id]) then
				self.slots[id] = {}
			end
		end
	end
end


function Inventory_S:update()

end


function Inventory_S:getSlots()
	return self.slots
end


function Inventory_S:clear()

end


function Inventory_S:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("Inventory_S for player " .. self.player:getName() .. " was deleted.")
	end
end