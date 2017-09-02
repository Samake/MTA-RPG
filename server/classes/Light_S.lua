Light_S = inherit(Class)

function Light_S:constructor(lightProperties)
	
	self.id = lightProperties.id
	self.x = lightProperties.x
	self.y = lightProperties.y
	self.z = lightProperties.z
	self.radius = lightProperties.radius
	self.color = lightProperties.color
	self.isFlickering = lightProperties.isFlickering
	self.isPulsating = lightProperties.isPulsating
	
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
		self:updateData()
	end
end


function Light_S:updateCoords()
	self.element:setPosition(self.x, self.y, self.z)
end


function Light_S:updateData()
	self.element:setData("LIGHTCOLORR", self.color.r, true)
	self.element:setData("LIGHTCOLORG", self.color.g, true)
	self.element:setData("LIGHTCOLORB", self.color.b, true)
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