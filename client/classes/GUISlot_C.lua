GUISlot_C = inherit(Class)

function GUISlot_C:constructor(id, x, y, w, h, parent, relative)
	
	self.id = id
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
	self.borderColor = {r = 90, g = 90, b = 90}
	self.qualityColor = {r = 255, g = 255, b = 255}
	self.hoverColor = {r = 128, g = 128, b = 128}
	
	self.borderSize = 2
	
	self.alpha = 255
	
	self.mouseX = 0
	self.mouseY = 0
	
	self.postGUI = true
	self.subPixelPositioning = true
	
	self.item = nil
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUISlot_C " .. self.id .. " was loaded.")
	end
end


function GUISlot_C:init()
	self:calcValues()
end



function GUISlot_C:update(deltaTime)
	self:calcValues()
	
	-- draw bg
	dxDrawRectangle(self.finalX, self.finalY, self.finalWidth, self.finalHeight, tocolor(self.color.r, self.color.g, self.color.b, self.alpha), self.postGUI, self.subPixelPositioning)
	
	-- draw border
	if (self:isCursorInside() == true) then
		dxDrawLine(self.finalX, self.finalY, self.finalX + self.finalWidth, self.finalY, tocolor(self.hoverColor.r, self.hoverColor.g, self.hoverColor.b, self.alpha), self.borderSize, self.postGUI)
		dxDrawLine(self.finalX + self.finalWidth, self.finalY, self.finalX + self.finalWidth, self.finalY + self.finalHeight, tocolor(self.hoverColor.r, self.hoverColor.g, self.hoverColor.b, self.alpha), self.borderSize, self.postGUI)
		dxDrawLine(self.finalX + self.finalWidth, self.finalY + self.finalHeight, self.finalX, self.finalY + self.finalHeight, tocolor(self.hoverColor.r, self.hoverColor.g, self.hoverColor.b, self.alpha), self.borderSize, self.postGUI)
		dxDrawLine(self.finalX, self.finalY + self.finalHeight, self.finalX, self.finalY, tocolor(self.hoverColor.r, self.hoverColor.g, self.hoverColor.b, self.alpha), self.borderSize, self.postGUI)
	else
		if (self.item) then
			self.qualityColor = self.item.color
		else
			self.qualityColor = self.borderColor
		end
		
		dxDrawLine(self.finalX, self.finalY, self.finalX + self.finalWidth, self.finalY, tocolor(self.qualityColor.r, self.qualityColor.g, self.qualityColor.b, self.alpha), self.borderSize, self.postGUI)
		dxDrawLine(self.finalX + self.finalWidth, self.finalY, self.finalX + self.finalWidth, self.finalY + self.finalHeight, tocolor(self.qualityColor.r, self.qualityColor.g, self.qualityColor.b, self.alpha), self.borderSize, self.postGUI)
		dxDrawLine(self.finalX + self.finalWidth, self.finalY + self.finalHeight, self.finalX, self.finalY + self.finalHeight, tocolor(self.qualityColor.r, self.qualityColor.g, self.qualityColor.b, self.alpha), self.borderSize, self.postGUI)
		dxDrawLine(self.finalX, self.finalY + self.finalHeight, self.finalX, self.finalY, tocolor(self.qualityColor.r, self.qualityColor.g, self.qualityColor.b, self.alpha), self.borderSize, self.postGUI)
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


function GUISlot_C:clear()

end


function GUISlot_C:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUISlot_C " .. self.id .. " was deleted.")
	end
end