dxLine = inherit(Class)

function dxLine:constructor(x, y, w, h, parent, relative)

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
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
	
	self.size = 2
	
	self.postGUI = false
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("dxLine was loaded.")
	end
end


function dxLine:init()
	self:calcValues()
end


function dxLine:update(deltaTime)
	self:calcValues()
	
	dxDrawLine(self.x + self.shadowOffset, self.y + self.shadowOffset, self.x + self.width + self.shadowOffset, self.y + self.height + self.shadowOffset, tocolor(self.shadowColor.r, self.shadowColor.g, self.shadowColor.b, self.alpha), self.size, self.postGUI)
	dxDrawLine(self.x, self.y, self.x + self.width, self.y + self.height, tocolor(self.color.r, self.color.g, self.color.b, self.alpha), self.size, self.postGUI)
end


function dxLine:calcValues()
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


function dxLine:setPosition(x, y)
	if (x) and (y) then
		self.defaultX = x
		self.defaultY = y
	end
end


function dxLine:getPosition()
	return self.defaultX, self.defaultY
end


function dxLine:setSize(w, h)
	if (w) and (h) then
		self.defaultWidth = w
		self.defaultHeight = h
	end
end


function dxLine:getSize()
	return self.defaultWidth, self.defaultHeight
end


function dxLine:setParent(parent)
	if (parent) then
		self.parent = parent
	end
end


function dxLine:getParent()
	return self.parent
end


function dxLine:setColor(r, g, b)
	if (r) and (g) and (b) then
		self.color.r = r
		self.color.g = g
		self.color.b = b
	end
end


function dxLine:getColor()
	return self.color
end


function dxLine:setShadowColor(r, g, b)
	if (r) and (g) and (b) then
		self.shadowColor.r = r
		self.shadowColor.g = g
		self.shadowColor.b = b
	end
end


function dxLine:getShadowColor()
	return self.shadowColor
end


function dxLine:setShadowOffset(offset)
	if (offset) then
		self.shadowOffset = offset
	end
end


function dxLine:getShadowOffset()
	return self.shadowOffset
end


function dxLine:setAlpha(alpha)
	if (alpha) then
		self.alpha = alpha
	end
end


function dxLine:getAlpha()
	return self.alpha
end


function dxLine:setSize(size)
	if (size) then
		self.size = size
	end
end


function dxLine:getSize()
	return self.size
end


function dxLine:setPostGUI(postGUI)
	self.postGUI = postGUI
end


function dxLine:getPostGUI()
	return self.postGUI
end


function dxLine:setSubPixelPositioning(subPixelPositioning)
	self.subPixelPositioning = subPixelPositioning
end


function dxLine:getSubPixelPositioning()
	return self.subPixelPositioning
end


function dxLine:clear()
	
end


function dxLine:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("dxLine was deleted.")
	end
end