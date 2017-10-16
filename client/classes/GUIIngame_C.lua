GUIIngame_C = inherit(Class)

function GUIIngame_C:constructor()

	self.screenWidth, self.screenHeight = guiGetScreenSize()

	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUIIngame_C was loaded.")
	end
end


function GUIIngame_C:init()
	if (not self.quickSlots) then
		self.quickSlots = GUIQuickSlots_C:new()
	end
	
	if (not self.guiStatBars) then
		self.guiStatBars = GUIStatBars_C:new()
	end
end


function GUIIngame_C:update(deltaTime)
	if (self.quickSlots) then
		self.quickSlots:update()
	end
	
	if (self.guiStatBars) then
		self.guiStatBars:update()
	end
end


function GUIIngame_C:clear()
	if (self.quickSlots) then
		self.quickSlots:delete()
		self.quickSlots = nil
	end
	
	if (self.guiStatBars) then
		self.guiStatBars:delete()
		self.guiStatBars = nil
	end
end


function GUIIngame_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUIIngame_C was deleted.")
	end
end