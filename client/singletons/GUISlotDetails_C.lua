GUISlotDetails_C = inherit(Singleton)

function GUISlotDetails_C:constructor()
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.x = 0
	self.y = 0
	self.width = 0
	self.height = 0
	
	self.color = {r = 25, g = 25, b = 25}
	self.shadowColor = {r = 15, g = 15, b = 15}
	self.borderColor = {r = 90, g = 90, b = 90}
	self.fontColor = {r = 200, g = 200, b = 90}
	
	self.shadowOffset = 1
	self.borderSize = 2
	
	self.alpha = Settings.guiAlpha
	
	self.postGUI = true
	self.subPixelPositioning = true
	
	self.itemContainer = nil
	self.slotID = nil
	
	self.guiElements = {}

	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUISlotDetails_C " .. self.slotID .. " was loaded.")
	end
end


function GUISlotDetails_C:init()
	self:calcValues()
	
	self.guiElements[1] = dxWindow:new(0, 0, 0, 0, self, false)
	
	if (self.guiElements[1]) then
		self.guiElements[1]:setAlpha(Settings.guiAlpha)
		
		self.guiElements[2] = dxText:new("Name", 0, 0.025, 1, 0.05, self.guiElements[1], true)
		self.guiElements[2]:setScale(0.9)
		self.guiElements[2]:setFontColor(220, 180, 45)
		
		self.guiElements[3] = dxText:new("Quality: - ", 0, 0.075, 1, 0.05, self.guiElements[1], true)
		self.guiElements[3]:setFontColor(220, 220, 220)
		self.guiElements[3]:setScale(0.75)
		
		self.guiElements[4] = dxText:new("Armor", 0, 0.16, 1, 0.05, self.guiElements[1], true)
		self.guiElements[4]:setScale(0.85)
		self.guiElements[4]:setFontColor(220, 220, 220)
		
		self.guiElements[5] = dxLine:new(0.05, 0.225, 0.9, 0, self.guiElements[1], true)
		self.guiElements[5]:setColor(65, 65, 65)
		
		self.guiElements[6] = dxTextArea:new("Description", 0.05, 0.25, 0.9, 0.55, self.guiElements[1], true)
		self.guiElements[6]:setFontColor(180, 220, 180)
		self.guiElements[6]:setScale(0.8)
		
		self.guiElements[7] = dxLine:new(0.05, 0.675, 0.9, 0, self.guiElements[1], true)
		self.guiElements[7]:setColor(65, 65, 65)
		
		self.guiElements[8] = dxText:new("STA: 0", 0.1, 0.7, 0.4, 0.05, self.guiElements[1], true)
		self.guiElements[8]:setAlignX("left")
		self.guiElements[8]:setScale(0.85)
		self.guiElements[8]:setFontColor(220, 220, 220)
		
		self.guiElements[9] = dxText:new("INT: 0", 0.5, 0.7, 0.4, 0.05, self.guiElements[1], true)
		self.guiElements[9]:setAlignX("left")
		self.guiElements[9]:setScale(0.85)
		self.guiElements[9]:setFontColor(220, 220, 220)
		
		self.guiElements[10] = dxText:new("CRIT: 0", 0.1, 0.75, 0.4, 0.05, self.guiElements[1], true)
		self.guiElements[10]:setAlignX("left")
		self.guiElements[10]:setScale(0.85)
		self.guiElements[10]:setFontColor(220, 220, 220)
		
		self.guiElements[11] = dxLine:new(0.05, 0.825, 0.9, 0, self.guiElements[1], true)
		self.guiElements[11]:setColor(65, 65, 65)
		
		self.guiElements[12] = dxText:new("Buy: 0 $", 0.1, 0.875, 0.4, 0.05, self.guiElements[1], true)
		self.guiElements[12]:setAlignX("left")
		self.guiElements[12]:setScale(0.85)
		self.guiElements[12]:setFontColor(220, 220, 220)
		
		self.guiElements[13] = dxText:new("Sell: 0 $", 0.5, 0.875, 0.4, 0.05, self.guiElements[1], true)
		self.guiElements[13]:setAlignX("left")
		self.guiElements[13]:setScale(0.85)
		self.guiElements[13]:setFontColor(220, 220, 220)
	end
end


function GUISlotDetails_C:update(deltaTime)
	if (self.slotID) and (self.itemContainer) then
		self:calcValues()
		
		self.qualityColor = self.itemContainer:getColor()
		self.stats = self.itemContainer:getStats()
		
		if (self.stats) then
			if (self.stats.armor) then
				self.armor = self.stats.armor
			else
				self.armor = 0
			end
			
			if (self.stats.stamina) then
				self.stamina = self.stats.stamina
			else
				self.stamina = 0
			end
			
			if (self.stats.intelligence) then
				self.intelligence = self.stats.intelligence
			else
				self.intelligence = 0
			end
			
			if (self.stats.crit) then
				self.crit = self.stats.crit
			else
				self.crit = 0
			end
		end
		
		if (self.guiElements[1]) then
			self.guiElements[1]:setPosition(self.x, self.y)
			self.guiElements[1]:setSize(self.width, self.height)
		end
		
		if (self.guiElements[2]) then
			self.guiElements[2]:setText(self.itemContainer:getName())
		end
		
		if (self.guiElements[3]) then
			self.guiElements[3]:setText("#9999EEQuality: " .. RGBToHex(self.qualityColor.r, self.qualityColor.g, self.qualityColor.b) .. self.itemContainer:getQuality())
			
			if (self.itemContainer:getItemID() < 10) then
				self.guiElements[3]:setText("")
			end
		end
		
		if (self.guiElements[4]) then	
			self.guiElements[4]:setText("#EEEEEEArmor: #44EE44" .. self.armor)
			
			if (self.itemContainer:getItemID() < 10) then
				self.guiElements[4]:setText("")
			end
		end
		
		if (self.guiElements[6]) then
			self.guiElements[6]:setText("#9999EE" .. self.itemContainer:getDescription())
		end
		
		if (self.guiElements[8]) then	
			self.guiElements[8]:setText("#EEEEEESTA: #44EE44" .. self.stamina)
			
			if (self.itemContainer:getItemID() < 10) then
				self.guiElements[8]:setText("")
			end
		end
		
		if (self.guiElements[9]) then	
			self.guiElements[9]:setText("#EEEEEEINT: #44EE44" .. self.intelligence)
			
			if (self.itemContainer:getItemID() < 10) then
				self.guiElements[9]:setText("")
			end
		end
		
		if (self.guiElements[10]) then	
			self.guiElements[10]:setText("#EEEEEECRIT: #44EE44" .. self.crit)
			
			if (self.itemContainer:getItemID() < 10) then
				self.guiElements[10]:setText("")
			end
		end
		
		if (self.guiElements[12]) then	
			self.guiElements[12]:setText("#EEEEEEBuy: #EEEE44" .. self.itemContainer:getCosts() .. " $")
		end
		
		if (self.guiElements[13]) then	
			self.guiElements[13]:setText("#EEEEEESell: #EEEE44" .. math.floor((self.itemContainer:getCosts() / 2) + 0.5) .. " $")
		end
		
		for index, guiElement in ipairs(self.guiElements) do
			if (guiElement) then
				guiElement:update()
			end
		end	
	end
end


function GUISlotDetails_C:calcValues()
	if (not self.slotID) then
		self.x = 0
		self.y = 0
		self.width = 0
		self.height = 0
	else
		if (self.y + self.height > self.screenHeight) then
			self.y = self.screenHeight - self.height
		end
	end
end


function GUISlotDetails_C:setPosition(x, y)
	if (x) and (y) then
		self.x = x
		self.y = y
	end
end


function GUISlotDetails_C:getPosition()
	return self.x, self.y
end


function GUISlotDetails_C:setSize(w, h)
	if (w) and (h) then
		self.width = w
		self.height = h
	end
end


function GUISlotDetails_C:getSize()
	return self.width, self.height
end


function GUISlotDetails_C:setBackgroundColor(r, g, b)
	if (r) and (g) and (b) then
		self.color.r = r
		self.color.g = g
		self.color.b = b
	end
end


function GUISlotDetails_C:getBackgroundColor()
	return self.color
end


function GUISlotDetails_C:setBorderColor(r, g, b)
	if (r) and (g) and (b) then
		self.borderColor.r = r
		self.borderColor.g = g
		self.borderColor.b = b
	end
end


function GUISlotDetails_C:getBorderColor()
	return self.borderColor
end


function GUISlotDetails_C:setBorderSize(size)
	if (size) then
		self.borderSize = size
	end
end


function GUISlotDetails_C:getBorderSize()
	return self.borderSize
end


function GUISlotDetails_C:setAlpha(alpha)
	if (alpha) then
		self.alpha = alpha
	end
end


function GUISlotDetails_C:getAlpha()
	return self.alpha
end


function GUISlotDetails_C:setPostGUI(postGUI)
	self.postGUI = postGUI
end


function GUISlotDetails_C:getPostGUI()
	return self.postGUI
end


function GUISlotDetails_C:setSubPixelPositioning(subPixelPositioning)
	self.subPixelPositioning = subPixelPositioning
end


function GUISlotDetails_C:getSubPixelPositioning()
	return self.subPixelPositioning
end


function GUISlotDetails_C:setItem(itemContainer)
	self.itemContainer = itemContainer
end


function GUISlotDetails_C:getItem()
	return self.itemContainer
end


function GUISlotDetails_C:setSlotID(slotID)
	self.slotID = slotID
end


function GUISlotDetails_C:getSlotID()
	return self.slotID
end


function GUISlotDetails_C:clear()
	for index, guiElement in pairs(self.guiElements) do
		if (guiElement) then
			guiElement:delete()
			guiElement = nil
		end
	end
end


function GUISlotDetails_C:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUISlotDetails_C " .. self.slotID .. " was deleted.")
	end
end