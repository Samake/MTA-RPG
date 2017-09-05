DragAndDrop_C = inherit(Singleton)

function DragAndDrop_C:constructor()
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.defaultX = 0
	self.defaultY = 0
	self.defaultWidth = 0
	self.defaultHeight = 0
	self.parent = nil
	self.isRelative = true
	
	self.x = self.defaultX
	self.y = self.defaultY
	self.width = self.defaultWidth
	self.height = self.defaultHeight
	
	self.finalX = self.defaultX
	self.finalY = self.defaultY
	self.finalWidth = self.defaultWidth
	self.finalHeight = self.defaultHeight
	
	self.startSlot = nil
	self.destinationSlot = nil
	
	self.mouseX = 0
	self.mouseY = 0
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("DragAndDrop_C was loaded.")
	end
end


function DragAndDrop_C:init()

end


function DragAndDrop_C:update(deltaTime)
	if (self.startSlot) then
		self:calcValues()
		
		if (getKeyState("mouse1") == true) then
			self:drawItem()
		else
			self:dropSlot()
		end
	end
end


function DragAndDrop_C:drawItem()
	if (self.itemContainer) then
		if (self.itemContainer:getTexture()) then
			local x = self.mouseX - (self.finalWidth / 2)
			local y = self.mouseY - (self.finalHeight / 2)
				
			dxDrawImage(x, y, self.finalWidth, self.finalHeight, self.itemContainer:getTexture(), 0, 0, 0, tocolor(220, 220, 220,self.alpha), self.postGUI)
		end
	end
end


function DragAndDrop_C:calcValues()
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
	
	self.finalWidth = self.width * 0.95
	self.finalHeight = self.height * 0.95
	self.finalX = self.x + self.width * 0.025
	self.finalY = self.y + self.height * 0.025
end


function DragAndDrop_C:addStartSlot(slot)
	if (slot) then
		if (slot.itemContainer) then
			if (not self.startSlot) then
				self.startSlot = slot
				self.itemContainer = slot.itemContainer
				slot.itemContainer = nil
				
				self.defaultX = self.startSlot.defaultX
				self.defaultY = self.startSlot.defaultY
				self.defaultWidth = self.startSlot.defaultWidth
				self.defaultHeight = self.startSlot.defaultHeight
				self.parent = self.startSlot.parent
				self.isRelative = self.startSlot.isRelative
				
				self.x = self.startSlot.x
				self.y = self.startSlot.y
				self.width = self.startSlot.width
				self.height = self.startSlot.height
				
				self.finalX = self.startSlot.finalX
				self.finalY = self.startSlot.finalY
				self.finalWidth = self.startSlot.finalWidth
				self.finalHeight = self.startSlot.finalHeight
			end
		end
	end
end


function DragAndDrop_C:addDestinationSlot(slot)
	if (slot) and (self.startSlot) then
		self.destinationSlot = slot
	end
end


function DragAndDrop_C:dropSlot()
	if (self.itemContainer) then
		if (self.destinationSlot) then
			local tempItemContainer
			
			if (self.destinationSlot.itemContainer) then
				tempItemContainer = self.destinationSlot.itemContainer
				self.destinationSlot.itemContainer = self.itemContainer
				self.startSlot.itemContainer = tempItemContainer
			else
				self.destinationSlot.itemContainer = self.itemContainer
			end
			
			triggerServerEvent("MOVEITEM", root, self.destinationSlot.slotID, self.startSlot.slotID)
		else
			self.startSlot.itemContainer = self.itemContainer
		end
		
		tempItemContainer = nil
		self.startSlot = nil
		self.destinationSlot = nil
		self.itemContainer = nil
	end
end


function DragAndDrop_C:clear()

	NotificationManager_C:getSingleton():addNotification("#EEEEEE Debug mode #EE4444 disabled #EEEEEE!")
end


function DragAndDrop_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("DragAndDrop_C was deleted.")
	end
end