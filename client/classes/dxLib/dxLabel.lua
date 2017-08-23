dxLabel = inherit(Class)

function dxLabel:constructor(text, x, y, w, h, parent, relative)
	
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
	self.shadowColor = {r = 0, g = 0, b = 0}
	self.shadowOffset = 1
	
	self.alpha = 255
	
	self.scale = 1
	self.font = "default-bold"
	self.alignX = "left"
	self.alignY = "center"
	self.clip = false
	self.wordBreak = false
	self.colorCoded = true
	self.rotation = 0
	self.rotationCenterX = 0
	self.rotationCenterY = 0
	
	self.postGUI = false
	self.subPixelPositioning = true
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("dxLabel was loaded.")
	end
end


function dxLabel:init()

end


function dxLabel:update(deltaTime)
	self:calcValues()
	
	dxDrawText(removeHEXColorCode(self.text), self.x + self.shadowOffset, self.y + self.shadowOffset, self.x + self.width + self.shadowOffset, self.y + self.height + self.shadowOffset, tocolor(self.shadowColor.r, self.shadowColor.g, self.shadowColor.b, self.alpha), self.scale, self.font, self.alignX, self.alignY, self.clip, self.wordBreak, self.postGUI, self.colorCoded, self.subPixelPositioning, self.rotation, self.rotationCenterX, self.rotationCenterY)
	dxDrawText(self.text, self.x, self.y, self.x + self.width, self.y + self.height, tocolor(self.color.r, self.color.g, self.color.b, self.alpha), self.scale, self.font, self.alignX, self.alignY, self.clip, self.wordBreak, self.postGUI, self.colorCoded, self.subPixelPositioning, self.rotation, self.rotationCenterX, self.rotationCenterY)
end


function dxLabel:calcValues()
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


function dxLabel:setText(text)
	if (text) then
		self.text = text
	end
end


function dxLabel:getText()
	return self.text
end


function dxLabel:setPosition(x, y)
	if (x) and (y) then
		self.defaultX = x
		self.defaultY = y
	end
end


function dxLabel:getPosition()
	return self.defaultX, self.defaultY
end


function dxLabel:setSize(w, h)
	if (w) and (h) then
		self.defaultWidth = w
		self.defaultHeight = h
	end
end


function dxLabel:getSize()
	return self.defaultWidth, self.defaultHeight
end


function dxLabel:setParent(parent)
	if (parent) then
		self.parent = parent
	end
end


function dxLabel:getParent()
	return self.parent
end


function dxLabel:setColor(r, g, b)
	if (r) and (g) and (b) then
		self.color.r = r
		self.color.g = g
		self.color.b = b
	end
end


function dxLabel:getColor()
	return self.color
end


function dxLabel:setShadowColor(r, g, b)
	if (r) and (g) and (b) then
		self.shadowColor.r = r
		self.shadowColor.g = g
		self.shadowColor.b = b
	end
end


function dxLabel:getShadowColor()
	return self.shadowColor
end


function dxLabel:setShadowOffset(offset)
	if (offset) then
		self.shadowOffset = offset
	end
end


function dxLabel:getShadowOffset()
	return self.shadowOffset
end


function dxLabel:setAlpha(alpha)
	if (alpha) then
		self.alpha = alpha
	end
end


function dxLabel:getAlpha()
	return self.alpha
end


function dxLabel:setAlignX(alignX)
	if (alignX) then
		self.alignX = alignX
	end
end


function dxLabel:getAlignX()
	return self.alignX
end


function dxLabel:setAlignY(alignY)
	if (alignY) then
		self.alignY = alignY
	end
end


function dxLabel:getAlignY()
	return self.alignY
end


function dxLabel:setScale(scale)
	if (scale) then
		self.scale = scale
	end
end


function dxLabel:getScale()
	return self.scale
end


function dxLabel:setPostGUI(postGUI)
	self.postGUI = postGUI
end


function dxLabel:getPostGUI()
	return self.postGUI
end


function dxLabel:setSubPixelPositioning(subPixelPositioning)
	self.subPixelPositioning = subPixelPositioning
end


function dxLabel:getSubPixelPositioning()
	return self.subPixelPositioning
end


function dxLabel:clear()

end


function dxLabel:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("dxLabel was deleted.")
	end
end