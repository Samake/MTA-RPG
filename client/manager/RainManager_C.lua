RainManager_C = inherit(Singleton)

function RainManager_C:constructor()

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.rainTextures = {}
	self.maxParticles = 64
	self.currentMaxParticles = 0
	
	self.rainLevel = 0
	self.alpha = 0
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("RainManager_C was loaded.")
	end
end


function RainManager_C:init()
	if (not self.renderTarget) then
		self.renderTarget = dxCreateRenderTarget(self.screenWidth, self.screenHeight, true)
	end
end


function RainManager_C:addParticle(id)
	if (not self.rainTextures[id]) then
		self.rainTextures[id] = RainTexture_C:new(id)
	end
end


function RainManager_C:removeParticle(id)
	if (id) then
		if (self.rainTextures[id]) then
			self.rainTextures[id]:delete()
			self.rainTextures[id] = nil
		end
	end
end


function RainManager_C:update(deltaTime)
	if (self.renderTarget) then
		self.rainLevel = WeatherManager_C:getSingleton():getRainLevel()
		
		self.alpha = 16 + (32 * self.rainLevel)
		self.currentMaxParticles = math.floor(self.maxParticles * self.rainLevel)
		
		dxSetRenderTarget(self.renderTarget, true)
		
		if (self.rainLevel > 0) then
			for i = 1, self.currentMaxParticles do
				if (not self.rainTextures[i]) then
					self:addParticle(i)
				end
			end	
		end
		
		for index, rainTextureClass in pairs(self.rainTextures) do
			if (rainTextureClass) then
				rainTextureClass:update()
			end
		end
		
		dxSetRenderTarget()
	end
end


function RainManager_C:setRainLevel(level)
	if (level) then
		self.rainLevel = (level)%1
	end
end


function RainManager_C:getRainLevel()
	return self.rainLevel
end


function RainManager_C:getRenderTarget()
	return self.renderTarget
end


function RainManager_C:getAlpha()
	return self.alpha
end


function RainManager_C:clear()
	for index, rainTextureClass in pairs(self.rainTextures) do
		if (rainTextureClass) then
			rainTextureClass:delete()
			rainTextureClass = nil
		end
	end
	
	if (self.renderTarget) then
		self.renderTarget:destroy()
		self.renderTarget = nil
	end
end


function RainManager_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("RainManager_C was deleted.")
	end
end