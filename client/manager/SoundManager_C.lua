SoundManager_C = inherit(Singleton)

function SoundManager_C:constructor()

	self.sounds = {}
	
	self.volume = 0.9
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("SoundManager_C was loaded.")
	end
end


function SoundManager_C:init()
	self.m_PlaySound = bind(self.playSound, self)
	addEvent("PLAYSOUND", true)
	addEventHandler("PLAYSOUND", root, self.m_PlaySound)
	
	self.m_Play3DSound = bind(self.play3DSound, self)
	addEvent("PLAY3DSOUND", true)
	addEventHandler("PLAY3DSOUND", root, self.m_Play3DSound)
	
	triggerServerEvent("SUBSCRIBESOUND", root)
end


function SoundManager_C:playSound(sound, looped, volume)
	if (sound) then
		if (not volume) then volume = self.volume end
		
		local id = self:getFreeID()
		
		if (not self.sounds[id]) then
			self.sounds[id] = playSound(sound, looped)
			
			if (not self.sounds[id] == false) then
				self.sounds[id]:setVolume(volume)
			end
		end
	end
end


function SoundManager_C:play3DSound(sound, x, y, z, looped, volume)
	if (sound) (x) and (y) and (z) then
		if (not volume) then volume = self.volume end
		
		local id = self:getFreeID()
		
		if (not self.sounds[id]) then
			self.sounds[id] = playSound3D(sound, x, y, z, looped)
			
			if (not self.sounds[id] == false) then
				self.sounds[id]:setVolume(volume)
			end
		end
	end
end


function SoundManager_C:getFreeID()
	for index, sound in pairs(self.sounds) do
		if (not sound) then
			return index
		end
	end
	
	return #self.sounds + 1
end


function SoundManager_C:clear()
	removeEventHandler("PLAY3DSOUND", root, self.m_Play3DSound)
	removeEventHandler("PLAYSOUND", root, self.m_PlaySound)
	
	for index, sound in pairs(self.sounds) do
		if (sound) and (isElement(sound)) then
			sound:stop()
		end
	end
	
	triggerServerEvent("UNSUBSCRIBESOUND", root)
end


function SoundManager_C:destructor()
	self:clear()

	if (Settings.showManagerDebugInfo == true) then
		sendMessage("SoundManager_C was deleted.")
	end
end