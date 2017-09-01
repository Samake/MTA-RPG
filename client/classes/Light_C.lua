Light_C = inherit(Class)

function Light_C:constructor(lightProperties)
	
	self.id = lightProperties.id
	self.x = lightProperties.x
	self.y = lightProperties.y
	self.z = lightProperties.z
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Light_C " .. self.id .. " was loaded.")
	end
end


function Light_C:init()

end


function Light_C:update()

end


function Light_C:clear()
	
end


function Light_C:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("Light_C " .. self.id .. " was deleted.")
	end
end