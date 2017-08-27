GUIQuickSlots_C = inherit(Class)

function GUIQuickSlots_C:constructor(id)

	self.playerSlots = nil
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUIQuickSlots_C was loaded.")
	end
end


function GUIQuickSlots_C:init()
	self.m_ActionSlot1 = bind(self.actionSlot1, self)
	self.m_ActionSlot2 = bind(self.actionSlot2, self)
	self.m_ActionSlot3 = bind(self.actionSlot3, self)
	self.m_ActionSlot4 = bind(self.actionSlot4, self)
	self.m_ActionSlot5 = bind(self.actionSlot5, self)
	self.m_ActionSlot6 = bind(self.actionSlot6, self)
	self.m_ActionSlot7 = bind(self.actionSlot7, self)
	self.m_ActionSlot8 = bind(self.actionSlot8, self)
	self.m_ActionSlot9 = bind(self.actionSlot9, self)
	self.m_ActionSlot10 = bind(self.actionSlot10, self)
	
	self.m_UpdateSlots = bind(self.updateSlots, self)
	addEvent("UPDATEQUICKSLOTS", true)
	addEventHandler("UPDATEQUICKSLOTS", root, self.m_UpdateSlots)
	
	-- load quickslots
	if (not self.guiSlots) then
		self.guiSlots = dxQuickSlots:new(0.2, 0.89, 0.6, 0.1, nil, true)
		self.guiSlots:setPostGUI(true)
		self.guiSlots:setAlpha(Settings.guiAlpha)
	end
	
	-- load functions
	if (self.guiSlots) then
		self.guiSlots:setSlotFunction(1, self.m_ActionSlot1)
		self.guiSlots:setSlotFunction(2, self.m_ActionSlot2) 
		self.guiSlots:setSlotFunction(3, self.m_ActionSlot3) 
		self.guiSlots:setSlotFunction(4, self.m_ActionSlot4) 
		self.guiSlots:setSlotFunction(5, self.m_ActionSlot5) 
		self.guiSlots:setSlotFunction(6, self.m_ActionSlot6) 
		self.guiSlots:setSlotFunction(7, self.m_ActionSlot7) 
		self.guiSlots:setSlotFunction(8, self.m_ActionSlot8) 
		self.guiSlots:setSlotFunction(9, self.m_ActionSlot9) 
		self.guiSlots:setSlotFunction(10, self.m_ActionSlot10)
		
		-- bind keys
		bindKey(Bindings["SLOT1"], "down", self.m_ActionSlot1)
		bindKey(Bindings["SLOT2"], "down", self.m_ActionSlot2)
		bindKey(Bindings["SLOT3"], "down", self.m_ActionSlot3)
		bindKey(Bindings["SLOT4"], "down", self.m_ActionSlot4)
		bindKey(Bindings["SLOT5"], "down", self.m_ActionSlot5)
		bindKey(Bindings["SLOT6"], "down", self.m_ActionSlot6)
		bindKey(Bindings["SLOT7"], "down", self.m_ActionSlot7)
		bindKey(Bindings["SLOT8"], "down", self.m_ActionSlot8)
		bindKey(Bindings["SLOT9"], "down", self.m_ActionSlot9)
		bindKey(Bindings["SLOT10"], "down", self.m_ActionSlot10)
	end
end


function GUIQuickSlots_C:update(deltaTime)
	if (self.guiSlots) then
		self.guiSlots:update()
		self:updateSlotUsability()
		
		if (self.guiSlots:isCursorInside() == true) then
			GUIManager_C:getSingleton():setCursorOnGUIElement(true)
		end
	end
end


function GUIQuickSlots_C:updateSlots()
	-- load slot values
	self.playerSlots = Player_C:getSingleton():getPlayerSlots()
	
	if (self.playerSlots) then
		for index, slot in pairs(self.playerSlots) do
			if (slot) then
				if (self.guiSlots) then
					self.guiSlots:setSlotDelay(index, slot.delay)
					
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


function GUIQuickSlots_C:updateSlotUsability()
	self.mana = Player_C:getSingleton():getCurrentMana()
	
	if (self.mana) then
		if (self.playerSlots) then
			for index, slot in pairs(self.playerSlots) do
				if (slot) then
					if (slot.costs > self.mana) then
						if (self.guiSlots:isSlotActive(index) == true) then
							self.guiSlots:setSlotActive(index, false, true)
						end
					else
						if (self.guiSlots:isSlotActive(index) == false) then
							self.guiSlots:setSlotActive(index, false)
						end
					end
				end
			end
		end
	end
end


function GUIQuickSlots_C:actionSlot1()
	if (self.guiSlots:isSlotActive(1) == true) then
		triggerServerEvent("DOSLOTACTION", root, 1)
		self.guiSlots:setSlotActive(1, false, false)
	end
end


function GUIQuickSlots_C:actionSlot2()
	if (self.guiSlots:isSlotActive(2) == true) then
		triggerServerEvent("DOSLOTACTION", root, 2)
		self.guiSlots:setSlotActive(2, false, false)
	end
end


function GUIQuickSlots_C:actionSlot3()
	if (self.guiSlots:isSlotActive(3) == true) then
		triggerServerEvent("DOSLOTACTION", root, 3)
		self.guiSlots:setSlotActive(3, false, false)
	end
end


function GUIQuickSlots_C:actionSlot4()
	if (self.guiSlots:isSlotActive(4) == true) then
		triggerServerEvent("DOSLOTACTION", root, 4)	
		self.guiSlots:setSlotActive(4, false, false)
	end
end


function GUIQuickSlots_C:actionSlot5()
	if (self.guiSlots:isSlotActive(5) == true) then
		triggerServerEvent("DOSLOTACTION", root, 5)	
		self.guiSlots:setSlotActive(5, false, false)
	end
end


function GUIQuickSlots_C:actionSlot6()
	if (self.guiSlots:isSlotActive(6) == true) then
		triggerServerEvent("DOSLOTACTION", root, 6)	
		self.guiSlots:setSlotActive(6, false, false)
	end
end


function GUIQuickSlots_C:actionSlot7()
	if (self.guiSlots:isSlotActive(7) == true) then
		triggerServerEvent("DOSLOTACTION", root, 7)
		self.guiSlots:setSlotActive(7, false, false)
	end
end


function GUIQuickSlots_C:actionSlot8()
	if (self.guiSlots:isSlotActive(8) == true) then
		triggerServerEvent("DOSLOTACTION", root, 8)
		self.guiSlots:setSlotActive(8, false, false)
	end
end


function GUIQuickSlots_C:actionSlot9()
	if (self.guiSlots:isSlotActive(9) == true) then
		triggerServerEvent("DOSLOTACTION", root, 9)
		self.guiSlots:setSlotActive(9, false, false)
	end
end


function GUIQuickSlots_C:actionSlot10()
	if (self.guiSlots:isSlotActive(10) == true) then
		triggerServerEvent("DOSLOTACTION", root, 10)
		self.guiSlots:setSlotActive(10, false, false)
	end
end


function GUIQuickSlots_C:clear()
	unbindKey(Bindings["SLOT1"], "down", self.m_ActionSlot1)
	unbindKey(Bindings["SLOT2"], "down", self.m_ActionSlot2)
	unbindKey(Bindings["SLOT3"], "down", self.m_ActionSlot3)
	unbindKey(Bindings["SLOT4"], "down", self.m_ActionSlot4)
	unbindKey(Bindings["SLOT5"], "down", self.m_ActionSlot5)
	unbindKey(Bindings["SLOT6"], "down", self.m_ActionSlot6)
	unbindKey(Bindings["SLOT7"], "down", self.m_ActionSlot7)
	unbindKey(Bindings["SLOT8"], "down", self.m_ActionSlot8)
	unbindKey(Bindings["SLOT9"], "down", self.m_ActionSlot9)
	unbindKey(Bindings["SLOT10"], "down", self.m_ActionSlot10)
	
	removeEventHandler("UPDATEQUICKSLOTS", root, self.m_UpdateSlots)
		
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