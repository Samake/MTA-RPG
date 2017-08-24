ClickSystem_C = inherit(Singleton)

function ClickSystem_C:constructor()
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.player = getLocalPlayer()
	
	self.x = 0
	self.y = 0
	self.worldX = 0
	self.worldY = 0
	self.worldZ = 0
	
	self.alpha = 0
	
	self.markerColor = {r = 45, g = 125, b = 45}
	self.markerColorOK = {r = 45, g = 125, b = 45}
	self.markerColorFailed = {r = 155, g = 35, b = 35}
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("ClickSystem_C was loaded.")
	end
end


function ClickSystem_C:init()
	showCursor(true, false)
	
	self.m_onClientClick = bind(self.onClientClick, self)
	addEventHandler("onClientClick", root, self.m_onClientClick)
end


function ClickSystem_C:update(deltaTime)
	if (isCursorShowing()) then
		self.x, self.y = getCursorPosition()
		self.worldZ = 25
	end
	
	if (self.alpha > 0) then
		self.alpha = self.alpha - 2.5
	else
		self.alpha = 0
		self:deletePositionMarker()
	end
	
	if (self.positionMarker) then
		self.positionMarker:setAlpha(self.alpha)
	end
end


function ClickSystem_C:onClientClick(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if (button == Bindings["MOVETO"]) and (state == "down") then
		if (self.player) and (isElement(self.player)) then
			self.playerPos = self.player:getPosition()
	
			self.worldX = worldX
			self.worldY = worldY
			self.worldZ = worldZ
			
			if (self.worldX) and (self.worldY) and (self.worldZ) then
				if (isLineOfSightClear(self.worldX, self.worldY, self.worldZ + 0.5, self.playerPos.x, self.playerPos.y, self.playerPos.z, true, true, false, true, false, true)) then
					self.markerColor = self.markerColorOK
					triggerServerEvent("SETPLAYERTARGET", root, self.worldX, self.worldY, self.worldZ)
				else
					self.markerColor = self.markerColorFailed
				end
				
				self:createPositionMarker()
			end
		end
	end
end


function ClickSystem_C:createPositionMarker()
	if (not self.positionMarker) then
		self.alpha = 255
		self.positionMarker = createMarker(self.worldX, self.worldY, self.worldZ, "corona", 0.5, self.markerColor.r, self.markerColor.g, self.markerColor.b, 255)
		self.positionMarker:setAlpha(self.alpha)
	else
		self.alpha = 255
		self.positionMarker:setPosition(self.worldX, self.worldY, self.worldZ)
		self.positionMarker:setAlpha(self.alpha)
		self.positionMarker:setColor(self.markerColor.r, self.markerColor.g, self.markerColor.b, self.alpha)
	end
end


function ClickSystem_C:deletePositionMarker()
	if (self.positionMarker) then
		self.positionMarker:destroy()
		self.positionMarker = nil
	end
end


function ClickSystem_C:getWorldPosition()
	return self.worldX, self.worldY, self.worldZ
end


function ClickSystem_C:getPosition()
	return self.x * self.screenWidth, self.y * self.screenHeight
end


function ClickSystem_C:clear()
	removeEventHandler ("onClientClick", root, self.m_onClientClick)
	
	self:deletePositionMarker()
	
	showCursor(false, false)
end


function ClickSystem_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("ClickSystem_C was deleted.")
	end
end