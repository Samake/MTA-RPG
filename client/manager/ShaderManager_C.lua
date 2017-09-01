ShaderManager_C = inherit(Singleton)

function ShaderManager_C:constructor()

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.hour = 12
	self.minute = 0
	
	self.nullShader = nil
	self.colorShadersWorld = {}
	self.colorShadersVehicles = {}
	self.waterShader = nil
	self.pedShaders = nil
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("ShaderManager_C was loaded.")
	end
end


function ShaderManager_C:init()
	self.m_ToggleShaders = bind(self.toggleShaders, self)
	bindKey(Bindings["TOGGLESHADERS"], "down", self.m_ToggleShaders)
	
	self.screenSource = dxCreateScreenSource(self.screenWidth, self.screenHeight)
	
	if (Settings.shadersEnabled == true) then
		self:enableShaders()
	end
end


function ShaderManager_C:toggleShaders()
	Settings.shadersEnabled = not Settings.shadersEnabled
	
	if (Settings.shadersEnabled == false) then
		self:deleteShaders()
	elseif (Settings.shadersEnabled == true) then
		self:enableShaders()
	end
end


function ShaderManager_C:enableShaders()
	self:loadColorShaders()
	self:loadWaterShader()
	self:loadPlayerShaders()
	
	NotificationManager_C:getSingleton():addNotification("#EEEEEE Shaders #44EE44 enabled #EEEEEE!")
end


function ShaderManager_C:deleteShaders()
	self:deleteColorShaders()
	self:deleteWaterShader()
	self:deletePlayerShaders()
	
	NotificationManager_C:getSingleton():addNotification("#EEEEEE Shaders #EE4444 disabled #EEEEEE!")
end


function ShaderManager_C:loadColorShaders()
	
	if (not self.nullShader) then
		self.nullShader = ShaderNull_C:new("null")
	end
	
	for index, shaderBind in pairs(ShaderBindings) do
		if (shaderBind) then
			if (index ~= "excludes") and (index ~= "null") then
				if (not self.colorShadersWorld[index]) then
					self.colorShadersWorld[index] = ShaderColorWorld_C:new(index, shaderBind)
				end
				
				if (not self.colorShadersVehicles[index]) then
					self.colorShadersVehicles[index] = ShaderColorVehicles_C:new(index, shaderBind)
				end
			end
		end
	end
end


function ShaderManager_C:deleteColorShaders()
	for index, shaderClass in pairs(self.colorShadersWorld) do
		if (shaderClass) then
			shaderClass:delete()
			shaderClass = nil
		end
		
		self.colorShadersWorld = {}
	end
	
	for index, shaderClass in pairs(self.colorShadersVehicles) do
		if (shaderClass) then
			shaderClass:delete()
			shaderClass = nil
		end
		
		self.colorShadersVehicles = {}
	end
	
	if (self.nullShader) then
		self.nullShader:delete()
		self.nullShader = nil
	end
end


function ShaderManager_C:loadWaterShader()
	if (not self.waterShader) then
		self.waterShader = ShaderWater_C:new("water")
	end
end


function ShaderManager_C:deleteWaterShader()
	if (self.waterShader) then
		self.waterShader:delete()
		self.waterShader = nil
	end
end


function ShaderManager_C:loadPlayerShaders()
	if (not self.pedShaders) then
		self.pedShaders = ShaderPeds_C:new()
	end
end


function ShaderManager_C:deletePlayerShaders()
	if (self.pedShaders) then
		self.pedShaders:delete()
		self.pedShaders = nil
	end
end


function ShaderManager_C:update(deltaTime)
	if (Settings.shadersEnabled == true) then
		self.hour, self.minute = getTime()
		
		if (self.screenSource) then
			self.screenSource:update()
		end
		
		for index, shaderClass in pairs(self.colorShadersWorld) do
			if (shaderClass) then
				shaderClass:update(deltaTime)
			end
		end
		
		if (self.waterShader) then
			self.waterShader:update(deltaTime)
		end
	end
end


function ShaderManager_C:getScreenSource()
	if (self.screenSource) then
		return self.screenSource
	end
	
	return nil
end


function ShaderManager_C:clear()
	self:deleteShaders()
	
	unbindKey(Bindings["TOGGLESHADERS"], "down", self.m_ToggleShaders)
	
	if (self.screenSource) then
		self.screenSource:destroy()
		self.screenSource = nil
	end
end


function ShaderManager_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("ShaderManager_C was deleted.")
	end
end