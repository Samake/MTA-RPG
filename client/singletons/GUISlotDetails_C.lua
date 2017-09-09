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
	end
end


function GUISlotDetails_C:update(deltaTime)
	if (self.slotID) and (self.itemContainer) then
		self:calcValues()
		
		self.qualityColor = self.itemContainer:getColor()
		
		if (self.guiElements[1]) then
			self.guiElements[1]:setPosition(self.x, self.y)
			self.guiElements[1]:setSize(self.width, self.height)
		end
		
		if (self.guiElements[2]) then
			self.guiElements[2]:setText(self.itemContainer:getName())
			self.guiElements[2]:setFontColor(self.qualityColor.r, self.qualityColor.g, self.qualityColor.b)
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