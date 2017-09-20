GUICharacterSlots_C = inherit(Class)

function GUICharacterSlots_C:constructor(x, y, w, h, parent, relative)
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.guiElements = {}
	
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
	self.backGroundColor = {r = 55, g = 55, b = 65}
	
	self.borderSize = 2
	
	self.alpha = 255
	
	self.postGUI = true
	self.subPixelPositioning = true
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUICharacterSlots_C was loaded.")
	end
end


function GUICharacterSlots_C:init()
	self:calcValues()
	
	self.guiElements[1] = dxImageSection:new(nil, 0.0, 0.0, 1.0, 1.0, self, true)
	self.guiElements[1]:setImageSize(self.screenWidth, self.screenHeight)
	self.guiElements[1]:setImageSection(0.3, 0.2, 0.4, 0.6)
	
	self.guiElements[2] = GUISlot_C:new("head", 0.425, 0.08, 0.15, 0.15, self, true)
	self.guiElements[2]:setCharacterSlot(true)
	self.guiElements[2]:setBackgroundColor(self.backGroundColor.r, self.backGroundColor.g, self.backGroundColor.b)
	self.guiElements[2]:setBorderColor(10, 10, 10)
	
	self.guiElements[3] = GUISlot_C:new("torso", 0.425, 0.325, 0.15, 0.15, self, true)
	self.guiElements[3]:setCharacterSlot(true)
	self.guiElements[3]:setBackgroundColor(self.backGroundColor.r, self.backGroundColor.g, self.backGroundColor.b)
	self.guiElements[3]:setBorderColor(10, 10, 10)
	
	self.guiElements[4] = GUISlot_C:new("legs", 0.425, 0.6, 0.15, 0.15, self, true)
	self.guiElements[4]:setCharacterSlot(true)
	self.guiElements[4]:setBackgroundColor(self.backGroundColor.r, self.backGroundColor.g, self.backGroundColor.b)
	self.guiElements[4]:setBorderColor(10, 10, 10)
	
	self.guiElements[5] = GUISlot_C:new("feet", 0.425, 0.845, 0.15, 0.15, self, true)
	self.guiElements[5]:setCharacterSlot(true)
	self.guiElements[5]:setBackgroundColor(self.backGroundColor.r, self.backGroundColor.g, self.backGroundColor.b)
	self.guiElements[5]:setBorderColor(10, 10, 10)
	
	self.guiElements[6] = GUISlot_C:new("leftHand", 0.18, 0.5, 0.15, 0.15, self, true)
	self.guiElements[6]:setCharacterSlot(true)
	self.guiElements[6]:setBackgroundColor(self.backGroundColor.r, self.backGroundColor.g, self.backGroundColor.b)
	self.guiElements[6]:setBorderColor(10, 10, 10)
	
	self.guiElements[7] = GUISlot_C:new("righthand", 0.67, 0.5, 0.15, 0.15, self, true)
	self.guiElements[7]:setCharacterSlot(true)
	self.guiElements[7]:setBackgroundColor(self.backGroundColor.r, self.backGroundColor.g, self.backGroundColor.b)
	self.guiElements[7]:setBorderColor(10, 10, 10)
	
	self.guiElements[8] = GUISlot_C:new("leftRing", 0.18, 0.405, 0.075, 0.075, self, true)
	self.guiElements[8]:setCharacterSlot(true)
	self.guiElements[8]:setBackgroundColor(self.backGroundColor.r, self.backGroundColor.g, self.backGroundColor.b)
	self.guiElements[8]:setBorderColor(10, 10, 10)
	
	self.guiElements[9] = GUISlot_C:new("rightRing", 0.745, 0.405, 0.075, 0.075, self, true)
	self.guiElements[9]:setCharacterSlot(true)
	self.guiElements[9]:setBackgroundColor(self.backGroundColor.r, self.backGroundColor.g, self.backGroundColor.b)
	self.guiElements[9]:setBorderColor(10, 10, 10)
	
	self.guiElements[10] = GUISlot_C:new("chain", 0.15, 0.08, 0.1, 0.1, self, true)
	self.guiElements[10]:setCharacterSlot(true)
	self.guiElements[10]:setBackgroundColor(self.backGroundColor.r, self.backGroundColor.g, self.backGroundColor.b)
	self.guiElements[10]:setBorderColor(10, 10, 10)
	
	self.guiElements[11] = dxText:new("STA: 0 (+ 0%)", 0.025, 0.85, 0.5, 0.03, self, true)
	self.guiElements[11]:setScale(0.85)
	self.guiElements[11]:setAlignX("left")

	self.guiElements[12] = dxText:new("INT: 0 (+ 0%)", 0.025, 0.88, 0.5, 0.03, self, true)
	self.guiElements[12]:setScale(0.85)
	self.guiElements[12]:setAlignX("left")
	
	self.guiElements[13] = dxText:new("ARMOR: 0 (+ 0%)", 0.025, 0.91, 0.5, 0.03, self, true)
	self.guiElements[13]:setScale(0.85)
	self.guiElements[13]:setAlignX("left")
	
	self.guiElements[14] = dxText:new("CRIT: 0 (+ 0%)", 0.025, 0.94, 0.5, 0.03, self, true)
	self.guiElements[14]:setScale(0.85)
	self.guiElements[14]:setAlignX("left")
end



function GUICharacterSlots_C:update(deltaTime)
	self:calcValues()
	self:drawBackground()
	
	if (self.guiElements[11]) then
		if (Player_C:getSingleton():getStamina()) and (Player_C:getSingleton():getCurrentStamina()) then
			local stamina = Player_C:getSingleton():getStamina()
			local currentStamina = Player_C:getSingleton():getCurrentStamina()
			local modifiedPercent = string.format("%.1f", ((100 / stamina) * currentStamina) - 100)
			self.guiElements[11]:setText("#EEEEEESTA: #EEEE44" .. currentStamina .. "#44EE44 (+" .. modifiedPercent .. "%)")
		end
	end
	
	if (self.guiElements[12]) then
		if (Player_C:getSingleton():getIntelligence()) and (Player_C:getSingleton():getCurrentIntelligence()) then
			local intelligence = Player_C:getSingleton():getIntelligence()
			local currentIntelligence = Player_C:getSingleton():getCurrentIntelligence()
			local modifiedPercent = string.format("%.1f", ((100 / intelligence) * currentIntelligence) - 100)
			self.guiElements[12]:setText("#EEEEEEINT: #EEEE44" .. currentIntelligence .. "#44EE44 (+" .. modifiedPercent .. "%)")
		end
	end
	
	if (self.guiElements[13]) then
		if (Player_C:getSingleton():getArmor()) and (Player_C:getSingleton():getCurrentArmor()) then
			local armor = Player_C:getSingleton():getArmor()
			local currentArmor = Player_C:getSingleton():getCurrentArmor()
			local modifiedPercent = string.format("%.1f", math.floor((currentArmor - armor) + 0.5))
			self.guiElements[13]:setText("#EEEEEEARMOR: #EEEE44" .. currentArmor .. "#44EE44 (+" .. modifiedPercent .. ")")
		end
	end
	
	if (self.guiElements[14]) then
		if (Player_C:getSingleton():getCritChance()) and (Player_C:getSingleton():getCurrentCritChance()) then
			local critChance = Player_C:getSingleton():getCritChance()
			local currentCritChance = Player_C:getSingleton():getCurrentCritChance()
			local modifiedPercent = string.format("%.1f", math.floor((currentCritChance - critChance) + 0.5))
			self.guiElements[14]:setText("#EEEEEECRIT: #EEEE44" .. currentCritChance .. "#44EE44 (+" .. modifiedPercent .. ")")
		end
	end
	
	for index, guiElement in pairs(self.guiElements) do
		if (guiElement) then
			guiElement:update(deltaTime)
		end
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

	if (Renderer_C:getSingleton():getPlayerCutScreenResult()) and (self.guiElements[1]) then
		self.guiElements[1]:setTexture(Renderer_C:getSingleton():getPlayerCutScreenResult())
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
	return self.guiElements
end


function GUICharacterSlots_C:clear()
	for index, slot in pairs(self.guiElements) do
		if (slot) then
			slot:delete()
			slot = nil
		end
	end
end


function GUICharacterSlots_C:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUICharacterSlots_C was deleted.")
	end
end