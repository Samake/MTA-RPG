Decal_C = inherit(Class)

function Decal_C:constructor(decalProperties)
	
	self.id = decalProperties.id
	self.textureID = decalProperties.textureID
	self.texture = nil
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
	self.lifetime = decalProperties.lifetime or 1000
	
	self.isAnimated = false
	
	local textureContainer = Textures[self.textureID[1]][self.textureID[2]][self.textureID[3]]
	
	if (textureContainer)  and (not self.texture) then
		if (textureContainer.size) and (textureContainer.size) and (textureContainer.size) then
			self.isAnimated = true
			
			local textureProperties = {}
			textureProperties.id = self.id
			textureProperties.texture = textureContainer.texture
			textureProperties.size = textureContainer.size
			textureProperties.columns = textureContainer.columns
			textureProperties.rows = textureContainer.rows
			textureProperties.looped = true
			
			self.texture = AnimatedTexture_C:new(textureProperties)
		else
			self.texture = textureContainer.texture
		end
	end
	
	self.z = getGroundPosition(self.x, self.y, self.z)

	self.startTick = 0
	self.currentTick = 0
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Decal_C " .. self.id .. " was loaded.")
	end
end


function Decal_C:init()
	if (not self.shader) then
		self.shader = dxCreateShader("res/shader/shader_projected_texture.hlsl", 0, Settings.shaderWorldDrawDistance, true, "world,object")
		
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
	
	self.startTick = getTickCount()
end


function Decal_C:update(deltaTime)
	self.currentTick = getTickCount()
	
	if (self.currentTick > self.startTick + self.lifetime) then
		DecalManager_C:getSingleton():deleteDecal(self.id)
	else	
		if (self.shader) and (self.texture) then
			local finalTexture = nil
			
			if (self.isAnimated == true) then
				self.texture:update()
				finalTexture = self.texture:getTexture()
			else
				finalTexture = self.texture
			end
			
			if (finalTexture) then
				self.shader:setValue("textureIn", finalTexture)
			end
			
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
	
	if (self.isAnimated == true) then
		if (self.texture) then
			self.texture:delete()
			self.texture = nil
		end
	end
end


function Decal_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Decal_C " .. self.id .. " was deleted.")
	end
end