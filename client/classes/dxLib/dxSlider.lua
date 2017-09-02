dxSlider = inherit(Class)

function dxSlider:constructor(text, x, y, w, h, parent, relative)
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.text = text or ""
	self.defaultX = x or 0
	self.defaultY = y or 0
	self.defaultWidth = w or 0
	self.defaultHeight = h or 0
	self.parent = parent or nil
	self.isRelative = relative or true
	
	self.x = 0
	self.y = 0
	self.width = 0
	self.height = 0
	
	self.color = {r = 255, g = 255, b = 255}
	self.barBGColor = {r = 75, g = 75, b = 75}
	self.barColor = {r = 95, g = 220, b = 55}
	self.shadowColor = {r = 0, g = 0, b = 0}
	self.shadowOffset = 1
	
	self.alpha = 255
	
	self.scale = 1
	self.font = "default-bold"
	self.alignX = "center"
	self.alignY = "top"
	self.clip = false
	self.wordBreak = false
	self.colorCoded = true
	self.rotation = 0
	self.rotationCenterX = 0
	self.rotationCenterY = 0
	
	self.postGUI = false
	self.subPixelPositioning = true
	
	self.sliderValue = 0.5
	self.barLength = 0
	
	self.mouseX = 0
	self.mouseY = 0
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("dxSlider was loaded.")
	end
end


function dxSlider:init()
	self:calcValues()
end


function dxSlider:update(deltaTime)
	
	self:calcValues()
	
	self.barLength = (self.width / 1.0) * self.sliderValue
	
	-- draw Text
	dxDrawText(removeHEXColorCode(self.text), self.x + self.shadowOffset, self.y + self.shadowOffset, self.x + self.width + self.shadowOffset, self.y + self.height + self.shadowOffset, tocolor(self.shadowColor.r, self.shadowColor.g, self.shadowColor.b, self.alpha), self.scale, self.font, self.alignX, self.alignY, self.clip, self.wordBreak, self.postGUI, self.colorCoded, self.subPixelPositioning, self.rotation, self.rotationCenterX, self.rotationCenterY)
	dxDrawText(self.text, self.x, self.y, self.x + self.width, self.y + self.height, tocolor(self.color.r, self.color.g, self.color.b, self.alpha), self.scale, self.font, self.alignX, self.alignY, self.clip, self.wordBreak, self.postGUI, self.colorCoded, self.subPixelPositioning, self.rotation, self.rotationCenterX, self.rotationCenterY)

	-- draw slider
	dxDrawRectangle(self.x, self.y  + (self.height / 2), self.width, self.height / 2, tocolor(self.barBGColor.r, self.barBGColor.g, self.barBGColor.b, self.alpha), self.postGUI, self.subPixelPositioning)
	dxDrawRectangle(self.x, self.y  + (self.height / 2), self.barLength, self.height / 2, tocolor(self.barColor.r, self.barColor.g, self.barColor.b, self.alpha), self.postGUI, self.subPixelPositioning)
	
	if (self:isCursorInside() == true) then
		if (getKeyState("mouse1") == true) then
			self:setValue((1.0 / self.width) * (self.mouseX - self.x))
		end
	end
end


function dxSlider:calcValues()
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


function dxSlider:isCursorInside()
	if (self.mouseX > self.x) and (self.mouseX < self.x + self.width) then
		if (self.mouseY > self.y + self.height / 2) and (self.mouseY < self.y + self.height) then
			return true
		end
	end

	return false
end


function dxSlider:setText(text)
	if (text) then
		self.text = text
	end
end


function dxSlider:getText()
	return self.text
end


function dxSlider:setPosition(x, y)
	if (x) and (y) then
		self.defaultX = x
		self.defaultY = y
	end
end


function dxSlider:getPosition()
	return self.defaultX, self.defaultY
end


function dxSlider:setSize(w, h)
	if (w) and (h) then
		self.defaultWidth = w
		self.defaultHeight = h
	end
end


function dxSlider:getSize()
	return self.defaultWidth, self.defaultHeight
end


function dxSlider:setParent(parent)
	if (parent) then
		self.parent = parent
	end
end


function dxSlider:getParent()
	return self.parent
end


function dxSlider:setColor(r, g, b)
	if (r) and (g) and (b) then
		self.color.r = r
		self.color.g = g
		self.color.b = b
	end
end


function dxSlider:getColor()
	return self.color
end


function dxSlider:setShadowColor(r, g, b)
	if (r) and (g) and (b) then
		self.shadowColor.r = r
		self.shadowColor.g = g
		self.shadowColor.b = b
	end
end


function dxSlider:getShadowColor()
	return self.shadowColor
end


function dxSlider:setBarBGColor(r, g, b)
	if (r) and (g) and (b) then
		self.barBGColor.r = r
		self.barBGColor.g = g
		self.barBGColor.b = b
	end
end


function dxSlider:getBarBGColor()
	return self.barBGColor
end


function dxSlider:setBarColor(r, g, b)
	if (r) and (g) and (b) then
		self.barColor.r = r
		self.barColor.g = g
		self.barColor.b = b
	end
end


function dxSlider:getBarColor()
	return self.barColor
end


function dxSlider:setShadowOffset(offset)
	if (offset) then
		self.shadowOffset = offset
	end
end


function dxSlider:getShadowOffset()
	return self.shadowOffset
end


function dxSlider:setAlpha(alpha)
	if (alpha) then
		self.alpha = alpha
	end
end


function dxSlider:getAlpha()
	return self.alpha
end


function dxSlider:setAlignX(alignX)
	if (alignX) then
		self.alignX = alignX
	end
end


function dxSlider:getAlignX()
	return self.alignX
end


function dxSlider:setAlignY(alignY)
	if (alignY) then
		self.alignY = alignY
	end
end


function dxSlider:getAlignY()
	return self.alignY
end


function dxSlider:setValue(value)
	if (value) then
		self.sliderValue = value
		
		if (self.sliderValue < 0) then
			self.sliderValue = 0
		end
		
		if (self.sliderValue > 1) then
			self.sliderValue  = 1
		end
	end
end


function dxSlider:getValue()
	return self.sliderValue
end


function dxSlider:setPostGUI(postGUI)
	self.postGUI = postGUI
end


function dxSlider:getPostGUI()
	return self.postGUI
end


function dxSlider:setSubPixelPositioning(subPixelPositioning)
	self.subPixelPositioning = subPixelPositioning
end


function dxSlider:getSubPixelPositioning()
	return self.subPixelPositioning
end


function dxSlider:clear()

end


function dxSlider:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("dxSlider was deleted.")
	end
end