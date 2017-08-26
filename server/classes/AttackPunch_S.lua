AttackPunch_S = inherit(Attack_S)

function AttackPunch_S:constructor(player, slotContent)
	
	self.player = player
	self.settings = slotContent
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("AttackPunch_S for player " .. self.player:getName() .. " was loaded.")
	end
end


function AttackPunch_S:init()

end


function AttackPunch_S:update()

end


function AttackPunch_S:clear()

end


function AttackPunch_S:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("AttackPunch_S for player " .. self.player:getName() .. " was deleted.")
	end
end