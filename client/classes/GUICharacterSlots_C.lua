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
end



function GUICharacterSlots_C:update(deltaTime)
	self:calcValues()
	self:drawBackground()
	
	for index, slot in pairs(self.slots) do
		if (slot) then
			slot:update(deltaTime)
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
end


function GUICharacterSlots_C:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUICharacterSlots_C was deleted.")
	end
end