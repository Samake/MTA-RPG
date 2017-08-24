ShaderWater_C = inherit(Class)

function ShaderWater_C:constructor(id)

	self.id = id
	self.causticTextures = Textures["World"]["Water"]
	self.waterColor = {r = 15, g = 110, b = 175}
	self.alpha = 180
	
	self.causticTextureID = 1
	self.causticSpeed = 0.5
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("ShaderWater_C " .. self.id .. " was loaded.")
	end
end


function ShaderWater_C:init()
	if (not self.shader) then
		self.shader = dxCreateShader("res/shader/shader_water.hlsl", 0, Settings.shaderWorldDrawDistance, false, "world")
		
		if (self.shader) then
			self.shader:applyToWorldTexture("waterclear256")
			self.shader:setValue("waterColor", {self.waterColor.r / 255, self.waterColor.g / 255, self.waterColor.b / 255})
			self.shader:setValue("alpha", self.alpha / 255)
		else
			sendMessage("ERROR || ShaderWater_C " .. self.id .. " was not loaded!")
		end
	end
end


function ShaderWater_C:update(deltaTime)
	if (self.shader) and (self.causticTextures) then
		
		self.causticTextureID = (self.causticTextureID + self.causticSpeed)%#self.causticTextures
		
		if (self.causticTextures[self.causticTextureID]) then
			if (self.causticTextures[self.causticTextureID].texture) then
				self.shader:setValue("caustics", self.causticTextures[self.causticTextureID].texture)
			end
		end
	end
end


function ShaderWater_C:clear()
	if (self.shader) then
		self.shader:destroy()
		self.shader = nil
	end
end


function ShaderWater_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("ShaderWater_C " .. self.id .. " was deleted.")
	end
end