Inventory_C = inherit(Class)

function Inventory_C:constructor(player)
	
	self.player = player
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Inventory_C for player " .. self.player:getName() .. " was loaded.")
	end
end


function Inventory_C:init()
	
end



function Inventory_C:update()

end


function Inventory_C:clear()

end


function Inventory_C:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("Inventory_C for player " .. self.player:getName() .. " was deleted")
	end
end