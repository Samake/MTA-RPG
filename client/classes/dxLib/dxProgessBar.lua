dxProgessBar = inherit(Class)

function dxProgessBar:constructor(x, y, w, h, parent, relative)

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.defaultX = x or 0
	self.defaultY = y or 0
	self.defaultWidth = w or 0
	self.defaultHeight = h or 0
	self.parent = parent or nil
	self.isRelative = relative or true
	
	self.text = "0 / 1000"
	
	self.x = 0
	self.y = 0
	self.width = 0
	self.height = 0
	
	self.color = {r = 90, g = 220, b = 90}
	self.backGroundColor = {r = 90, g = 90, b = 90}
	self.borderColor = {r = 0, g = 0, b = 0}
	self.fontColor = {r = 255, g = 255, b = 255}
	self.shadowColor = {r = 0, g = 0, b = 0}
	self.shadowOffset = 1
	
	self.borderOffset = 2
	self.borderSize = 2
	self.alpha = 255
	
	self.scale = 1.0
	
	self.postGUI = false
	self.subPixelPositioning = true
	
	self.mouseX = 0
	self.mouseY = 0
	
	self.value = 0
	self.currentValue = 0
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("dxProgessBar was loaded.")
	end
end


function dxProgessBar:init()
	self:calcValues()
end


function dxProgessBar:update(deltaTime)
	self:calcValues()

	-- draw all bg
	dxDrawRectangle(self.x, self.y, self.width, self.height, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.borderColor), self.postGUI, self.subPixelPositioning)
	
	-- draw bar bg
	dxDrawRectangle(self.x + self.borderSize, self.y + self.borderSize, self.width - self.borderSize * 2, self.height - self.borderSize * 2, tocolor(self.backGroundColor.r, self.backGroundColor.g, self.backGroundColor.b, self.alpha), self.postGUI, self.subPixelPositioning)

	-- draw progress bar
	dxDrawRectangle(self.x + self.borderSize, self.y + self.borderSize, (self.width - self.borderSize * 2) * self.value, self.height - self.borderSize * 2, tocolor(self.color.r, self.color.g, self.color.b, self.alpha * 0.5), self.postGUI, self.subPixelPositioning)
	dxDrawRectangle(self.x + self.borderSize, self.y + self.borderSize, (self.width - self.borderSize * 2) * self.currentValue, self.height - self.borderSize * 2, tocolor(self.color.r, self.color.g, self.color.b, self.alpha * 0.5), self.postGUI, self.subPixelPositioning)
	
	-- draw text
	dxDrawText(self.text, (self.x + self.borderSize) + self.shadowOffset, (self.y + self.borderSize) + self.shadowOffset, (self.x + self.width - self.borderSize * 2) + self.shadowOffset, (self.y + self.height - self.borderSize * 2) + self.shadowOffset, tocolor(self.shadowColor.r, self.shadowColor.g, self.shadowColor.b, self.alpha), self.scale, "default-bold", "center", "center", false, false, self.postGUI, true, self.subPixelPositioning)	
	dxDrawText(self.text, self.x + self.borderSize, self.y + self.borderSize, self.x + self.width - self.borderSize * 2, self.y + self.height - self.borderSize * 2, tocolor(self.fontColor.r, self.fontColor.g, self.fontColor.b, self.alpha), self.scale, "default-bold", "center", "center", false, false, self.postGUI, true, self.subPixelPositioning)	
end


function dxProgessBar:calcValues()
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
	
	if (self.currentValue < self.value) then
		self.currentValue = self.currentValue + 0.005
	end
	
	if (self.currentValue > self.value) then
		self.currentValue = self.currentValue - 0.005
	end
end


function dxProgessBar:isCursorInside()
	if (self.mouseX > self.x) and (self.mouseX < self.x + self.width) then
		if (self.mouseY > self.y) and (self.mouseY < self.y + self.height) then
			return true
		end
	end

	return false
end


function dxProgessBar:setText(text)
	if (text) then
		self.text = text
	end
end


function dxProgessBar:getText()
	return self.text
end


function dxProgessBar:setPosition(x, y)
	if (x) and (y) then
		self.defaultX = x
		self.defaultY = y
	end
end


function dxProgessBar:getPosition()
	return self.defaultX, self.defaultY
end


function dxProgessBar:setSize(w, h)
	if (w) and (h) then
		self.defaultWidth = w
		self.defaultHeight = h
	end
end


function dxProgessBar:getSize()
	return self.defaultWidth, self.defaultHeight
end


function dxProgessBar:setParent(parent)
	if (parent) then
		self.parent = parent
	end
end


function dxProgessBar:getParent()
	return self.parent
end


function dxProgessBar:setColor(r, g, b)
	if (r) and (g) and (b) then
		self.color.r = r
		self.color.g = g
		self.color.b = b
	end
end


function dxProgessBar:getColor()
	return self.color
end


function dxProgessBar:setBackgroundColor(r, g, b)
	if (r) and (g) and (b) then
		self.backGroundColor.r = r
		self.backGroundColor.g = g
		self.backGroundColor.b = b
	end
end


function dxProgessBar:getBackgroundColor()
	return self.backGroundColor
end


function dxProgessBar:setShadowColor(r, g, b)
	if (r) and (g) and (b) then
		self.shadowColor.r = r
		self.shadowColor.g = g
		self.shadowColor.b = b
	end
end


function dxProgessBar:getShadowColor()
	return self.shadowColor
end


function dxProgessBar:setShadowOffset(offset)
	if (offset) then
		self.shadowOffset = offset
	end
end


function dxProgessBar:getShadowOffset()
	return self.shadowOffset
end


function dxProgessBar:setBorderColor(r, g, b)
	if (r) and (g) and (b) then
		self.borderColor.r = r
		self.borderColor.g = g
		self.borderColor.b = b
	end
end


function dxProgessBar:getBorderColor()
	return self.borderColor
end


function dxProgessBar:setBorderSize(size)
	if (size) then
		self.borderSize = size
	end
end


function dxProgessBar:getBorderSize()
	return self.borderSize
end


function dxProgessBar:setAlpha(alpha)
	if (alpha) then
		self.alpha = alpha
	end
end


function dxProgessBar:getAlpha()
	return self.alpha
end


function dxProgessBar:setScale(scale)
	if (scale) then
		self.scale = scale
	end
end


function dxProgessBar:getScale()
	return self.scale
end


function dxProgessBar:setValue(value)
	if (value) then
		if (value >= 0) and (self.value <= 1) then
			self.value = value
		end
	end
end


function dxProgessBar:getValue()
	return self.value
end


function dxProgessBar:setPostGUI(postGUI)
	self.postGUI = postGUI
end


function dxProgessBar:getPostGUI()
	return self.postGUI
end


function dxProgessBar:setSubPixelPositioning(subPixelPositioning)
	self.subPixelPositioning = subPixelPositioning
end


function dxProgessBar:getSubPixelPositioning()
	return self.subPixelPositioning
end


function dxProgessBar:clear()
	
end


function dxProgessBar:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("dxProgessBar was deleted.")
	end
end