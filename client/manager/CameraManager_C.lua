CameraManager_C = inherit(Singleton)

function CameraManager_C:constructor()

	self.camera = nil
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("CameraManager_C was loaded.")
	end
end


function CameraManager_C:init()
	if (not self.camera) then
		self.camera = Camera_C:new()
	end
end


function CameraManager_C:update(deltaTime)
	if (self.camera) then
		self.camera:update()
	end
end


function CameraManager_C:clear()
	if (self.camera) then
		self.camera:delete()
		self.camera = nil
	end
end


function CameraManager_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("CameraManager_C was deleted.")
	end
end