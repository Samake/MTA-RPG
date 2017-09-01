SoundManager_S = inherit(Singleton)

function SoundManager_S:constructor()
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("SoundManager_S was loaded.")
	end
end


function SoundManager_S:init()
	self.m_SubscribeClient = bind(self.subscribeClient, self)
	addEvent("SUBSCRIBECLIENT", true)
	addEventHandler("SUBSCRIBECLIENT", root, self.m_SubscribeClient)
	
	if (not self.ambientSound) then
		self.ambientSound = Sounds["Ambient"][math.random(1, #Sounds["Ambient"])]
	end

end


function SoundManager_S:subscribeClient()
	if (client) then
		triggerClientEvent(client, "PLAYSOUND", client, self.ambientSound.sound, true, self.ambientSound.volume)
	end
end


function SoundManager_S:playSound(sound, looped, volume, player)
	if (sound) then
		if (not player) then
			triggerClientEvent(player, "PLAYSOUND", player, sound, looped, volume)
		else
			for index, client in pairs(TriggerManager_S:getSingleton():getClients()) do
				if (client) then
					triggerClientEvent(client, "PLAYSOUND", client, sound, looped, volume)
				end
			end
		end
	end
end


function SoundManager_S:playSound3D(sound, x, y, z, looped, volume, player)
	if (sound) (x) and (y) and (z) then
		if (not player) then
			triggerClientEvent(player, "PLAYSOUND", player, sound, x, y, z, looped, volume)
		else
			for index, client in pairs(TriggerManager_S:getSingleton():getClients()) do
				if (client) then
					triggerClientEvent(client, "PLAYSOUND", client, sound, x, y, z, looped, volume)
				end
			end
		end
	end
end


function SoundManager_S:clear()

end


function SoundManager_S:destructor()
	self:clear()

	if (Settings.showManagerDebugInfo == true) then
		sendMessage("SoundManager_S was deleted.")
	end
end