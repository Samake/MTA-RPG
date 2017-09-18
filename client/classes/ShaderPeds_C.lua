ShaderPeds_C = inherit(Class)

function ShaderPeds_C:constructor()

	self.headShaders = {}
	self.bodyShader = nil
	
	self.shadowModifier = 0.0
	
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
	
	if (not self.bodyShader) then
		self.bodyShader = dxCreateShader("res/shader/shader_color_peds.hlsl", 0, Settings.shaderWorldDrawDistance, false, "ped")
		
		if (self.bodyShader) then
			self.bodyShader:applyToWorldTexture("*")
			self.bodyShader:removeFromWorldTexture("cj_ped_head")
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
	end
end


function ShaderPeds_C:applyNPCShaders(npcSkin)
	if (npcSkin) then
		if (self.headShaders[npcSkin.head]) then
			self.headShaders[npcSkin.head]:applyToWorldTexture("cj_ped_head", npcSkin.model, false)
		end
	end
end


function ShaderPeds_C:update()
	self.shadowModifier = Renderer_C:getSingleton():getShadowModifier() or 0.0
	
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
					headShader:setValue("shadowModifier", self.shadowModifier)
				end
			end
			
			if (self.bodyShader) and (isElement(self.bodyShader)) then
				self.bodyShader:setValue(lightEnableStr, true)
				self.bodyShader:setValue(lightPositionStr, {light.x, light.y, light.z})
				self.bodyShader:setValue(lightDiffuseStr, {(light.currentColor.r) / 255, (light.currentColor.g) / 255, (light.currentColor.b) / 255, 1.0})
				self.bodyShader:setValue(lightAttenuationStr, light.radius)
				self.bodyShader:setValue("shadowModifier", self.shadowModifier)
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
	
	if (self.bodyShader) then
		self.bodyShader:destroy()
		self.bodyShader = nil
	end
end


function ShaderPeds_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("ShaderPeds_C was deleted.")
	end
end