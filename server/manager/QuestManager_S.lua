QuestManager_S = inherit(Singleton)

function QuestManager_S:constructor()

	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("QuestManager_S was loaded.")
	end
end


function QuestManager_S:init()

end


function QuestManager_S:clear()

end


function QuestManager_S:destructor()
	self:clear()

	if (Settings.showManagerDebugInfo == true) then
		sendMessage("QuestManager_S was deleted.")
	end
end