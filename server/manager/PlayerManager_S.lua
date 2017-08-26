PlayerManager_S = inherit(Singleton)

function PlayerManager_S:constructor()
	
	self.playerClasses = {}
	self.playerSkins = {}
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("PlayerManager_S was loaded.")
	end
end


function PlayerManager_S:init()
	self.m_RequestPlayerSkin = bind(self.requestPlayerSkin, self)
	addEvent("REQUESTPLAYERSKINS", true)
	addEventHandler("REQUESTPLAYERSKINS", root, self.m_RequestPlayerSkin)
	
	for index, player in pairs(getElementsByType("player")) do
		if (player) then
			self:addPlayer(player)
		end
	end
end


function PlayerManager_S:update()
	for index, playerClass in pairs(self.playerClasses) do
		if (playerClass) then
			playerClass:update()
		end
	end
end


function PlayerManager_S:addPlayer(player)
	if (isElement(player)) then
		local playerSettings = {}
		playerSettings.id = tostring(player)
		playerSettings.player = player
		
		if (not self.playerClasses[playerSettings.id]) then
			self.playerClasses[playerSettings.id] = Player_S:new(playerSettings)
		end
	end
end


function PlayerManager_S:deletePlayer(player)
	if (isElement(player)) then
	
	end
end


function PlayerManager_S:requestPlayerSkin()
	if (isElement(client)) then
		self.playerSkins = {}
		
		for index, playerClass in pairs(self.playerClasses) do
			if (playerClass) then
				if (not self.playerSkins[tostring(playerClass.player)]) then
					self.playerSkins[tostring(playerClass.player)] = {}
					self.playerSkins[tostring(playerClass.player)].player = playerClass.player
					self.playerSkins[tostring(playerClass.player)].head = playerClass.headID
					self.playerSkins[tostring(playerClass.player)].torso = playerClass.torsoID
					self.playerSkins[tostring(playerClass.player)].leg = playerClass.legID
					self.playerSkins[tostring(playerClass.player)].feet = playerClass.feetID
				end
			end
		end
		
		triggerClientEvent("SENDPLAYERSKINS", root, self.playerSkins)
	end
end


function PlayerManager_S:clear()
	removeEventHandler("REQUESTPLAYERSKINS", root, self.m_RequestPlayerSkin)
	
	for index, playerClass in pairs(self.playerClasses) do
		if (playerClass) then
			playerClass:delete()
			playerClass = nil
		end
	end
end


function PlayerManager_S:destructor()
	self:clear()

	if (Settings.showManagerDebugInfo == true) then
		sendMessage("PlayerManager_S was deleted.")
	end
end