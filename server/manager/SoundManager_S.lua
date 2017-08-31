SoundManager_S = inherit(Singleton)

function SoundManager_S:constructor()
	
	self.clientList = {}
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("SoundManager_S was loaded.")
	end
end


function SoundManager_S:init()
	self.m_SubscribeClient = bind(self.subscribeClient, self)
	addEvent("SUBSCRIBESOUND", true)
	addEventHandler("SUBSCRIBESOUND", root, self.m_SubscribeClient)
	
	self.m_UnsubscribeClient = bind(self.unsubscribeClient, self)
	addEvent("UNSUBSCRIBESOUND", true)
	addEventHandler("UNSUBSCRIBESOUND", root, self.m_UnsubscribeClient)
	
	if (not self.ambientSound) then
		self.ambientSound = Sounds["Ambient"][math.random(1, #Sounds["Ambient"])]
	end
end


function SoundManager_S:subscribeClient()
	if (client) then
		if (not self.clientList[tostring(client)]) then
			self.clientList[tostring(client)] = client
			
			if (self.ambientSound) then
				self:playSound(self.ambientSound.sound, true, self.ambientSound.volume, client)
			end
		end
	end
end


function SoundManager_S:unsubscribeClient()
	if (client) then
		if (self.clientList[tostring(client)]) then
			self.clientList[tostring(client)] = nil
		end
	end
end


function SoundManager_S:playSound(sound, looped, volume, player)
	if (sound) then
		if (not player) then player = root end
		
		triggerClientEvent(player, "PLAYSOUND", player, sound, looped, volume)
	end
end


function SoundManager_S:playSound3D(sound, x, y, z, looped, volume)
	if (sound) (x) and (y) and (z) then
		if (not player) then player = root end
		
		triggerClientEvent(player, "PLAYSOUND", player, sound, x, y, z, looped, volume)
	end
end


function SoundManager_S:clear()
	removeEventHandler("SUBSCRIBESOUND", root, self.m_SubscribeClient)
	removeEventHandler("UNSUBSCRIBESOUND", root, self.m_UnsubscribeClient)
end


function SoundManager_S:destructor()
	self:clear()

	if (Settings.showManagerDebugInfo == true) then
		sendMessage("SoundManager_S was deleted.")
	end
end