GUICharacterSlots_C = inherit(Class)

function GUICharacterSlots_C:constructor(x, y, w, h, parent, relative)
	
	self.slots = {}
	
	self.defaultX = x or 0
	self.defaultY = y or 0
	self.defaultWidth = w or 0
	self.defaultHeight = h or 0
	self.parent = parent or nil
	self.isRelative = relative or true
	
	self.x = self.defaultX
	self.y = self.defaultY
	self.width = self.defaultWidth
	self.height = self.defaultHeight
	
	self.color = {r = 15, g = 15, b = 15}
	self.borderColor = {r = 45, g = 45, b = 45}
	
	self.borderSize = 2
	
	self.alpha = 255
	
	self.mouseX = 0
	self.mouseY = 0
	
	self.postGUI = true
	self.subPixelPositioning = true
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUICharacterSlots_C was loaded.")
	end
end


function GUICharacterSlots_C:init()
	self:calcValues()
	
	if (not self.slots["head"]) then
		self.slots["head"] = GUISlot_C:new("head", 0.425, 0.01, 0.15, 0.15, self, true)
		self.slots["head"]:setCharacterSlot(true)
	end
	
	if (not self.slots["torso"]) then
		self.slots["torso"] = GUISlot_C:new("torso", 0.425, 0.225, 0.15, 0.15, self, true)
		self.slots["torso"]:setCharacterSlot(true)
	end
	
	if (not self.slots["legs"]) then
		self.slots["legs"] = GUISlot_C:new("legs", 0.425, 0.55, 0.15, 0.15, self, true)
		self.slots["legs"]:setCharacterSlot(true)
	end
	
	if (not self.slots["feet"]) then
		self.slots["feet"] = GUISlot_C:new("feet", 0.425, 0.825, 0.15, 0.15, self, true)
		self.slots["feet"]:setCharacterSlot(true)
	end
	
	if (not self.slots["leftHand"]) then
		self.slots["leftHand"] = GUISlot_C:new("leftHand", 0.15, 0.435, 0.15, 0.15, self, true)
		self.slots["leftHand"]:setCharacterSlot(true)
	end
	
	if (not self.slots["righthand"]) then
		self.slots["righthand"] = GUISlot_C:new("righthand", 0.7, 0.435, 0.15, 0.15, self, true)
		self.slots["righthand"]:setCharacterSlot(true)
	end
	
	if (not self.slots["leftRing"]) then
		self.slots["leftRing"] = GUISlot_C:new("leftRing", 0.15, 0.325, 0.075, 0.075, self, true)
		self.slots["leftRing"]:setCharacterSlot(true)
	end
	
	if (not self.slots["rightRing"]) then
		self.slots["rightRing"] = GUISlot_C:new("rightRing", 0.775, 0.325, 0.075, 0.075, self, true)
		self.slots["rightRing"]:setCharacterSlot(true)
	end
	
	if (not self.slots["chain"]) then
		self.slots["chain"] = GUISlot_C:new("chain", 0.15, 0.01, 0.1, 0.1, self, true)
		self.slots["chain"]:setCharacterSlot(true)
	end
	
	if (not self.staminaText) then
		self.staminaText = dxText:new("STA: 0 (+ 0%)", 0.025, 0.85, 0.5, 0.03, self, true)
		self.staminaText:setScale(0.85)
		self.staminaText:setAlignX("left")
	end
	
	if (not self.intelligenceText) then
		self.intelligenceText = dxText:new("INT: 0 (+ 0%)", 0.025, 0.88, 0.5, 0.03, self, true)
		self.intelligenceText:setScale(0.85)
		self.intelligenceText:setAlignX("left")
	end
	
	if (not self.armorText) then
		self.armorText = dxText:new("ARMOR: 0 (+ 0%)", 0.025, 0.91, 0.5, 0.03, self, true)
		self.armorText:setScale(0.85)
		self.armorText:setAlignX("left")
	end
	
	if (not self.critText) then
		self.critText = dxText:new("CRIT: 0 (+ 0%)", 0.025, 0.94, 0.5, 0.03, self, true)
		self.critText:setScale(0.85)
		self.critText:setAlignX("left")
	end
end



function GUICharacterSlots_C:update(deltaTime)
	self:calcValues()
	self:drawBackground()
	
	for index, slot in pairs(self.slots) do
		if (slot) then
			slot:update(deltaTime)
		end
	end
	
	if (self.staminaText) then
		if (Player_C:getSingleton():getStamina()) and (Player_C:getSingleton():getCurrentStamina()) then
			local stamina = Player_C:getSingleton():getStamina()
			local currentStamina = Player_C:getSingleton():getCurrentStamina()
			local modifiedPercent = string.format("%.1f", ((100 / stamina) * currentStamina) - 100)
			self.staminaText:setText("#EEEEEESTA: " .. currentStamina .. "#44EE44 (+" .. modifiedPercent .. "%)")
		end
		
		self.staminaText:update()
	end
	
	if (self.intelligenceText) then
		if (Player_C:getSingleton():getIntelligence()) and (Player_C:getSingleton():getCurrentIntelligence()) then
			local intelligence = Player_C:getSingleton():getIntelligence()
			local currentIntelligence = Player_C:getSingleton():getCurrentIntelligence()
			local modifiedPercent = string.format("%.1f", ((100 / intelligence) * currentIntelligence) - 100)
			self.intelligenceText:setText("#EEEEEEINT: " .. currentIntelligence .. "#44EE44 (+" .. modifiedPercent .. "%)")
		end
		
		self.intelligenceText:update()
	end
	
	if (self.armorText) then
		if (Player_C:getSingleton():getArmor()) and (Player_C:getSingleton():getCurrentArmor()) then
			local armor = Player_C:getSingleton():getArmor()
			local currentArmor = Player_C:getSingleton():getCurrentArmor()
			local modifiedPercent = string.format("%.1f", math.floor((currentArmor - armor) + 0.5))
			self.armorText:setText("#EEEEEEARMOR: " .. currentArmor .. "#44EE44 (+" .. modifiedPercent .. ")")
		end
		
		self.armorText:update()
	end
	
	if (self.critText) then
		if (Player_C:getSingleton():getCritChance()) and (Player_C:getSingleton():getCurrentCritChance()) then
			local critChance = Player_C:getSingleton():getCritChance()
			local currentCritChance = Player_C:getSingleton():getCurrentCritChance()
			local modifiedPercent = string.format("%.1f", math.floor((currentCritChance - critChance) + 0.5))
			self.critText:setText("#EEEEEECRIT: " .. currentCritChance .. "#44EE44 (+" .. modifiedPercent .. ")")
		end
		
		self.critText:update()
	end
end


function GUICharacterSlots_C:drawBackground()
	-- draw bg
	dxDrawRectangle(self.x, self.y, self.width, self.height, tocolor(self.color.r, self.color.g, self.color.b, self.alpha), self.postGUI, self.subPixelPositioning)
	
	-- draw border
	dxDrawLine(self.x, self.y, self.x + self.width, self.y, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)
	dxDrawLine(self.x + self.width, self.y, self.x + self.width, self.y + self.height, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)
	dxDrawLine(self.x + self.width, self.y + self.height, self.x, self.y + self.height, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)
	dxDrawLine(self.x, self.y + self.height, self.x, self.y, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)

	if (Textures["GUI"]["Misc"][1]) then
		dxDrawImage(self.x, self.y, self.width, self.height, Textures["GUI"]["Misc"][1].texture, 0, 0, 0, tocolor(35, 35, 35,self.alpha), self.postGUI)
	end
end


function GUICharacterSlots_C:calcValues()
	if (self.parent) then
		if (self.isRelative == true) then
			self.x = self.parent.x + self.parent.width * self.defaultX
			self.y = self.parent.y + self.parent.height * self.defaultY
			self.width = self.parent.width * self.defaultWidth
			self.height = self.parent.height * self.defaultHeight
		else
			self.x = self.defaultX
			self.y = self.defaultY
			self.width = self.defaultWidth
			self.height = self.defaultHeight
		end
		
		self.alpha = self.parent.alpha
		self.postGUI = self.parent.postGUI
	else
		if (self.isRelative == true) then
			self.x = self.screenWidth * self.defaultX
			self.y = self.screenHeight * self.defaultY
			self.width = self.screenWidth * self.defaultWidth
			self.height = self.screenHeight * self.defaultHeight
		else
			self.x = self.defaultX
			self.y = self.defaultY
			self.width = self.defaultWidth
			self.height = self.defaultHeight
		end
	end
	
	self.mouseX, self.mouseY = ClickSystem_C:getSingleton():getPosition()
end


function GUICharacterSlots_C:isCursorInside()
	if (self.mouseX > self.x) and (self.mouseX < self.x + self.width) then
		if (self.mouseY > self.y) and (self.mouseY < self.y + self.height) then
			return true
		end
	end

	return false
end


function GUICharacterSlots_C:setPosition(x, y)
	if (x) and (y) then
		self.defaultX = x
		self.defaultY = y
	end
end


function GUICharacterSlots_C:getPosition()
	return self.defaultX, self.defaultY
end


function GUICharacterSlots_C:setSize(w, h)
	if (w) and (h) then
		self.defaultWidth = w
		self.defaultHeight = h
	end
end


function GUICharacterSlots_C:getSize()
	return self.defaultWidth, self.defaultHeight
end


function GUICharacterSlots_C:setParent(parent)
	if (parent) then
		self.parent = parent
	end
end


function GUICharacterSlots_C:getParent()
	return self.parent
end


function GUICharacterSlots_C:setBackgroundColor(r, g, b)
	if (r) and (g) and (b) then
		self.color.r = r
		self.color.g = g
		self.color.b = b
	end
end


function GUICharacterSlots_C:getBackgroundColor()
	return self.color
end


function GUICharacterSlots_C:setBorderColor(r, g, b)
	if (r) and (g) and (b) then
		self.borderColor.r = r
		self.borderColor.g = g
		self.borderColor.b = b
	end
end


function GUICharacterSlots_C:getBorderColor()
	return self.borderColor
end


function GUICharacterSlots_C:setBorderSize(size)
	if (size) then
		self.borderSize = size
	end
end


function GUICharacterSlots_C:getBorderSize()
	return self.borderSize
end


function GUICharacterSlots_C:setAlpha(alpha)
	if (alpha) then
		self.alpha = alpha
	end
end


function GUICharacterSlots_C:getAlpha()
	return self.alpha
end


function GUICharacterSlots_C:setPostGUI(postGUI)
	self.postGUI = postGUI
end


function GUICharacterSlots_C:getPostGUI()
	return self.postGUI
end


function GUICharacterSlots_C:setSubPixelPositioning(subPixelPositioning)
	self.subPixelPositioning = subPixelPositioning
end


function GUICharacterSlots_C:getSubPixelPositioning()
	return self.subPixelPositioning
end


function GUICharacterSlots_C:getSlots()
	return self.slots
end


function GUICharacterSlots_C:clear()
	for index, slot in pairs(self.slots) do
		if (slot) then
			slot:delete()
			slot = nil
		end
	end
	
	if (self.staminaText) then
		self.staminaText:delete()
		self.staminaText = nil
	end
	
	if (self.intelligenceText) then
		self.intelligenceText:delete()
		self.intelligenceText = nil
	end
	
	if (self.armorText) then
		self.armorText:delete()
		self.armorText = nil
	end
	
	if (self.critText) then
		self.critText:delete()
		self.critText = nil
	end
end


function GUICharacterSlots_C:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUICharacterSlots_C was deleted.")
	end
end