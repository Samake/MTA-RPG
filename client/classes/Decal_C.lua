Decal_C = inherit(Class)

function Decal_C:constructor(decalProperties)
	
	self.id = decalProperties.id
	self.texture = decalProperties.texture
	self.x = decalProperties.x or 0
	self.y = decalProperties.y or 0
	self.z = decalProperties.z or 0
	self.rx = decalProperties.rx or 0
	self.ry = decalProperties.ry or 0
	self.rz = decalProperties.rz or 0
	self.colorR = decalProperties.r or 255
	self.colorG = decalProperties.g or 255
	self.colorB = decalProperties.b or 255
	self.alpha = decalProperties.alpha or 255
	self.scale = decalProperties.scale or 1

	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Decal_C was loaded.")
	end
end


function Decal_C:init()
	if (not self.shader) then
		self.shader = dxCreateShader("res/shader/shader_projected_texture.hlsl", 0, Settings.shaderWorldDrawDistance, true, "world")
		
		if (self.shader) then
			self.shader:applyToWorldTexture("*")
		end
		
		for index, texture in pairs(ShaderBindings["excludes"]) do
			if (texture) then
				self.shader:removeFromWorldTexture(texture)
			end
		end
		
		for index, texture in pairs(ShaderBindings["null"]) do
			if (texture) then
				self.shader:removeFromWorldTexture(texture)
			end
		end
	end
end


function Decal_C:update(deltaTime)
	if (self.alpha > 0) then
		if (self.shader) and (self.texture) then
			--self.alpha = self.alpha - 2.5
			
			if (self.alpha <= 0) then
				self.alpha = 0
			end
			
			self.shader:setValue("textureIn", self.texture)
			self.shader:setValue("colorIn", {self.colorR / 255, self.colorG / 255, self.colorB / 255})
			self.shader:setValue("alpha", self.alpha / 255)
			self.shader:setValue("scale", self.scale)
			self.shader:setValue("texturePosition", {self.x, self.y, self.z})
			self.shader:setValue("textureRotation", {self.rx, self.ry, self.rz})
		end
	end
end


function Decal_C:clear()
	if (self.shader) then
		self.shader:destroy()
		self.shader = nil
	end
end


function Decal_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Decal_C was deleted.")
	end
end