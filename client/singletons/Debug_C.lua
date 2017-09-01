Debug_C = inherit(Singleton)

function Debug_C:constructor()
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.player = getLocalPlayer()
	self.playerPos = nil
	self.playerRot = nil
	
	self.maxDistance = 150
	self.minScale = 0.3
	self.maxScale = 8.0
	self.minAlpha = 32
	self.maxAlpha = Settings.guiAlpha
	
	self.size = self.screenWidth * 0.025
	
	self.shadowOffset = 1
	
	self.postGUI = true
	self.subPixelPositioning = true
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("Debug_C was loaded.")
	end
end


function Debug_C:init()
	self.m_SpawnTestNPC = bind(self.spawnTestNPC, self)
	bindKey(Bindings["SPAWNTESTNPC"], "down", self.m_SpawnTestNPC)
	
	self.m_SpawnTestLight = bind(self.spawnTestLight, self)
	bindKey(Bindings["SPAWNTESTLIGHT"], "down", self.m_SpawnTestLight)
	
	NotificationManager_C:getSingleton():addNotification("#EEEEEE Debug mode #44EE44 enabled #EEEEEE!")
end


function Debug_C:spawnTestNPC()
	if (self.player) and (isElement(self.player)) then
		if (self.playerPos) and (self.playerRot) then
			local x, y, z = getAttachedPosition(self.playerPos.x, self.playerPos.y, self.playerPos.z, self.playerRot.x, self.playerRot.y, self.playerRot.z, 15, 0, 0.3)
			
			triggerServerEvent("ADDTESTNPC", root, x, y, z)
		end
	end
end


function Debug_C:spawnTestLight()
	if (self.player) and (isElement(self.player)) then
		if (self.playerPos) and (self.playerRot) then
			local lightProperties = {}
			lightProperties.x = self.playerPos.x
			lightProperties.y = self.playerPos.y
			lightProperties.z = self.playerPos.z + 1.5
			
			triggerServerEvent("ADDLIGHT", root, lightProperties)
		end
	end
end


function Debug_C:update(deltaTime)
	if (self.player) and (isElement(self.player)) then
		self.playerPos = self.player:getPosition()
		self.playerRot = self.player:getRotation()
		
		self:drawLights()
	end
end


function Debug_C:drawLights()
	if (Textures["Icons"]["Debug"][2]) then
		for index, light in pairs(getElementsByType("CUSTOMLIGHT")) do
			if (light) and (isElement(light)) then
				local cx, cy, cz = getCameraMatrix()
				local lightPos = light:getPosition()
				local distance = getDistanceBetweenPoints3D(cx, cy, cz, lightPos.x, lightPos.y, lightPos.z)
				
				if (distance <= self.maxDistance) then
					local ntx, nty = getScreenFromWorldPosition(lightPos.x, lightPos.y, lightPos.z + 1.5)
					local scale = self:getScale(distance)
					local alpha = self:getAlpha(distance)
					local shadowOffset = 1 * scale

					if (ntx) and (nty) and (isLineOfSightClear(cx, cy, cz, lightPos.x, lightPos.y, lightPos.z + 1, true, true, false)) then
						if (not isLineOfSightClear(cx, cy, cz, lightPos.x, lightPos.y, lightPos.z + 1, true, true, true)) then
							alpha = alpha * 0.4
						end
						
						local width = self.size * scale
						local height = self.size * scale

						-- // name // --
						local x = ntx
						local y = nty + height
						
						dxDrawImage((x - width / 2) + self.shadowOffset, (y - height / 2) + self.shadowOffset, width, height, Textures["Icons"]["Debug"][2].texture, 0, 0, 0, tocolor(0, 0, 0, alpha), self.postGUI)
						dxDrawImage((x - width / 2), (y - height / 2), width, height, Textures["Icons"]["Debug"][2].texture, 0, 0, 0, tocolor(255, 255, 255, alpha), self.postGUI)
					end
				end
			end
		end
	end
end


function Debug_C:getScale(distanceValue)
    local scaleVar = (self.maxDistance * self.minScale) / (distanceValue * self.maxScale)
    
    if (scaleVar <= self.minScale) then
        scaleVar = self.minScale
    elseif (scaleVar >= self.maxScale) then
        scaleVar = self.maxScale 
    end
	
    return scaleVar
end


function Debug_C:getAlpha(distanceValue)
	local alphaVar = self.maxAlpha - ((self.maxAlpha / self.maxDistance) * distanceValue)
    
    if (alphaVar <= self.minAlpha) then
        alphaVar = self.minAlpha
    elseif (alphaVar >= self.maxAlpha) then
        alphaVar = self.maxAlpha 
    end

    return alphaVar
end


function Debug_C:clear()
	unbindKey(Bindings["SPAWNTESTNPC"], "down", self.m_SpawnTestNPC)
	unbindKey(Bindings["SPAWNTESTLIGHT"], "down", self.m_SpawnTestLight)
	
	NotificationManager_C:getSingleton():addNotification("#EEEEEE Debug mode #EE4444 disabled #EEEEEE!")
end


function Debug_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("Debug_C was deleted.")
	end
end