GUIWorld_C = inherit(Class)

function GUIWorld_C:constructor()

	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUIWorld_C was loaded.")
	end
end


function GUIWorld_C:init()
	if (not self.nameTags) then
		self.nameTags = NameTags_C:new()
	end
	
	if (not self.text3D) then
		self.text3D = WorldText3D_C:new()
	end
end


function GUIWorld_C:update(deltaTime)
	if (self.nameTags) then
		self.nameTags:update()
	end
	
	if (self.text3D) then
		self.text3D:update()
	end
end


function GUIWorld_C:clear()
	if (self.nameTags) then
		self.nameTags:delete()
		self.nameTags = nil
	end
	
	if (self.text3D) then
		self.text3D:delete()
		self.text3D = nil
	end
end


function GUIWorld_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUIWorld_C was deleted.")
	end
end