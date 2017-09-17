Quest_C = inherit(Class)

function Quest_C:constructor(questProperties)
	
	self.id = questProperties.id
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Quest_C " .. self.id .. " was loaded.")
	end
end


function Quest_C:init()

end


function Quest_C:update()

end


function Quest_C:clear()

end


function Quest_C:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("Quest_C " .. self.id .. " was deleted.")
	end
end