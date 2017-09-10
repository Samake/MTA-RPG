dxTextArea = inherit(Class)

function dxTextArea:constructor(text, x, y, w, h, parent, relative)

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
	
	self.fontColor = {r = 255, g = 255, b = 255}
	self.shadowColor = {r = 0, g = 0, b = 0}
	self.shadowOffset = 1

	self.alpha = 255

	self.scale = 1.0
	self.alignX = "left"
	self.alignY = "top"
	self.font = "default-bold"
	
	self.postGUI = false
	self.subPixelPositioning = true
	
	self.mouseX = 0
	self.mouseY = 0
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("dxTextArea was loaded.")
	end
end


function dxTextArea:init()
	self:calcValues()
end


function dxTextArea:update(deltaTime)
	self:calcValues()

	dxDrawText(removeHEXColorCode(self.text), self.x + self.shadowOffset, self.y + self.shadowOffset, self.x + self.width + self.shadowOffset, self.y + self.height + self.shadowOffset, tocolor(self.shadowColor.r, self.shadowColor.g, self.shadowColor.b, self.alpha), self.scale, self.font, self.alignX, self.alignY, true, true, self.postGUI, false, self.subPixelPositioning)	
	dxDrawText(self.text, self.x, self.y, self.x + self.width, self.y + self.height, tocolor(self.fontColor.r, self.fontColor.g, self.fontColor.b, self.alpha), self.scale, self.font, self.alignX, self.alignY, true, true, self.postGUI, true, self.subPixelPositioning)	
end


function dxTextArea:calcValues()
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


function dxTextArea:isCursorInside()
	if (self.mouseX > self.x) and (self.mouseX < self.x + self.width) then
		if (self.mouseY > self.y) and (self.mouseY < self.y + self.height) then
			return true
		end
	end

	return false
end


function dxTextArea:setText(text)
	if (text) then
		self.text = text
	end
end


function dxTextArea:getText()
	return self.text
end


function dxTextArea:setPosition(x, y)
	if (x) and (y) then
		self.defaultX = x
		self.defaultY = y
	end
end


function dxTextArea:getPosition()
	return self.defaultX, self.defaultY
end


function dxTextArea:setSize(w, h)
	if (w) and (h) then
		self.defaultWidth = w
		self.defaultHeight = h
	end
end


function dxTextArea:getSize()
	return self.defaultWidth, self.defaultHeight
end


function dxTextArea:setParent(parent)
	if (parent) then
		self.parent = parent
	end
end


function dxTextArea:getParent()
	return self.parent
end


function dxTextArea:setFontColor(r, g, b)
	if (r) and (g) and (b) then
		self.fontColor.r = r
		self.fontColor.g = g
		self.fontColor.b = b
	end
end


function dxTextArea:getFontColor()
	return self.fontColor
end


function dxTextArea:setShadowColor(r, g, b)
	if (r) and (g) and (b) then
		self.shadowColor.r = r
		self.shadowColor.g = g
		self.shadowColor.b = b
	end
end


function dxTextArea:getShadowColor()
	return self.shadowColor
end


function dxTextArea:setShadowOffset(offset)
	if (offset) then
		self.shadowOffset = offset
	end
end


function dxTextArea:getShadowOffset()
	return self.shadowOffset
end


function dxTextArea:setAlpha(alpha)
	if (alpha) then
		self.alpha = alpha
	end
end


function dxTextArea:getAlpha()
	return self.alpha
end


function dxTextArea:setScale(scale)
	if (scale) then
		self.scale = scale
	end
end


function dxTextArea:getScale()
	return self.scale
end


function dxTextArea:setAlignX(alignX)
	if (alignX) then
		self.alignX = alignX
	end
end


function dxTextArea:getAlignX()
	return self.alignX
end


function dxTextArea:setAlignY(alignY)
	if (alignY) then
		self.alignY = alignY
	end
end


function dxTextArea:getAlignY()
	return self.alignY
end


function dxTextArea:setFont(font)
	if (font) then
		self.font = font
	end
end


function dxTextArea:getFont()
	return self.font
end


function dxTextArea:setPostGUI(postGUI)
	self.postGUI = postGUI
end


function dxTextArea:getPostGUI()
	return self.postGUI
end


function dxTextArea:setSubPixelPositioning(subPixelPositioning)
	self.subPixelPositioning = subPixelPositioning
end


function dxTextArea:getSubPixelPositioning()
	return self.subPixelPositioning
end


function dxTextArea:clear()
	
end


function dxTextArea:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("dxTextArea was deleted.")
	end
end