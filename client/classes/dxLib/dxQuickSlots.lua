dxQuickSlots = inherit(Class)

function dxQuickSlots:constructor(x, y, w, h, parent, relative)

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
	
	self.alpha = 255
	
	self.postGUI = false
	self.subPixelPositioning = true
	
	self.slots = 10
	
	self.mouseX = 0
	self.mouseY = 0
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("dxQuickSlots was loaded.")
	end
end


function dxQuickSlots:init()

end


function dxQuickSlots:update(deltaTime)
	self:calcValues()
	
	dxDrawRectangle(self.x, self.y, self.width, self.height, tocolor(15, 15, 15, 200), self.postGUI, self.subPixelPositioning)
	
	if (isCursorShowing() == true) then
		local mx, my = getCursorPosition()
		
		self.mouseX, self.mouseY = mx * self.screenWidth, my * self.screenHeight
		
		if (self:isCursorInside() == true) then
		
		end
	end
end


function dxQuickSlots:calcValues()
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


function dxQuickSlots:isCursorInside()
	if (self.mouseX > self.x) and (self.mouseX < self.x + self.width) then
		if (self.mouseY > self.y) and (self.mouseY < self.y + self.height) then
			return true
		end
	end

	return false
end


function dxQuickSlots:setPosition(x, y)
	if (x) and (y) then
		self.defaultX = x
		self.defaultY = y
	end
end


function dxQuickSlots:getPosition()
	return self.defaultX, self.defaultY
end


function dxQuickSlots:setSize(w, h)
	if (w) and (h) then
		self.defaultWidth = w
		self.defaultHeight = h
	end
end


function dxQuickSlots:getSize()
	return self.defaultWidth, self.defaultHeight
end


function dxQuickSlots:setParent(parent)
	if (parent) then
		self.parent = parent
	end
end


function dxQuickSlots:getParent()
	return self.parent
end


function dxQuickSlots:setSlots(slots)
	if (slots) then
		self.slots = slots
	end
end


function dxQuickSlots:getSlots()
	return self.slots
end


function dxQuickSlots:setPostGUI(postGUI)
	self.postGUI = postGUI
end


function dxQuickSlots:getPostGUI()
	return self.postGUI
end


function dxQuickSlots:setSubPixelPositioning(subPixelPositioning)
	self.subPixelPositioning = subPixelPositioning
end


function dxQuickSlots:getSubPixelPositioning()
	return self.subPixelPositioning
end


function dxQuickSlots:clear()

end


function dxQuickSlots:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("dxQuickSlots was deleted.")
	end
end