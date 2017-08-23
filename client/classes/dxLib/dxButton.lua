dxButton = inherit(Class)

function dxButton:constructor(text, x, y, w, h, parent, relative, clickFunction)
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.text = text or ""
	self.defaultX = x or 0
	self.defaultY = y or 0
	self.defaultWidth = w or 0
	self.defaultHeight = h or 0
	self.parent = parent or nil
	self.isRelative = relative or true
	self.clickFunction = clickFunction or nil
	
	self.x = 0
	self.y = 0
	self.width = 0
	self.height = 0
	
	self.color = {r = 90, g = 220, b = 90}
	self.hoverColor = {r = 120, g = 255, b = 120}
	self.clickColor = {r = 45, g = 110, b = 45}
	self.borderColor = {r = 0, g = 0, b = 0}
	self.fontColor = {r = 255, g = 255, b = 255}
	self.shadowColor = {r = 0, g = 0, b = 0}
	self.shadowOffset = 1
	self.buttonColor = self.color
	
	self.borderSize = 2
	
	self.alpha = 255
	
	self.scale = 1
	self.font = "default-bold"
	self.alignX = "center"
	self.alignY = "center"
	self.clip = false
	self.wordBreak = false
	self.colorCoded = true
	self.rotation = 0
	self.rotationCenterX = 0
	self.rotationCenterY = 0
	
	self.mouseX = 0
	self.mouseY = 0
	
	self.postGUI = false
	self.subPixelPositioning = true
	
	self.isClicked = false
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("dxButton was loaded.")
	end
end


function dxButton:init()
	if (self.clickFunction) then
		
	end
end


function dxButton:update(deltaTime)
	self:calcValues()
	
	-- draw bg
	dxDrawRectangle(self.x, self.y, self.width, self.height, tocolor(self.buttonColor.r, self.buttonColor.g, self.buttonColor.b, self.alpha), self.postGUI, self.subPixelPositioning)
	
	-- draw border
	dxDrawLine (self.x, self.y, self.x + self.width, self.y, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)
	dxDrawLine (self.x + self.width, self.y, self.x + self.width, self.y + self.height, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)
	dxDrawLine (self.x + self.width, self.y + self.height, self.x, self.y + self.height, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)
	dxDrawLine (self.x, self.y + self.height, self.x, self.y, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)
	
	-- draw text
	dxDrawText(removeHEXColorCode(self.text), self.x + self.shadowOffset, self.y + self.shadowOffset, self.x + self.width + self.shadowOffset, self.y + self.height + self.shadowOffset, tocolor(self.shadowColor.r, self.shadowColor.g, self.shadowColor.b, self.alpha), self.scale, self.font, self.alignX, self.alignY, self.clip, self.wordBreak, self.postGUI, self.colorCoded, self.subPixelPositioning, self.rotation, self.rotationCenterX, self.rotationCenterY)
	dxDrawText(self.text, self.x, self.y, self.x + self.width, self.y + self.height, tocolor(self.fontColor.r, self.fontColor.g, self.fontColor.b, self.alpha), self.scale, self.font, self.alignX, self.alignY, self.clip, self.wordBreak, self.postGUI, self.colorCoded, self.subPixelPositioning, self.rotation, self.rotationCenterX, self.rotationCenterY)

	if (isCursorShowing() == true) then
		local mx, my = getCursorPosition()
		
		self.mouseX, self.mouseY = mx * self.screenWidth, my * self.screenHeight
		
		if (self:isCursorInside() == true) then
			if (getKeyState("mouse1") == true) then
				self.buttonColor = self.clickColor
				
				if (self.isClicked == false) then
					if (self.clickFunction) then
						self.clickFunction()
					end
				end
				
				self.isClicked = true
			else
				self.buttonColor = self.hoverColor
				self.isClicked = false
			end
		else
			self.buttonColor = self.color
			self.isClicked = false
		end
	end
end


function dxButton:calcValues()
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


function dxButton:isCursorInside()
	if (self.mouseX > self.x) and (self.mouseX < self.x + self.width) then
		if (self.mouseY > self.y) and (self.mouseY < self.y + self.height) then
			return true
		end
	end

	return false
end


function dxButton:setPosition(x, y)
	if (x) and (y) then
		self.defaultX = x
		self.defaultY = y
	end
end


function dxButton:getPosition()
	return self.defaultX, self.defaultY
end


function dxButton:setSize(w, h)
	if (w) and (h) then
		self.defaultWidth = w
		self.defaultHeight = h
	end
end


function dxButton:getSize()
	return self.defaultWidth, self.defaultHeight
end


function dxButton:setParent(parent)
	if (parent) then
		self.parent = parent
	end
end


function dxButton:getParent()
	return self.parent
end


function dxButton:setBackgroundColor(r, g, b)
	if (r) and (g) and (b) then
		self.color.r = r
		self.color.g = g
		self.color.b = b
	end
end


function dxButton:getBackgroundColor()
	return self.color
end


function dxButton:setBorderColor(r, g, b)
	if (r) and (g) and (b) then
		self.borderColor.r = r
		self.borderColor.g = g
		self.borderColor.b = b
	end
end


function dxButton:getBorderColor()
	return self.borderColor
end


function dxButton:setShadowColor(r, g, b)
	if (r) and (g) and (b) then
		self.shadowColor.r = r
		self.shadowColor.g = g
		self.shadowColor.b = b
	end
end


function dxButton:getShadowColor()
	return self.shadowColor
end


function dxButton:setShadowOffset(offset)
	if (offset) then
		self.shadowOffset = offset
	end
end


function dxButton:getShadowOffset()
	return self.shadowOffset
end


function dxButton:setBorderSize(size)
	if (size) then
		self.borderSize = size
	end
end


function dxButton:getBorderSize()
	return self.borderSize
end


function dxButton:setAlpha(alpha)
	if (alpha) then
		self.alpha = alpha
	end
end


function dxButton:getAlpha()
	return self.alpha
end


function dxButton:setScale(scale)
	if (scale) then
		self.scale = scale
	end
end


function dxButton:getScale()
	return self.scale
end


function dxButton:setPostGUI(postGUI)
	self.postGUI = postGUI
end


function dxButton:getPostGUI()
	return self.postGUI
end


function dxButton:setSubPixelPositioning(subPixelPositioning)
	self.subPixelPositioning = subPixelPositioning
end


function dxButton:getSubPixelPositioning()
	return self.subPixelPositioning
end


function dxButton:clear()

end


function dxButton:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("dxButton was deleted.")
	end
end