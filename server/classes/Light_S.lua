Light_S = inherit(Class)

function Light_S:constructor(lightProperties)
	
	self.id = lightProperties.id
	self.x = lightProperties.x
	self.y = lightProperties.y
	self.z = lightProperties.z
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Light_S " .. self.id .. " was loaded.")
	end
end


function Light_S:init()
	if (not self.element) then
		self.element = createElement("CUSTOMLIGHT", self.id)
	end	
end


function Light_S:update()
	if (self.element) and (isElement(self.element)) then
		self:updateCoords()
	end
end


function Light_S:updateCoords()
	self.element:setPosition(self.x, self.y, self.z)
end


function Light_S:clear()
	if (self.element) then
		self.element:destroy()
		self.element = nil
	end
end


function Light_S:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("Light_S " .. self.id .. " was deleted.")
	end
end