MousePointer_C = inherit(Singleton)

function MousePointer_C:constructor()
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()

	self.x = 0
	self.y = 0
	self.worldX = 0
	self.worldY = 0
	self.worldZ = 0
	self.size = self.screenHeight * 0.035
	
	self.rotation = 0
	self.postGUI = true
	
	self.alpha = 180
	
	self.defaultColor = tocolor(220, 220, 220, self.alpha)
	self.friendColor = tocolor(15, 220, 15, self.alpha)
	self.enemyColor = tocolor(220, 15, 15, self.alpha)
	self.color = self.defaultColor
	
	self.camX = 0
	self.camY = 0
	self.camZ = 0
	
	self.hitElement = nil
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("MousePointer_C was loaded.")
	end
end


function MousePointer_C:init()
	setCursorAlpha(0)
end


function MousePointer_C:update(deltaTime)
	if (isCursorShowing()) then
		if (GUIManager_C:getSingleton():isCursorOnGUIElement() == false) then
			setCursorAlpha(0)
			
			self:updatePositions()
			self:updateHitDetails()
			self:updateColors()
			
			if (Textures["GUI"]["Cursor"][1]) then
				if (Textures["GUI"]["Cursor"][1].texture) then
					dxDrawImage(self.x - self.size / 2, self.y - self.size / 2, self.size, self.size, Textures["GUI"]["Cursor"][1].texture, self.rotation, 0, 0, self.color, self.postGUI)
				end
			end
		else
			setCursorAlpha(self.alpha)
		end
	end
end


function MousePointer_C:updatePositions()
	local x, y, wx, wy, wz = getCursorPosition()

	self.x = x * self.screenWidth
	self.y = y * self.screenHeight
	self.worldX = wx
	self.worldY = wy
	self.worldZ = wz
end


function MousePointer_C:updateHitDetails()
	self.camX, self.camY, self.camZ = getCameraMatrix ()
	
	local hit, x, y, z, element = processLineOfSight (self.camX, self.camY, self.camZ, self.worldX, self.worldY, self.worldZ)
		
	if (hit) then
		if (element) then
			self.hitElement = element
		else
			self.hitElement = nil
		end
	end
end


function MousePointer_C:updateColors()
	if (self.hitElement) and (isElement(self.hitElement)) then
		if (self.hitElement:getType() == "ped") then
			self.color = self.enemyColor
		elseif (self.hitElement:getType() == "player") then
			self.color = self.friendColor
		end
	else
		self.color = self.defaultColor
	end
end


function MousePointer_C:clear()
	setCursorAlpha(255)
end


function MousePointer_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("MousePointer_C was deleted.")
	end
end