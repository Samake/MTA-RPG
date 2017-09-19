dxImageSection = inherit(Class)

function dxImageSection:constructor(texture, x, y, w, h, parent, relative)
	
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
	
	self.xCoord = 0
	self.yCoord = 0
	self.xSize = 0
	self.ySize = 0
	
	self.imageWidth = 0
	self.imageHeight = 0
	
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
		sendMessage("dxImageSection was loaded.")
	end
end


function dxImageSection:init()
	self:calcValues()
end


function dxImageSection:update(deltaTime)
	self:calcValues()
	
	-- draw image
	if (self.texture) then
		local u = self.imageWidth  * self.xCoord
		local v = self.imageHeight  * self.yCoord
		local uSize = self.imageWidth  * self.xSize
		local vSize = self.imageHeight  * self.ySize

		dxDrawImageSection(self.x + self.shadowOffset, self.y + self.shadowOffset, self.width, self.height, u, v, uSize, vSize, self.texture, self.rotation, self.rotationCenterX, self.rotationCenterY, tocolor(self.shadowColor.r, self.shadowColor.g, self.shadowColor.b, self.alpha), self.postGUI)
		dxDrawImageSection(self.x, self.y, self.width, self.height, u, v, uSize, vSize, self.texture, self.rotation, self.rotationCenterX, self.rotationCenterY, tocolor(self.color.r, self.color.g, self.color.b, self.alpha), self.postGUI)
	end
	
	-- draw border
	dxDrawLine (self.x, self.y, self.x + self.width, self.y, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)
	dxDrawLine (self.x + self.width, self.y, self.x + self.width, self.y + self.height, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)
	dxDrawLine (self.x + self.width, self.y + self.height, self.x, self.y + self.height, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)
	dxDrawLine (self.x, self.y + self.height, self.x, self.y, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)
	
end


function dxImageSection:calcValues()
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


function dxImageSection:setTexture(texture)
	if (texture) then
		self.texture = texture
	end
end


function dxImageSection:getTexture()
	return self.texture
end


function dxImageSection:setPosition(x, y)
	if (x) and (y) then
		self.defaultX = x
		self.defaultY = y
	end
end


function dxImageSection:getPosition()
	return self.defaultX, self.defaultY
end


function dxImageSection:setSize(w, h)
	if (w) and (h) then
		self.defaultWidth = w
		self.defaultHeight = h
	end
end


function dxImageSection:getSize()
	return self.defaultWidth, self.defaultHeight
end


function dxImageSection:setParent(parent)
	if (parent) then
		self.parent = parent
	end
end


function dxImageSection:getParent()
	return self.parent
end


function dxImageSection:setColor(r, g, b)
	if (r) and (g) and (b) then
		self.color.r = r
		self.color.g = g
		self.color.b = b
	end
end


function dxImageSection:getColor()
	return self.color
end


function dxImageSection:setBorderColor(r, g, b)
	if (r) and (g) and (b) then
		self.borderColor.r = r
		self.borderColor.g = g
		self.borderColor.b = b
	end
end


function dxImageSection:getBorderColor()
	return self.borderColor
end


function dxImageSection:setBorderSize(size)
	if (size) then
		self.borderSize = size
	end
end


function dxImageSection:getBorderSize()
	return self.borderSize
end


function dxImageSection:setShadowColor(r, g, b)
	if (r) and (g) and (b) then
		self.shadowColor.r = r
		self.shadowColor.g = g
		self.shadowColor.b = b
	end
end


function dxImageSection:getShadowColor()
	return self.shadowColor
end


function dxImageSection:setShadowOffset(offset)
	if (offset) then
		self.shadowOffset = offset
	end
end


function dxImageSection:getShadowOffset()
	return self.shadowOffset
end


function dxImageSection:setAlpha(alpha)
	if (alpha) then
		self.alpha = alpha
	end
end


function dxImageSection:getAlpha()
	return self.alpha
end


function dxImageSection:setScale(scale)
	if (scale) then
		self.scale = scale
	end
end


function dxImageSection:getScale()
	return self.scale
end


function dxImageSection:setRotation(rotation)
	if (rotation) then
		self.rotation = rotation
	end
end


function dxImageSection:getRotation()
	return self.rotation
end


function dxImageSection:setRotationCenterX(rotationCenterX)
	if (rotationCenterX) then
		self.rotationCenterX = rotationCenterX
	end
end


function dxImageSection:getRotationCenterX()
	return self.rotationCenterX
end


function dxImageSection:setRotationCenterY(rotationCenterY)
	if (rotationCenterY) then
		self.rotationCenterY = rotationCenterY
	end
end


function dxImageSection:getRotationCenterY()
	return self.rotationCenterY
end


function dxImageSection:setImageSection(xCoord, yCoord, xSize, ySize)
	if (xCoord) and (yCoord) and (xSize) and (ySize) then
	
		self.xCoord = xCoord
		self.yCoord = yCoord
		self.xSize = xSize
		self.ySize = ySize
	end
end


function dxImageSection:getImageSection()
	return self.xCoord, self.yCoord, self.xSize, self.ySize 
end


function dxImageSection:setImageSize(imageWidth, imageHeight)
	if (imageWidth) and (imageHeight) then
		self.imageWidth = imageWidth
		self.imageHeight = imageHeight
	end
end


function dxImageSection:getImageSize()
	return self.imageWidth, self.imageHeight
end


function dxImageSection:setPostGUI(postGUI)
	self.postGUI = postGUI
end


function dxImageSection:getPostGUI()
	return self.postGUI
end


function dxImageSection:setSubPixelPositioning(subPixelPositioning)
	self.subPixelPositioning = subPixelPositioning
end


function dxImageSection:getSubPixelPositioning()
	return self.subPixelPositioning
end


function dxImageSection:clear()

end


function dxImageSection:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("dxImageSection was deleted.")
	end
end