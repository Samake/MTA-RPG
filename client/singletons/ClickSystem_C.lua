ClickSystem_C = inherit(Singleton)

function ClickSystem_C:constructor()
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.player = getLocalPlayer()
	
	self.x = 0
	self.y = 0
	self.worldX = 0
	self.worldY = 0
	self.worldZ = 0
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("ClickSystem_C was loaded.")
	end
end


function ClickSystem_C:init()
	self.m_onClientClick = bind(self.onClientClick, self)
	addEventHandler("onClientClick", root, self.m_onClientClick)
end


function ClickSystem_C:update(deltaTime)
	if (isCursorShowing()) then
		self.x, self.y = getCursorPosition()
	end
end


function ClickSystem_C:onClientClick(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if (GUIManager_C:getSingleton():isCursorOnGUIElement() == false) then
		if (button == Bindings["MOVETO"]) and (state == "down") then
			if (self.player) and (isElement(self.player)) then
				self.playerPos = self.player:getPosition()
		
				self.worldX = worldX
				self.worldY = worldY
				self.worldZ = worldZ
				
				if (self.worldX) and (self.worldY) and (self.worldZ) then
					if (isLineOfSightClear(self.worldX, self.worldY, self.worldZ + 0.5, self.playerPos.x, self.playerPos.y, self.playerPos.z, true, true, false, true, false, true)) then
						Marker3D_C:getSingleton():setColor(90, 220, 90)
						triggerServerEvent("SETPLAYERTARGET", root, self.worldX, self.worldY, self.worldZ)
					else
						Marker3D_C:getSingleton():setColor(220, 90, 90)
					end

					Marker3D_C:getSingleton():setPosition(self.worldX, self.worldY, self.worldZ)
				end
			end
		end
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
	
end


function ClickSystem_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("ClickSystem_C was deleted.")
	end
end