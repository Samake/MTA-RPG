ShaderPeds_C = inherit(Class)

function ShaderPeds_C:constructor()

	self.headShaders = {}
	self.torsoShaders = {}
	self.legShaders = {}
	self.feetShaders = {}
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("ShaderPeds_C was loaded.")
	end
end


function ShaderPeds_C:init()
	self.m_ReceivePlayerSkins = bind(self.receivePlayerSkins, self)
	addEvent("SENDPLAYERSKINS", true)
	addEventHandler("SENDPLAYERSKINS", root, self.m_ReceivePlayerSkins)
	
	self.m_ReceiveNPCSkins = bind(self.receiveNPCSkins, self)
	addEvent("SENDNPCSKINS", true)
	addEventHandler("SENDNPCSKINS", root, self.m_ReceiveNPCSkins)
	
	
	for index, skin in pairs(Textures["Skins"]["Head"]) do
		if (skin) then
			if (not self.headShaders[index]) and (skin.texture) then
				self.headShaders[index] = dxCreateShader("res/shader/shader_color_peds.hlsl", 0, Settings.shaderWorldDrawDistance, false, "ped")
				
				if (self.headShaders[index]) then
					self.headShaders[index]:setValue("skinTexture", skin.texture)
				else
					sendMessage("ERROR || Shader head " .. index .. " was not loaded!")
				end
			end
		end
	end
	
	for index, skin in pairs(Textures["Skins"]["Torso"]) do
		if (skin) then
			if (not self.torsoShaders[index]) and (skin.texture) then
				self.torsoShaders[index] = dxCreateShader("res/shader/shader_color_peds.hlsl", 0, Settings.shaderWorldDrawDistance, false, "ped")
				
				if (self.torsoShaders[index]) then
					self.torsoShaders[index]:setValue("skinTexture", skin.texture)
				else
					sendMessage("ERROR || Shader torso " .. index .. " was not loaded!")
				end
			end
		end
	end
	
	for index, skin in pairs(Textures["Skins"]["Leg"]) do
		if (skin) then
			if (not self.legShaders[index]) and (skin.texture) then
				self.legShaders[index] = dxCreateShader("res/shader/shader_color_peds.hlsl", 0, Settings.shaderWorldDrawDistance, false, "ped")
				
				if (self.legShaders[index]) then
					self.legShaders[index]:setValue("skinTexture", skin.texture)
				else
					sendMessage("ERROR || Shader leg " .. index .. " was not loaded!")
				end
			end
		end
	end
	
	for index, skin in pairs(Textures["Skins"]["Feet"]) do
		if (skin) then
			if (not self.feetShaders[index]) and (skin.texture) then
				self.feetShaders[index] = dxCreateShader("res/shader/shader_color_peds.hlsl", 0, Settings.shaderWorldDrawDistance, false, "ped")
				
				if (self.feetShaders[index]) then
					self.feetShaders[index]:setValue("skinTexture", skin.texture)
				else
					sendMessage("ERROR || Shader feet " .. index .. " was not loaded!")
				end
			end
		end
	end
	
	triggerServerEvent("REQUESTPLAYERSKINS", root)
	triggerServerEvent("REQUESTNPCSKINS", root)
end


function ShaderPeds_C:receivePlayerSkins(playerSkins)
	if (playerSkins) then
		for index, playerSkin in pairs(playerSkins) do
			if (playerSkin) then
				self:applyPlayerShaders(playerSkin)
			end
		end
	end
end


function ShaderPeds_C:receiveNPCSkins(npcSkins)
	if (npcSkins) then
		for index, npcSkin in pairs(npcSkins) do
			if (npcSkin) then
				self:applyNPCShaders(npcSkin)
			end
		end
	end
end


function ShaderPeds_C:applyPlayerShaders(playerSkin)
	if (playerSkin) then
		if (self.headShaders[playerSkin.head]) then
			self.headShaders[playerSkin.head]:applyToWorldTexture("cj_ped_head", playerSkin.player, false)
		end
		
		if (self.torsoShaders[playerSkin.torso]) then
			self.torsoShaders[playerSkin.torso]:applyToWorldTexture("cj_ped_torso", playerSkin.player, false)
		end
		
		if (self.legShaders[playerSkin.leg]) then
			self.legShaders[playerSkin.leg]:applyToWorldTexture("cj_ped_legs", playerSkin.player, false)
		end
		
		if (self.feetShaders[playerSkin.feet]) then
			self.feetShaders[playerSkin.feet]:applyToWorldTexture("cj_ped_feet", playerSkin.player, false)
		end
	end
end


function ShaderPeds_C:applyNPCShaders(npcSkin)
	if (npcSkin) then
		if (self.headShaders[npcSkin.head]) then
			self.headShaders[npcSkin.head]:applyToWorldTexture("cj_ped_head", npcSkin.model, false)
		end
		
		if (self.torsoShaders[npcSkin.torso]) then
			self.torsoShaders[npcSkin.torso]:applyToWorldTexture("cj_ped_torso", npcSkin.model, false)
		end
		
		if (self.legShaders[npcSkin.leg]) then
			self.legShaders[npcSkin.leg]:applyToWorldTexture("cj_ped_legs", npcSkin.model, false)
		end
		
		if (self.feetShaders[npcSkin.feet]) then
			self.feetShaders[npcSkin.feet]:applyToWorldTexture("cj_ped_feet", npcSkin.model, false)
		end
	end
end


function ShaderPeds_C:update()
	for index, light in pairs(LightManager_C:getSingleton():getLights()) do
		if (light) then
			local lightEnableStr = "pointLight" .. index .. "Enable"
			local lightDiffuseStr = "pointLight" .. index .. "Diffuse"
			local lightAttenuationStr = "pointLight" .. index .. "Attenuation"				
			local lightPositionStr = "pointLight" .. index .. "Position"
			
			for index, headShader in pairs(self.headShaders) do
				if (headShader) and (isElement(headShader)) then
					headShader:setValue(lightEnableStr, true)
					headShader:setValue(lightPositionStr, {light.x, light.y, light.z})
					headShader:setValue(lightDiffuseStr, {(light.currentColor.r) / 255, (light.currentColor.g) / 255, (light.currentColor.b) / 255, 1.0})
					headShader:setValue(lightAttenuationStr, light.radius)
				end
			end
			
			for index, torsoShader in pairs(self.torsoShaders) do
				if (torsoShader) and (isElement(torsoShader)) then
					torsoShader:setValue(lightEnableStr, true)
					torsoShader:setValue(lightPositionStr, {light.x, light.y, light.z})
					torsoShader:setValue(lightDiffuseStr, {(light.currentColor.r) / 255, (light.currentColor.g) / 255, (light.currentColor.b) / 255, 1.0})
					torsoShader:setValue(lightAttenuationStr, light.radius)
				end
			end

			for index, legShader in pairs(self.legShaders) do
				if (legShader) and (isElement(legShader)) then
					legShader:setValue(lightEnableStr, true)
					legShader:setValue(lightPositionStr, {light.x, light.y, light.z})
					legShader:setValue(lightDiffuseStr, {(light.currentColor.r) / 255, (light.currentColor.g) / 255, (light.currentColor.b) / 255, 1.0})
					legShader:setValue(lightAttenuationStr, light.radius)
				end
			end

			for index, feetShader in pairs(self.feetShaders) do
				if (feetShader) and (isElement(feetShader)) then
					feetShader:setValue(lightEnableStr, true)
					feetShader:setValue(lightPositionStr, {light.x, light.y, light.z})
					feetShader:setValue(lightDiffuseStr, {(light.currentColor.r) / 255, (light.currentColor.g) / 255, (light.currentColor.b) / 255, 1.0})
					feetShader:setValue(lightAttenuationStr, light.radius)
				end
			end
		end
	end
end


function ShaderPeds_C:clear()
	removeEventHandler("SENDPLAYERSKINS", root, self.m_ReceivePlayerSkins)
	removeEventHandler("SENDNPCSKINS", root, self.m_ReceiveNPCSkins)
	
	for index, shader in pairs(self.headShaders) do
		if (shader) then
			shader:destroy()
			shader = nil
		end
	end
	
	self.headShaders = {}
	
	for index, shader in pairs(self.torsoShaders) do
		if (shader) then
			shader:destroy()
			shader = nil
		end
	end
	
	self.torsoShaders = {}
	
	for index, shader in pairs(self.legShaders) do
		if (shader) then
			shader:destroy()
			shader = nil
		end
	end
	
	self.legShaders = {}
	
	for index, shader in pairs(self.feetShaders) do
		if (shader) then
			shader:destroy()
			shader = nil
		end
	end
	
	self.feetShaders = {}
end


function ShaderPeds_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("ShaderPeds_C was deleted.")
	end
end