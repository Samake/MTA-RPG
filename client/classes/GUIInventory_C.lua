GUIInventory_C = inherit(Class)

function GUIInventory_C:constructor()
	
	self.guiElements = {}
	
	self.postGUI = true
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUIInventory_C was loaded.")
	end
end


function GUIInventory_C:init()
	self.guiElements[1] = dxWindow:new(0.1, 0.1, 0.8, 0.8, nil, true)
	
	if (self.guiElements[1]) then
		self.guiElements[1]:setBackgroundColor(15, 15, 15)
		self.guiElements[1]:setAlpha(Settings.guiAlpha)
		self.guiElements[1]:setPostGUI(self.postGUI)
	end
end



function GUIInventory_C:update(deltaTime)
	outputChatBox(1)
	for index, guiElement in ipairs(self.guiElements) do
		outputChatBox(2)
		if (guiElement) then
			outputChatBox(3)
			guiElement:update(deltaTime)
		end
	end
end


function GUIInventory_C:clear()
	for index, guiElement in pairs(self.guiElements) do
		if (guiElement) then
			guiElement:delete()
			guiElement = nil
		end
	end
end


function GUIInventory_C:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUIInventory_C was deleted.")
	end
end