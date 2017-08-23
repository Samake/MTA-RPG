ShaderNull_C = inherit(Class)

function ShaderNull_C:constructor(id)

	self.id = id

	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("ShaderNull_C " .. self.id .. " was loaded.")
	end
end


function ShaderNull_C:init()
	if (not self.shader) then
		self.shader = dxCreateShader("res/shader/shader_null.hlsl", 0, Settings.shaderWorldDrawDistance, false, "world,vehicle,object")
		
		if (self.shader) then
			for index, texture in pairs(ShaderBindings["null"]) do
				if (texture) then
					self.shader:applyToWorldTexture(texture)
				end
			end
		else
			sendMessage("ERROR || ShaderNull_C " .. self.id .. " was not loaded!")
		end
	end
end


function ShaderNull_C:update(deltaTime)
	if (self.shader) then
		
	end
end


function ShaderNull_C:clear()
	if (self.shader) then
		self.shader:destroy()
		self.shader = nil
	end
end


function ShaderNull_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("ShaderNull_C " .. self.id .. " was deleted.")
	end
end