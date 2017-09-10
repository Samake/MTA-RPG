GUIInventory_C = inherit(Singleton)

function GUIInventory_C:constructor()
	
	self.guiElements = {}
	
	self.postGUI = true
	self.inventory = nil
	
	self.availableSlot = nil
	self.columnScale = 1.25
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUIInventory_C was loaded.")
	end
end


function GUIInventory_C:init()
	self.guiElements[1] = dxWindow:new(0.05, 0.05, 0.9, 0.9, nil, true)
	
	if (self.guiElements[1]) then
		self.guiElements[1]:setBackgroundColor(15, 15, 15)
		self.guiElements[1]:setBorderColor(90, 220, 90)
		self.guiElements[1]:setAlpha(Settings.guiAlpha)
		self.guiElements[1]:setPostGUI(self.postGUI)
		
		self.guiElements[2] = dxLine:new(0.025, 0.1, 0.95, 0.0, self.guiElements[1], true)
		self.guiElements[2]:setColor(90, 220, 90)
		
		self.guiElements[3] = dxText:new("Name", 0.025, 0, 0.19, 0.1, self.guiElements[1], true)
		self.guiElements[3]:setScale(self.columnScale)
		self.guiElements[3]:setAlignX("left")
		
		self.guiElements[4] = dxText:new("Lvl", 0.215, 0, 0.19, 0.1, self.guiElements[1], true)
		self.guiElements[4]:setScale(self.columnScale)
		self.guiElements[4]:setAlignX("left")
		
		self.guiElements[5] = dxText:new("Rank", 0.405, 0, 0.19, 0.1, self.guiElements[1], true)
		self.guiElements[5]:setScale(self.columnScale)
		self.guiElements[5]:setAlignX("left")
		
		self.guiElements[6] = dxText:new("Class", 0.595, 0, 0.19, 0.1, self.guiElements[1], true)
		self.guiElements[6]:setScale(self.columnScale)
		self.guiElements[6]:setAlignX("left")
		
		self.guiElements[7] = dxText:new("Money", 0.785, 0, 0.19, 0.1, self.guiElements[1], true)
		self.guiElements[7]:setScale(self.columnScale)
		self.guiElements[7]:setAlignX("left")
		
		self.guiElements[8] = GUICharacterSlots_C:new(0.025, 0.12, 0.45, 0.86, self.guiElements[1], true)
		self.guiElements[8]:setBorderColor(90, 220, 90)
		
		self.guiElements[9] = GUIInventorySlots_C:new(0.525, 0.12, 0.45, 0.86, self.guiElements[1], true)
		self.guiElements[9]:setBorderColor(90, 220, 90)
		self.guiElements[9]:setGridSlots(Settings.inventorySize, Settings.inventorySize)
	end
end



function GUIInventory_C:update(deltaTime)
	self.inventory = Player_C:getSingleton():getInventory()
	
	if (self.inventory) then
		self.availableSlot = nil
		
		if (self.guiElements[1]) then
			if (self.guiElements[1]:isCursorInside() == true) then
				GUIManager_C:getSingleton():setCursorOnGUIElement(true)
			end
		end
		
		if (Player_C:getSingleton():getName()) then
			self.guiElements[3]:setText("#EEEEEE Name: #44EE44" .. Player_C:getSingleton():getName())
		end
		
		if (Player_C:getSingleton():getLevel()) then
			self.guiElements[4]:setText("#EEEEEE Lvl: #44EE44" .. Player_C:getSingleton():getLevel())
		end
		
		if (Player_C:getSingleton():getRank()) then
			self.guiElements[5]:setText("#EEEEEE Rank: #44EE44" .. Player_C:getSingleton():getRank())
		end
		
		if (Player_C:getSingleton():getClass()) then
			self.guiElements[6]:setText("#EEEEEE Class: #44EE44" .. Player_C:getSingleton():getClass())
		end
		
		if (Player_C:getSingleton():getMoney()) then
			self.guiElements[7]:setText("#EEEEEE Money: #EEEE44" .. Player_C:getSingleton():getMoney() .. " $")
		end

		for index, guiElement in ipairs(self.guiElements) do
			if (guiElement) then
				guiElement:update(deltaTime)
			end
		end
	end
end


function GUIInventory_C:clear()
	for index, guiElement in pairs(self.guiElements) do
		if (guiElement) then
			guiElement:delete()
			guiElement = nil
		end
	end
end


function GUIInventory_C:addItem(item)
	if (item) then
		local inventorySlots = self.guiElements[9]:getSlots()
		

		if (inventorySlots) then
			for index, slot in pairs(inventorySlots) do
				if (slot) then
					if (item.slotID == index) then
						slot:setItem(item)
						break
					end
				end
			end
		end

		local characterSlots = self.guiElements[8]:getSlots()
		
		if (characterSlots) then
			for index, slot in pairs(characterSlots) do
				if (slot) then
					if (item.slotID == index) then
						slot:setItem(item)
						break
					end
				end
			end
		end
	end		
end


function GUIInventory_C:deleteItem(slotID)
	if (slotID) then
		local inventorySlots = self.guiElements[9]:getSlots()
		
		if (inventorySlots) then
			for index, slot in pairs(inventorySlots) do
				if (slotID == index) then
					slot:setItem(nil)
					return
				end
			end
		end
	end
end


function GUIInventory_C:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUIInventory_C was deleted.")
	end
end