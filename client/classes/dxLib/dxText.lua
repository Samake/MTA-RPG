dxText = inherit(Class)

function dxText:constructor(text, x, y, w, h, parent, relative)

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
	
	self.postGUI = false
	self.subPixelPositioning = true
	
	self.mouseX = 0
	self.mouseY = 0
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("dxText was loaded.")
	end
end


function dxText:init()

end


function dxText:update(deltaTime)
	self:calcValues()

	dxDrawText(removeHEXColorCode(self.text), self.x + self.shadowOffset, self.y + self.shadowOffset, self.x + self.width + self.shadowOffset, self.y + self.height + self.shadowOffset, tocolor(self.shadowColor.r, self.shadowColor.g, self.shadowColor.b, self.alpha), self.scale, "default-bold", "center", "center", false, false, self.postGUI, false, self.subPixelPositioning)	
	dxDrawText(self.text, self.x, self.y, self.x + self.width, self.y + self.height, tocolor(self.fontColor.r, self.fontColor.g, self.fontColor.b, self.alpha), self.scale, "default-bold", "center", "center", false, false, self.postGUI, true, self.subPixelPositioning)	
end


function dxText:calcValues()
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


function dxText:isCursorInside()
	if (self.mouseX > self.x) and (self.mouseX < self.x + self.width) then
		if (self.mouseY > self.y) and (self.mouseY < self.y + self.height) then
			return true
		end
	end

	return false
end


function dxText:setText(text)
	if (text) then
		self.text = text
	end
end


function dxText:getText()
	return self.text
end


function dxText:setPosition(x, y)
	if (x) and (y) then
		self.defaultX = x
		self.defaultY = y
	end
end


function dxText:getPosition()
	return self.defaultX, self.defaultY
end


function dxText:setSize(w, h)
	if (w) and (h) then
		self.defaultWidth = w
		self.defaultHeight = h
	end
end


function dxText:getSize()
	return self.defaultWidth, self.defaultHeight
end


function dxText:setParent(parent)
	if (parent) then
		self.parent = parent
	end
end


function dxText:getParent()
	return self.parent
end


function dxText:setFontColor(r, g, b)
	if (r) and (g) and (b) then
		self.fontColor.r = r
		self.fontColor.g = g
		self.fontColor.b = b
	end
end


function dxText:getFontColor()
	return self.fontColor
end


function dxText:setShadowColor(r, g, b)
	if (r) and (g) and (b) then
		self.shadowColor.r = r
		self.shadowColor.g = g
		self.shadowColor.b = b
	end
end


function dxText:getShadowColor()
	return self.shadowColor
end


function dxText:setShadowOffset(offset)
	if (offset) then
		self.shadowOffset = offset
	end
end


function dxText:getShadowOffset()
	return self.shadowOffset
end


function dxText:setAlpha(alpha)
	if (alpha) then
		self.alpha = alpha
	end
end


function dxText:getAlpha()
	return self.alpha
end


function dxText:setScale(scale)
	if (scale) then
		self.scale = scale
	end
end


function dxText:getScale()
	return self.scale
end


function dxText:setPostGUI(postGUI)
	self.postGUI = postGUI
end


function dxText:getPostGUI()
	return self.postGUI
end


function dxText:setSubPixelPositioning(subPixelPositioning)
	self.subPixelPositioning = subPixelPositioning
end


function dxText:getSubPixelPositioning()
	return self.subPixelPositioning
end


function dxText:clear()
	
end


function dxText:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("dxText was deleted.")
	end
end