dxWindow = inherit(Class)

function dxWindow:constructor(x, y, w, h, parent, relative)
	
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
	
	self.color = {r = 0, g = 0, b = 0}
	self.borderColor = {r = 0, g = 0, b = 0}
	
	self.borderSize = 2
	
	self.alpha = 255
	
	self.postGUI = false
	self.subPixelPositioning = true
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("dxWindow was loaded.")
	end
end


function dxWindow:init()

end


function dxWindow:update(deltaTime)
	self:calcValues()
	
	-- draw bg
	dxDrawRectangle(self.x, self.y, self.width, self.height, tocolor(self.color.r, self.color.g, self.color.b, self.alpha), self.postGUI, self.subPixelPositioning)
	
	-- draw border
	dxDrawLine (self.x, self.y, self.x + self.width, self.y, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)
	dxDrawLine (self.x + self.width, self.y, self.x + self.width, self.y + self.height, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)
	dxDrawLine (self.x + self.width, self.y + self.height, self.x, self.y + self.height, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)
	dxDrawLine (self.x, self.y + self.height, self.x, self.y, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)
end


function dxWindow:calcValues()
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


function dxWindow:setPosition(x, y)
	if (x) and (y) then
		self.defaultX = x
		self.defaultY = y
	end
end


function dxWindow:getPosition()
	return self.defaultX, self.defaultY
end


function dxWindow:setSize(w, h)
	if (w) and (h) then
		self.defaultWidth = w
		self.defaultHeight = h
	end
end


function dxWindow:getSize()
	return self.defaultWidth, self.defaultHeight
end


function dxWindow:setParent(parent)
	if (parent) then
		self.parent = parent
	end
end


function dxWindow:getParent()
	return self.parent
end


function dxWindow:setBackgroundColor(r, g, b)
	if (r) and (g) and (b) then
		self.color.r = r
		self.color.g = g
		self.color.b = b
	end
end


function dxWindow:getBackgroundColor()
	return self.color
end


function dxWindow:setBorderColor(r, g, b)
	if (r) and (g) and (b) then
		self.borderColor.r = r
		self.borderColor.g = g
		self.borderColor.b = b
	end
end


function dxWindow:getBorderColor()
	return self.borderColor
end


function dxWindow:setBorderSize(size)
	if (size) then
		self.borderSize = size
	end
end


function dxWindow:getBorderSize()
	return self.borderSize
end


function dxWindow:setAlpha(alpha)
	if (alpha) then
		self.alpha = alpha
	end
end


function dxWindow:getAlpha()
	return self.alpha
end


function dxWindow:setPostGUI(postGUI)
	self.postGUI = postGUI
end


function dxWindow:getPostGUI()
	return self.postGUI
end


function dxWindow:setSubPixelPositioning(subPixelPositioning)
	self.subPixelPositioning = subPixelPositioning
end


function dxWindow:getSubPixelPositioning()
	return self.subPixelPositioning
end


function dxWindow:clear()

end


function dxWindow:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("dxWindow was deleted.")
	end
end