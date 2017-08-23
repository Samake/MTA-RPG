ShaderPlayers_C = inherit(Class)

function ShaderPlayers_C:constructor()

	self.headShaders = {}
	self.torsoShaders = {}
	self.legShaders = {}
	self.feetShaders = {}
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("ShaderPlayers_C was loaded.")
	end
end


function ShaderPlayers_C:init()
	self.m_ReceivePlayerSkins = bind(self.receivePlayerSkins, self)
	addEvent("SENDPLAYERSKINS", true)
	addEventHandler("SENDPLAYERSKINS", root, self.m_ReceivePlayerSkins)
	
	triggerServerEvent("REQUESTPLAYERSKINS", root)
	
	for index, skin in pairs(Textures["Skins"]["Head"]) do
		if (skin) then
			if (not self.headShaders[index]) and (skin.texture) then
				self.headShaders[index] = dxCreateShader("res/shader/shader_texReplace.hlsl", 0, Settings.shaderWorldDrawDistance, false, "ped")
				
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
				self.torsoShaders[index] = dxCreateShader("res/shader/shader_texReplace.hlsl", 0, Settings.shaderWorldDrawDistance, false, "ped")
				
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
				self.legShaders[index] = dxCreateShader("res/shader/shader_texReplace.hlsl", 0, Settings.shaderWorldDrawDistance, false, "ped")
				
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
				self.feetShaders[index] = dxCreateShader("res/shader/shader_texReplace.hlsl", 0, Settings.shaderWorldDrawDistance, false, "ped")
				
				if (self.feetShaders[index]) then
					self.feetShaders[index]:setValue("skinTexture", skin.texture)
				else
					sendMessage("ERROR || Shader feet " .. index .. " was not loaded!")
				end
			end
		end
	end
end


function ShaderPlayers_C:receivePlayerSkins(playerSkins)
	if (playerSkins) then
		for index, playerSkin in pairs(playerSkins) do
			if (playerSkin) then
				self:applyShaders(playerSkin)
			end
		end
	end
end


function ShaderPlayers_C:applyShaders(playerSkin)
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


function ShaderPlayers_C:clear()
	removeEventHandler("SENDPLAYERSKINS", root, self.m_ReceivePlayerSkins)
	
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


function ShaderPlayers_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("ShaderPlayers_C was deleted.")
	end
end