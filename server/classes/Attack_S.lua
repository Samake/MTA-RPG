Attack_S = inherit(Class)

function Attack_S:constructor(player, slotContent)
	
	self.player = player
	self.settings = slotContent

	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Attack_S was loaded.")
	end
end


function Attack_S:init()

end


function Attack_S:update()

end


function Attack_S:clear()

end


function Attack_S:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("Attack_S was deleted.")
	end
end