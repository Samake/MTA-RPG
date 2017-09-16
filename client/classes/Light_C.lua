Light_C = inherit(Class)

function Light_C:constructor(lightProperties)
	
	self.id = lightProperties.id
	self.x = lightProperties.x
	self.y = lightProperties.y
	self.z = lightProperties.z
	self.radius = lightProperties.radius
	self.color = lightProperties.color
	self.isFlickering = lightProperties.isFlickering
	self.isPulsating = lightProperties.isPulsating
	
	self.flickerValue = 0
	self.pulsatingValue = 1
	
	self.currentColor = {r = 0, g = 0, b = 0}
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Light_C " .. self.id .. " was loaded.")
	end
end


function Light_C:init()

end


function Light_C:update()
	if (self.isFlickering == true) then
		self.flickerValue = math.random(800, 1000) / 1000
		self.currentColor = {r = self.color.r * self.flickerValue, g = self.color.g * self.flickerValue, b = self.color.b * self.flickerValue}
	elseif (self.isPulsating == true) then
		self.pulsatingValue = (self.pulsatingValue - 0.025)%1
		self.currentColor = {r = self.color.r * self.pulsatingValue, g = self.color.g * self.pulsatingValue, b = self.color.b * self.pulsatingValue}
	else
		self.currentColor = self.color
	end
end


function Light_C:clear()

end


function Light_C:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("Light_C " .. self.id .. " was deleted.")
	end
end