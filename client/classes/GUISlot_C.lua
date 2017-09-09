GUISlot_C = inherit(Class)

function GUISlot_C:constructor(slotID, x, y, w, h, parent, relative)
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.slotID = slotID
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
	
	self.finalX = self.defaultX
	self.finalY = self.defaultY
	self.finalWidth = self.defaultWidth
	self.finalHeight = self.defaultHeight
	
	self.color = {r = 25, g = 25, b = 25}
	self.shadowColor = {r = 15, g = 15, b = 15}
	self.borderColor = {r = 90, g = 90, b = 90}
	self.qualityColor = {r = 255, g = 255, b = 255}
	self.hoverColor = {r = 200, g = 200, b = 90}
	self.fontColor = {r = 200, g = 200, b = 90}
	
	self.shadowOffset = 1
	self.borderSize = 2
	
	self.alpha = Settings.guiAlpha
	
	self.mouseX = 0
	self.mouseY = 0
	
	self.postGUI = true
	self.subPixelPositioning = true
	
	self.itemContainer = nil
	self.count = 0
	
	self.characterSlot = false
	self.showDetails = false
	self.isDetailsStarted = false
	
	self.startTick = 0
	self.currentTick = 0
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUISlot_C " .. self.slotID .. " was loaded.")
	end
end


function GUISlot_C:init()
	self:calcValues()
end


function GUISlot_C:update(deltaTime)
	self:calcValues()
	
	self.currentTick = getTickCount()
	
	-- draw bg
	dxDrawRectangle(self.finalX, self.finalY, self.finalWidth, self.finalHeight, tocolor(self.color.r, self.color.g, self.color.b, self.alpha), self.postGUI, self.subPixelPositioning)
	
	-- draw Content
	if (self.itemContainer) then
		if (self.itemContainer:getTexture()) then
			dxDrawImage(self.finalX, self.finalY, self.finalWidth, self.finalHeight, self.itemContainer:getTexture(), 0, 0, 0, tocolor(220, 220, 220,self.alpha), self.postGUI)
		end
		
		if (self.itemContainer:getColor()) then
			self.qualityColor = self.itemContainer:getColor()
		else
			self.qualityColor = self.borderColor
		end
		
		if (self.itemContainer:getCount()) then
			self.count = self.itemContainer:getCount()
		else
			self.count = 0
		end
		
		if (self.itemContainer:isStackable() == true) then
			if (self.count > 0) then
				dxDrawText(self.count, self.finalX + self.shadowOffset, self.finalY + (self.finalHeight * 0.7) + self.shadowOffset, self.finalX + (self.finalWidth * 0.95) + self.shadowOffset, self.finalY + self.finalHeight + self.shadowOffset, tocolor(self.shadowColor.r, self.shadowColor.g, self.shadowColor.b, self.alpha), 0.8, "default-bold", "right", "center", false, false, self.postGUI, false, self.subPixelPositioning)	
				dxDrawText(self.count, self.finalX, self.finalY + (self.finalHeight * 0.7), self.finalX + (self.finalWidth * 0.95), self.finalY + self.finalHeight, tocolor(self.fontColor.r, self.fontColor.g, self.fontColor.b, self.alpha), 0.8, "default-bold", "right", "center", false, false, self.postGUI, true, self.subPixelPositioning)	
			end
		end
	else
		self.count = 0
		self.qualityColor = self.borderColor
	end
		
	-- draw border
	if (self:isCursorInside() == true) then
		dxDrawLine(self.finalX, self.finalY, self.finalX + self.finalWidth, self.finalY, tocolor(self.hoverColor.r, self.hoverColor.g, self.hoverColor.b, self.alpha), self.borderSize, self.postGUI)
		dxDrawLine(self.finalX + self.finalWidth, self.finalY, self.finalX + self.finalWidth, self.finalY + self.finalHeight, tocolor(self.hoverColor.r, self.hoverColor.g, self.hoverColor.b, self.alpha), self.borderSize, self.postGUI)
		dxDrawLine(self.finalX + self.finalWidth, self.finalY + self.finalHeight, self.finalX, self.finalY + self.finalHeight, tocolor(self.hoverColor.r, self.hoverColor.g, self.hoverColor.b, self.alpha), self.borderSize, self.postGUI)
		dxDrawLine(self.finalX, self.finalY + self.finalHeight, self.finalX, self.finalY, tocolor(self.hoverColor.r, self.hoverColor.g, self.hoverColor.b, self.alpha), self.borderSize, self.postGUI)
	else
		dxDrawLine(self.finalX, self.finalY, self.finalX + self.finalWidth, self.finalY, tocolor(self.qualityColor.r, self.qualityColor.g, self.qualityColor.b, self.alpha * 0.5), self.borderSize, self.postGUI)
		dxDrawLine(self.finalX + self.finalWidth, self.finalY, self.finalX + self.finalWidth, self.finalY + self.finalHeight, tocolor(self.qualityColor.r, self.qualityColor.g, self.qualityColor.b, self.alpha * 0.5), self.borderSize, self.postGUI)
		dxDrawLine(self.finalX + self.finalWidth, self.finalY + self.finalHeight, self.finalX, self.finalY + self.finalHeight, tocolor(self.qualityColor.r, self.qualityColor.g, self.qualityColor.b, self.alpha * 0.5), self.borderSize, self.postGUI)
		dxDrawLine(self.finalX, self.finalY + self.finalHeight, self.finalX, self.finalY, tocolor(self.qualityColor.r, self.qualityColor.g, self.qualityColor.b, self.alpha * 0.5), self.borderSize, self.postGUI)
	end
	
	if (self:isCursorInside() == true) then
		if (getKeyState("mouse1") == true) then
			DragAndDrop_C:getSingleton():addStartSlot(self)
			self.showDetails = false
			self.isDetailsStarted = false
		else
			if (self.isDetailsStarted == false) then
				self.startTick = getTickCount()
				self.isDetailsStarted = true
			else
				if (self.currentTick > self.startTick + 350) then
					self.showDetails = true
				end
			end
		end
		
		DragAndDrop_C:getSingleton():addDestinationSlot(self)
	else
		self.showDetails = false
		self.isDetailsStarted = false
	end
	
	if (self.showDetails == true) then
		self:enableDetails()
	elseif (self.showDetails == false) then
		self:disableDetails()
	end
end


function GUISlot_C:calcValues()
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
	
	self.finalWidth = self.width * 0.95
	self.finalHeight = self.height * 0.95
	self.finalX = self.x + self.width * 0.025
	self.finalY = self.y + self.height * 0.025
end


function GUISlot_C:isCursorInside()
	if (self.mouseX > self.x) and (self.mouseX < self.x + self.width) then
		if (self.mouseY > self.y) and (self.mouseY < self.y + self.height) then
			return true
		end
	end

	return false
end


function GUISlot_C:enableDetails()
	if (self.itemContainer) then
		if (not self.details) then
			local w = self.finalWidth * 3
			local h = self.finalHeight * 4
			local x = (self.finalX + self.finalWidth / 2) - w / 2
			local y = self.finalY + self.finalHeight / 2
			
			GUISlotDetails_C:getSingleton():setSlotID(self.slotID)
			GUISlotDetails_C:getSingleton():setPosition(x, y)
			GUISlotDetails_C:getSingleton():setSize(w, h)
			GUISlotDetails_C:getSingleton():setAlpha(self.alpha)
			GUISlotDetails_C:getSingleton():setPostGUI(self.postGUI)
			GUISlotDetails_C:getSingleton():setItem(self.itemContainer)
		end
	end
end


function GUISlot_C:disableDetails()
	if (GUISlotDetails_C:getSingleton():getSlotID()) then
		if (GUISlotDetails_C:getSingleton():getSlotID() == self.slotID) then
			GUISlotDetails_C:getSingleton():setSlotID(nil)
		end
	end
end


function GUISlot_C:setPosition(x, y)
	if (x) and (y) then
		self.defaultX = x
		self.defaultY = y
	end
end


function GUISlot_C:getPosition()
	return self.defaultX, self.defaultY
end


function GUISlot_C:setSize(w, h)
	if (w) and (h) then
		self.defaultWidth = w
		self.defaultHeight = h
	end
end


function GUISlot_C:getSize()
	return self.defaultWidth, self.defaultHeight
end


function GUISlot_C:setParent(parent)
	if (parent) then
		self.parent = parent
	end
end


function GUISlot_C:getParent()
	return self.parent
end


function GUISlot_C:setBackgroundColor(r, g, b)
	if (r) and (g) and (b) then
		self.color.r = r
		self.color.g = g
		self.color.b = b
	end
end


function GUISlot_C:getBackgroundColor()
	return self.color
end


function GUISlot_C:setBorderColor(r, g, b)
	if (r) and (g) and (b) then
		self.borderColor.r = r
		self.borderColor.g = g
		self.borderColor.b = b
	end
end


function GUISlot_C:getBorderColor()
	return self.borderColor
end


function GUISlot_C:setQualityColor(r, g, b)
	if (r) and (g) and (b) then
		self.qualityColor.r = r
		self.qualityColor.g = g
		self.qualityColor.b = b
	end
end


function GUISlot_C:getQualityColor()
	return self.qualityColor
end


function GUISlot_C:setHoverColor(r, g, b)
	if (r) and (g) and (b) then
		self.hoverColor.r = r
		self.hoverColor.g = g
		self.hoverColor.b = b
	end
end


function GUISlot_C:getHoverColor()
	return self.hoverColor
end


function GUISlot_C:setBorderSize(size)
	if (size) then
		self.borderSize = size
	end
end


function GUISlot_C:getBorderSize()
	return self.borderSize
end


function GUISlot_C:setAlpha(alpha)
	if (alpha) then
		self.alpha = alpha
	end
end


function GUISlot_C:getAlpha()
	return self.alpha
end


function GUISlot_C:setPostGUI(postGUI)
	self.postGUI = postGUI
end


function GUISlot_C:getPostGUI()
	return self.postGUI
end


function GUISlot_C:setSubPixelPositioning(subPixelPositioning)
	self.subPixelPositioning = subPixelPositioning
end


function GUISlot_C:getSubPixelPositioning()
	return self.subPixelPositioning
end


function GUISlot_C:setItem(itemContainer)
	self.itemContainer = itemContainer
end


function GUISlot_C:getItem()
	return self.itemContainer
end

function GUISlot_C:setCharacterSlot(bool)
	self.characterSlot = bool
end


function GUISlot_C:isCharacterSlot()
	return self.characterSlot
end


function GUISlot_C:clear()
	self:disableDetails()
end


function GUISlot_C:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUISlot_C " .. self.slotID .. " was deleted.")
	end
end