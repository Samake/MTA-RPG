LootManager_S = inherit(Singleton)

function LootManager_S:constructor()

	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("LootManager_S was loaded.")
	end
end


function LootManager_S:init()

end


function LootManager_S:update()

end


function LootManager_S:clear()

end


function LootManager_S:destructor()
	self:clear()

	if (Settings.showManagerDebugInfo == true) then
		sendMessage("LootManager_S was deleted.")
	end
end