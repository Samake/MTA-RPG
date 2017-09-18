GUIInventorySlots_C = inherit(Class)

function GUIInventorySlots_C:constructor(x, y, w, h, parent, relative)
	
	self.slots = {}
	
	self.defaultX = x or 0
	self.defaultY = y or 0
	self.defaultWidth = w or 0
	self.defaultHeight = h or 0
	self.parent = parent or nil
	self.isRelative = relative or true
	
	self.player = getLocalPlayer()
	
	self.x = self.defaultX
	self.y = self.defaultY
	self.width = self.defaultWidth
	self.height = self.defaultHeight
	
	self.color = {r = 15, g = 15, b = 15}
	self.borderColor = {r = 45, g = 45, b = 45}
	
	self.borderSize = 2
	
	self.alpha = 255
	
	self.mouseX = 0
	self.mouseY = 0
	
	self.horizontalSlots = 0
	self.verticalSlots = 0
	
	self.postGUI = true
	self.subPixelPositioning = true
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUIInventorySlots_C was loaded.")
	end
end


function GUIInventorySlots_C:init()
	self:calcValues()
	self:buildSlots()
end



function GUIInventorySlots_C:update(deltaTime)
	self:calcValues()
	self:drawBackground()
	
	for index, slot in pairs(self.slots) do
		if (slot) then
			slot:update(deltaTime)
		end
	end
end


function GUIInventorySlots_C:drawBackground()
	-- draw bg
	dxDrawRectangle(self.x, self.y, self.width, self.height, tocolor(self.color.r, self.color.g, self.color.b, self.alpha), self.postGUI, self.subPixelPositioning)
	
	-- draw border
	dxDrawLine(self.x, self.y, self.x + self.width, self.y, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)
	dxDrawLine(self.x + self.width, self.y, self.x + self.width, self.y + self.height, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)
	dxDrawLine(self.x + self.width, self.y + self.height, self.x, self.y + self.height, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)
	dxDrawLine(self.x, self.y + self.height, self.x, self.y, tocolor(self.borderColor.r, self.borderColor.g, self.borderColor.b, self.alpha), self.borderSize, self.postGUI)
end


function GUIInventorySlots_C:calcValues()
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
		
		self.mouseX, self.mouseY = ClickSystem_C:getSingleton():getPosition()
	end
end


function GUIInventorySlots_C:isCursorInside()
	if (self.mouseX > self.x) and (self.mouseX < self.x + self.width) then
		if (self.mouseY > self.y) and (self.mouseY < self.y + self.height) then
			return true
		end
	end

	return false
end


function GUIInventorySlots_C:buildSlots()
	self:destroySlots()
	
	for i = 1, self.horizontalSlots, 1 do
		for j = 1, self.verticalSlots, 1 do
			local slotID = i .. ":" .. j
			local w
			local h
			
			if (self.isRelative == true) then
				w = 1 / self.horizontalSlots
				h = 1 / self.verticalSlots
			else
				w = self.width / self.horizontalSlots
				h = self.height / self.verticalSlots
			end
			
			local x = 0 + w * (i - 1)
			local y = 0 + h * (j - 1)
			
			if (not self.slots[slotID]) then
				self.slots[slotID] = GUISlot_C:new(slotID, x, y, w, h, self, true)
			end
		end
	end
end


function GUIInventorySlots_C:destroySlots()
	for index, slot in pairs(self.slots) do
		if (slot) then
			slot:delete()
			slot = nil
		end
	end
end


function GUIInventorySlots_C:setPosition(x, y)
	if (x) and (y) then
		self.defaultX = x
		self.defaultY = y
	end
end


function GUIInventorySlots_C:getPosition()
	return self.defaultX, self.defaultY
end


function GUIInventorySlots_C:setSize(w, h)
	if (w) and (h) then
		self.defaultWidth = w
		self.defaultHeight = h
	end
end


function GUIInventorySlots_C:getSize()
	return self.defaultWidth, self.defaultHeight
end


function GUIInventorySlots_C:setParent(parent)
	if (parent) then
		self.parent = parent
	end
end


function GUIInventorySlots_C:getParent()
	return self.parent
end


function GUIInventorySlots_C:setBackgroundColor(r, g, b)
	if (r) and (g) and (b) then
		self.color.r = r
		self.color.g = g
		self.color.b = b
	end
end


function GUIInventorySlots_C:getBackgroundColor()
	return self.color
end


function GUIInventorySlots_C:setBorderColor(r, g, b)
	if (r) and (g) and (b) then
		self.borderColor.r = r
		self.borderColor.g = g
		self.borderColor.b = b
	end
end


function GUIInventorySlots_C:getBorderColor()
	return self.borderColor
end


function GUIInventorySlots_C:setBorderSize(size)
	if (size) then
		self.borderSize = size
	end
end


function GUIInventorySlots_C:getBorderSize()
	return self.borderSize
end


function GUIInventorySlots_C:setAlpha(alpha)
	if (alpha) then
		self.alpha = alpha
	end
end


function GUIInventorySlots_C:getAlpha()
	return self.alpha
end


function GUIInventorySlots_C:setGridSlots(horizontalSlots, verticalSlots)
	if (horizontalSlots) and (verticalSlots) then
		self.horizontalSlots = horizontalSlots
		self.verticalSlots = verticalSlots
		self:buildSlots()
	end
end


function GUIInventorySlots_C:getGridSlots()
	return self.horizontalSlots, self.verticalSlots
end


function GUIInventorySlots_C:getSlots()
	return self.slots
end


function GUIInventorySlots_C:setPostGUI(postGUI)
	self.postGUI = postGUI
end


function GUIInventorySlots_C:getPostGUI()
	return self.postGUI
end


function GUIInventorySlots_C:setSubPixelPositioning(subPixelPositioning)
	self.subPixelPositioning = subPixelPositioning
end


function GUIInventorySlots_C:getSubPixelPositioning()
	return self.subPixelPositioning
end


function GUIInventorySlots_C:clear()
	self:destroySlots()
	
end


function GUIInventorySlots_C:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUIInventorySlots_C was deleted.")
	end
end