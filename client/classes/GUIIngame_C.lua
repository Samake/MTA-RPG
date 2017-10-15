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
	
	local textureProperties = {}
	textureProperties.id = 1
	textureProperties.texture = Textures["Effects"]["Animated"][1].texture
	textureProperties.size = Textures["Effects"]["Animated"][1].size
	textureProperties.columns = Textures["Effects"]["Animated"][1].columns
	textureProperties.rows = Textures["Effects"]["Animated"][1].rows

	self.test1 = AnimatedTexture_C:new(textureProperties)
	
	local textureProperties = {}
	textureProperties.id = 2
	textureProperties.texture = Textures["Effects"]["Animated"][2].texture
	textureProperties.size = Textures["Effects"]["Animated"][2].size
	textureProperties.columns = Textures["Effects"]["Animated"][2].columns
	textureProperties.rows = Textures["Effects"]["Animated"][2].rows
	
	self.test2 = AnimatedTexture_C:new(textureProperties)
	
	local textureProperties = {}
	textureProperties.id = 3
	textureProperties.texture = Textures["Effects"]["Animated"][3].texture
	textureProperties.size = Textures["Effects"]["Animated"][3].size
	textureProperties.columns = Textures["Effects"]["Animated"][3].columns
	textureProperties.rows = Textures["Effects"]["Animated"][3].rows
	
	self.test3 = AnimatedTexture_C:new(textureProperties)
	
	local textureProperties = {}
	textureProperties.id = 4
	textureProperties.texture = Textures["Effects"]["Animated"][4].texture
	textureProperties.size = Textures["Effects"]["Animated"][4].size
	textureProperties.columns = Textures["Effects"]["Animated"][4].columns
	textureProperties.rows = Textures["Effects"]["Animated"][4].rows
	
	self.test4 = AnimatedTexture_C:new(textureProperties)
end


function GUIIngame_C:update(deltaTime)
	if (self.quickSlots) then
		self.quickSlots:update()
	end
	
	if (self.guiStatBars) then
		self.guiStatBars:update()
	end
	
	if (self.test1) then
		self.test1:update()
		
		if (self.test1:getTexture()) then
			dxDrawImage(0, 0, 128, 128, self.test1:getTexture(), 0, 0, 0, tocolor(255,255,255,255), true)
		end
	end
	
	if (self.test2) then
		self.test2:update()
		
		if (self.test2:getTexture()) then
			dxDrawImage(128, 0, 128, 128, self.test2:getTexture(), 0, 0, 0, tocolor(255,255,255,255), true)
		end
	end
	
	if (self.test3) then
		self.test3:update()
		
		if (self.test3:getTexture()) then
			dxDrawImage(256, 0, 128, 128, self.test3:getTexture(), 0, 0, 0, tocolor(255,255,255,255), true)
		end
	end
	
	if (self.test4) then
		self.test4:update()
		
		if (self.test4:getTexture()) then
			dxDrawImage(384, 0, 128, 128, self.test4:getTexture(), 0, 0, 0, tocolor(255,255,255,255), true)
		end
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
	
	if (self.test1) then
		self.test1:delete()
		self.test1 = nil
	end
	
	if (self.test2) then
		self.test2:delete()
		self.test2 = nil
	end
	
	if (self.test3) then
		self.test3:delete()
		self.test3 = nil
	end
	
	if (self.test4) then
		self.test4:delete()
		self.test4 = nil
	end
end


function GUIIngame_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUIIngame_C was deleted.")
	end
end