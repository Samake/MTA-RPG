Inventory_S = inherit(Class)

function Inventory_S:constructor(player)
	
	self.player = player
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Inventory_S for player " .. self.player:getName() .. " was loaded.")
	end
end


function Inventory_S:init()
	
end



function Inventory_S:update()

end


function Inventory_S:clear()

end


function Inventory_S:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("Inventory_S for player " .. self.player:getName() .. " was deleted.")
	end
end