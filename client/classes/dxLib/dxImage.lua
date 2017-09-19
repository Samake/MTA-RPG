dxImage = inherit(Class)

function dxImage:constructor(texture, x, y, w, h, parent, relative)
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()

	self.texture = texture or nil
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
	self.borderColor = {r = 45, g = 45, b = 45}
	self.shadowColor = {r = 0, g = 0, b = 0}
	self.shadowOffset = 1
	
	self.borderSize = 2
	
	self.alpha = 255
	
	self.scale = 1
	self.rotation = 0
	self.rotationCenterX = 0
	self.rotationCenterY = 0
	
	self.postGUI = false
	self.subPixelPositioning = true
	
	self.isClicked = false
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("dxImage was loaded.")
	end
end


function dxImage:init()
	self:calcValues()
end


function dxImage:update(deltaTime)
	self:calcValues()
	
	-- draw image
	if (self.texture) then
		dxDrawImage (self.x + self.shadowOffset, self.y + self.shadowOffset, self.width, self.height, self.texture, self.rotation, self.rotationCenterX, self.rotationCenterY, tocolor(self.shadowColor.r, self.shadowColor.g, self.shadowColor.b, self.alpha), self.postGUI)
		dxDrawImage (self.x, self.y, self.width, self.height, self.texture, self.rotation, self.rotationCenterX, self.rotationCenterY, tocolor(self.color.r, self.color.g, self.color.b, self.alpha), self.postGUI)
	end
	
	-- draw border
	dxDrawLine (self.x, self.y, self.x + self.width, self.y, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)
	dxDrawLine (self.x + self.width, self.y, self.x + self.width, self.y + self.height, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)
	dxDrawLine (self.x + self.width, self.y + self.height, self.x, self.y + self.height, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)
	dxDrawLine (self.x, self.y + self.height, self.x, self.y, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)
	
end


function dxImage:calcValues()
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


function dxImage:setTexture(texture)
	if (texture) then
		self.texture = texture
	end
end


function dxImage:getTexture()
	return self.texture
end


function dxImage:setPosition(x, y)
	if (x) and (y) then
		self.defaultX = x
		self.defaultY = y
	end
end


function dxImage:getPosition()
	return self.defaultX, self.defaultY
end


function dxImage:setSize(w, h)
	if (w) and (h) then
		self.defaultWidth = w
		self.defaultHeight = h
	end
end


function dxImage:getSize()
	return self.defaultWidth, self.defaultHeight
end


function dxImage:setParent(parent)
	if (parent) then
		self.parent = parent
	end
end


function dxImage:getParent()
	return self.parent
end


function dxImage:setColor(r, g, b)
	if (r) and (g) and (b) then
		self.color.r = r
		self.color.g = g
		self.color.b = b
	end
end


function dxImage:getColor()
	return self.color
end


function dxImage:setBorderColor(r, g, b)
	if (r) and (g) and (b) then
		self.borderColor.r = r
		self.borderColor.g = g
		self.borderColor.b = b
	end
end


function dxImage:getBorderColor()
	return self.borderColor
end


function dxImage:setBorderSize(size)
	if (size) then
		self.borderSize = size
	end
end


function dxImage:getBorderSize()
	return self.borderSize
end


function dxImage:setShadowColor(r, g, b)
	if (r) and (g) and (b) then
		self.shadowColor.r = r
		self.shadowColor.g = g
		self.shadowColor.b = b
	end
end


function dxImage:getShadowColor()
	return self.shadowColor
end


function dxImage:setShadowOffset(offset)
	if (offset) then
		self.shadowOffset = offset
	end
end


function dxImage:getShadowOffset()
	return self.shadowOffset
end


function dxImage:setAlpha(alpha)
	if (alpha) then
		self.alpha = alpha
	end
end


function dxImage:getAlpha()
	return self.alpha
end


function dxImage:setScale(scale)
	if (scale) then
		self.scale = scale
	end
end


function dxImage:getScale()
	return self.scale
end


function dxImage:setRotation(rotation)
	if (rotation) then
		self.rotation = rotation
	end
end


function dxImage:getRotation()
	return self.rotation
end


function dxImage:setRotationCenterX(rotationCenterX)
	if (rotationCenterX) then
		self.rotationCenterX = rotationCenterX
	end
end


function dxImage:getRotationCenterX()
	return self.rotationCenterX
end


function dxImage:setRotationCenterY(rotationCenterY)
	if (rotationCenterY) then
		self.rotationCenterY = rotationCenterY
	end
end


function dxImage:getRotationCenterY()
	return self.rotationCenterY
end


function dxImage:setPostGUI(postGUI)
	self.postGUI = postGUI
end


function dxImage:getPostGUI()
	return self.postGUI
end


function dxImage:setSubPixelPositioning(subPixelPositioning)
	self.subPixelPositioning = subPixelPositioning
end


function dxImage:getSubPixelPositioning()
	return self.subPixelPositioning
end


function dxImage:clear()

end


function dxImage:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("dxImage was deleted.")
	end
end