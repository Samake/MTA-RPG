Camera_C = inherit(Class)

function Camera_C:constructor()

	self.player = getLocalPlayer()
	
	self.playerPos = nil
	self.playerRot = nil
	
	self.camX = 0
	self.camY = 0
	self.camZ = 0
	
	self.camTargetX = 0
	self.camTargetY = 0
	self.camTargetZ = 0
	
	self.minDistance = Settings.minZoom
	self.maxDistance = Settings.maxZoom / 2
	self.currentDistance = Settings.defaultZoom
	
	self.minHeight = Settings.minZoom / 2
	self.maxHeight = Settings.maxZoom
	self.currentHeight = Settings.defaultZoom
	
	self.angle = 90
	self.roll = 0
	self.fov = Settings.fov
	
	self.mouseX = 0
	self.mouseY = 0
	self.lastMouseX = nil
	self.lastMouseY = nil
	
	self.scrollSpeed = Settings.zoomSpeed
	self.rotateSpeed = Settings.rotateSpeed
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Camera_C was loaded.")
	end
end


function Camera_C:init()
	self.m_ScrollIn = bind(self.scrollIn, self)
	self.m_ScrollOut = bind(self.scrollOut, self)
	
	bindKey(Bindings["CAMERASCROLLIN"], "down", self.m_ScrollIn)
	bindKey(Bindings["CAMERASCROLLOUT"], "down", self.m_ScrollOut)
end


function Camera_C:update(deltaTime)
	if (self.player) and (isElement(self.player)) then
		self.playerPos = self.player:getPosition()
		self.playerRot = self.player:getRotation()
		
		if (self.playerPos) and (self.playerRot) then
			
			if (GUIManager_C:getSingleton():isCursorOnGUIElement() == false) then
				if (getKeyState(Bindings["CAMERAROTATE"]) == true) then
					self:rotate()
				else
					self.lastMouseX = nil
					self.lastMouseY = nil
				end
			end
			
			self.camTargetX, self.camTargetY, self.camTargetZ = self.playerPos.x, self.playerPos.y, self.playerPos.z
			self.camX, self.camY, self.camZ = getAttachedPosition(self.playerPos.x, self.playerPos.y, self.playerPos.z, 0, 0, 0, self.currentDistance, self.angle, self.currentHeight)
			
			setCameraMatrix(self.camX, self.camY, self.camZ, self.camTargetX, self.camTargetY, self.camTargetZ, self.roll, self.fov)
		end
	end
end


function Camera_C:scrollIn()
	if (GUIManager_C:getSingleton():isCursorOnGUIElement() == false) then
		if (self.currentDistance > self.minDistance) then
			self.currentDistance = self.currentDistance - self.scrollSpeed / 2
		else
			self.currentDistance = self.minDistance
		end
		
		if (self.currentHeight > self.minHeight) then
			self.currentHeight = self.currentHeight - self.scrollSpeed / 2
		else
			self.currentHeight = self.minHeight
		end
	end
end


function Camera_C:scrollOut()
	if (GUIManager_C:getSingleton():isCursorOnGUIElement() == false) then
		if (self.currentDistance < self.maxDistance) then
			self.currentDistance = self.currentDistance + self.scrollSpeed
		else
			self.currentDistance = self.maxDistance
		end
		
		if (self.currentHeight < self.maxHeight) then
			self.currentHeight = self.currentHeight + self.scrollSpeed
		else
			self.currentHeight = self.maxHeight
		end
	end
end


function Camera_C:rotate()
	self.mouseX, self.mouseY = ClickSystem_C:getSingleton():getPosition()
	
	if (self.lastMouseX) and (self.lastMouseY) then
		if (self.lastMouseX < self.mouseX - 15) then
			self.angle = (self.angle + self.rotateSpeed)%360
			self.lastMouseX = self.mouseX
		elseif (self.lastMouseX > self.mouseX + 15) then
			self.angle = (self.angle - self.rotateSpeed)%360
			self.lastMouseX = self.mouseX
		end
	else
		self.lastMouseX = self.mouseX
		self.lastMouseY = self.mouseY
	end
end


function Camera_C:clear()
	unbindKey(Bindings["CAMERASCROLLIN"], "down", self.m_ScrollIn)
	unbindKey(Bindings["CAMERASCROLLOUT"], "down", self.m_ScrollOut)
	
	setCameraTarget(self.player)
end


function Camera_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Camera_C was deleted.")
	end
end