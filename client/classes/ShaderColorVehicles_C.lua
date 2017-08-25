ShaderColorVehicles_C = inherit(Class)

function ShaderColorVehicles_C:constructor(id, shaderBind)

	self.id = id
	self.textures = shaderBind.textures
	self.color = {shaderBind.color.r / 255, shaderBind.color.g / 255, shaderBind.color.b / 255}
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("ShaderColorVehicles_C " .. self.id .. " was loaded.")
	end
end


function ShaderColorVehicles_C:init()
	if (not self.shader) then
		self.shader = dxCreateShader("res/shader/shader_color_vehicle.hlsl", 0, Settings.shaderWorldDrawDistance, false, "vehicle")
		
		if (self.shader) then
			for index, texture in pairs(self.textures) do
				if (texture) then
					self.shader:applyToWorldTexture(texture)
				end
			end
			
			self.shader:setValue("inColor", self.color)
			
			if (Textures["Effects"]["Shader"][1]) then
				if (Textures["Effects"]["Shader"][1].texture) then
					self.shader:setValue("normalTexture", Textures["Effects"]["Shader"][1].texture)
				end
			end
			
			for index, texture in pairs(ShaderBindings["excludes"]) do
				if (texture) then
					self.shader:removeFromWorldTexture(texture)
				end
			end
		else
			sendMessage("ERROR || ShaderColorVehicles_C " .. self.id .. " was not loaded!")
		end
	end
end


function ShaderColorVehicles_C:clear()
	if (self.shader) then
		self.shader:destroy()
		self.shader = nil
	end
end


function ShaderColorVehicles_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("ShaderColorVehicles_C " .. self.id .. " was deleted.")
	end
end