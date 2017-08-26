GUIQuickSlots_C = inherit(Class)

function GUIQuickSlots_C:constructor(id)

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.playerSlots = nil
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUIQuickSlots_C was loaded.")
	end
end


function GUIQuickSlots_C:init()
	if (not self.guiSlots) then
		self.guiSlots = dxQuickSlots:new(0.2, 0.89, 0.6, 0.1)
		self.guiSlots:setPostGUI(true)
		self.guiSlots:setAlpha(180)
	end
	
	self.playerSlots = Player_C:getSingleton():getPlayerSlots()
	
	if (self.playerSlots) then
		for index, slot in pairs(self.playerSlots) do
			if (slot) then
				if (self.guiSlots) then
					self.guiSlots:setSlotFunction(index, slot.attackFunction)
					
					local iconValues = string.split(slot.icon, "|")
					
					if (iconValues) then
						if (iconValues[1]) and (iconValues[2]) and (iconValues[2]) then
							if (Textures[iconValues[1]][iconValues[2]][tonumber(iconValues[3])]) then
								if (Textures[iconValues[1]][iconValues[2]][tonumber(iconValues[3])].texture) then
									self.guiSlots:setSlotIcon(index, Textures[iconValues[1]][iconValues[2]][tonumber(iconValues[3])].texture)
								end
							end
						end
					end
				end
			end
		end
	end
end


function GUIQuickSlots_C:update(deltaTime)
	if (self.guiSlots) then
		self.guiSlots:update()
		
		GUIManager_C:getSingleton():setCursorOnGUIElement(self.guiSlots:isCursorInside())
	end
end


function GUIQuickSlots_C:clear()
	if (self.guiSlots) then
		self.guiSlots:delete()
		self.guiSlots = nil
	end
end


function GUIQuickSlots_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUIQuickSlots_C was deleted.")
	end
end