Marker3D_C = inherit(Singleton)

function Marker3D_C:constructor()
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.x = 0
	self.y = 0
	self.z = 0
	self.rx = 0
	self.ry = 0
	self.rz = 0
	
	self.colorR = 255
	self.colorG = 255
	self.colorB = 255
	
	self.alpha = 0
	self.scale = 0
	self.maxScale = 2

	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("Marker3D_C was loaded.")
	end
end


function Marker3D_C:init()
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


function Marker3D_C:update(deltaTime)
	if (self.alpha > 0) then
		if (self.shader) and (self.colorR) and (self.colorG) and (self.colorB) and (self.alpha) and (Textures["GUI"]["Cursor"][2].texture) and (self.scale) then
			
			self.rz = (self.rz + 0.05)%360
			
			self.scale = self.scale + 0.1
			
			if (self.scale >= self.maxScale) then
				self.scale = self.maxScale
			end
			
			self.alpha = self.alpha - 2.5
			
			if (self.alpha <= 0) then
				self.alpha = 0
			end
			
			self.shader:setValue("textureIn", Textures["GUI"]["Cursor"][2].texture)
			self.shader:setValue("colorIn", {self.colorR / 255, self.colorG / 255, self.colorB / 255})
			self.shader:setValue("alpha", self.alpha / 255)
			self.shader:setValue("scale", self.scale)
			self.shader:setValue("texturePosition", {self.x, self.y, self.z})
			self.shader:setValue("textureRotation", {self.rx, self.ry, self.rz})
		end
	end
end

function Marker3D_C:reset()
	self.alpha = Settings.guiAlpha
	self.scale = 0
end


function Marker3D_C:setPosition(x, y, z)
	if (x) and (y) and (z) then
		self.x = x
		self.y = y
		self.z = z
		
		self:reset()
	end
end


function Marker3D_C:getPosition()
	return self.x, self.y, self.z
end


function Marker3D_C:setRotation(x, y, z)
	if (x) and (y) and (z) then
		self.rx = x
		self.ry = y
		self.rz = z
	end
end


function Marker3D_C:getRotation()
	return self.rx, self.ry, self.rz
end


function Marker3D_C:setColor(r, g, b)
	if (b) and (g) and (b) then
		self.colorR = r
		self.colorG = g
		self.colorB = b
	end
end


function Marker3D_C:getColor()
	return self.colorR, self.colorG, self.colorB
end


function Marker3D_C:clear()
	if (self.shader) then
		self.shader:destroy()
		self.shader = nil
	end
end


function Marker3D_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("Marker3D_C was deleted.")
	end
end