PlayerPreview_C = inherit(Singleton)

function PlayerPreview_C:constructor()
	
	self.preview = nil
	self.player = getLocalPlayer()
	
	self.playerPos = nil
	self.playerRot = nil
	
	--self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("PlayerPreview_C was loaded.")
	end
end


function PlayerPreview_C:init()
	if (not self.preview) and (self.player) then
		self.preview = createObjectPreview(self.player, 0, 0, 0, 0, 0, 200, 200, false, false, true)
	end
end


function PlayerPreview_C:update(deltaTime)
	if (self.preview) and (self.player) and (isElement(self.player)) then
		setDistanceSpread(self.preview, 5)
	end
end


function PlayerPreview_C:getResult()
	return getRenderTarget()
end


function PlayerPreview_C:clear()
	if (self.preview) then
		destroyObjectPreview(self.preview)
	end
end


function PlayerPreview_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("PlayerPreview_C " .. self.id .. " was deleted.")
	end
end