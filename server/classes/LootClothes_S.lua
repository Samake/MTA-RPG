LootClothes_S = inherit(Attack_S)

function LootClothes_S:constructor(lootSettings)
	
	self.settings = lootSettings
	self.id = lootSettings.id
	self.x = lootSettings.x
	self.y = lootSettings.y
	self.z = lootSettings.z
	self.rz = math.random(0, 360)
	self.playerClass = lootSettings.playerClass
	
	self.itemContainer = lootSettings.itemContainer
	self.itemContainer.instance = nil
	
	self.owner = nil
	
	self.startCount = 0
	self.currentCount = 0
	
	self.isLocked = true
	self.pickUp = nil
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("LootClothes_S " .. self.id .. " was loaded.")
	end
end


function LootClothes_S:init()
	if (self.playerClass) then
		self.owner = self.playerClass.player
		
		if (not self.owner) then
			LootManager_S:getSingleton():deleteLoot(self.id)
		end
	end
	
	self.m_Pickup = bind(self.pickup, self)
	addEvent("PICKUPLOOT", true)
	addEventHandler("PICKUPLOOT", root, self.m_Pickup)
	
	self:createLootObject()
	
	self.startCount = getTickCount()
end


function LootClothes_S:update()
	self.currentCount = getTickCount()
	
	if (self.currentCount > self.startCount + Settings.lootLockDelay) then
		if (self.isLocked == true) then
			if (self.owner) then
				self.owner = nil
			end
			
			if (self.playerClass) then
				self.playerClass = nil
			end
			
			self.isLocked = false
		end
	end
	
	if (self.currentCount > self.startCount + Settings.lootDelay) then
		LootManager_S:getSingleton():deleteLoot(self.id)
	end
end


function LootClothes_S:pickup(element)
	if (client) and (isElement(client)) and (element) and (self.pickUp) then
		if (element == self.pickUp) then
			if (self.owner) then
				if (self.owner == client) then
					if (self.playerClass) then
						--id = 2
						--name = "Head"
						--description = ""
						--stats = {stamina = 1, intelligence = 2, armor = 100, crit = 2}
						--chance = 100
						--quality = "normal"
						--color = {220, 220, 90}
						--costs
						--class
						--instance
						
						if (self.itemContainer) then
							local color = RGBToHex(self.itemContainer.color.r, self.itemContainer.color.g, self.itemContainer.color.b)
							
							if (color) then
								NotificationManager_S:getSingleton():sendPlayerNotification(self.owner, "#EEEEEEYou got " .. color .. self.itemContainer.name)
								LootManager_S:getSingleton():deleteLoot(self.id)
							end
						end
					end
				end
			else
				self.owner = client
				self.playerClass = PlayerManager_S:getSingleton():getPlayerClass(self.owner)
				
				if (self.playerClass) then
					if (self.itemContainer) then
						local color = RGBToHex(self.itemContainer.color.r, self.itemContainer.color.g, self.itemContainer.color.b)
						
						if (color) then
							NotificationManager_S:getSingleton():sendPlayerNotification(self.owner, "#EEEEEEYou got " .. color .. self.itemContainer.name)
							LootManager_S:getSingleton():deleteLoot(self.id)
						end
					end
				end
			end
		end
	end
end


function LootClothes_S:createLootObject()
	if (not self.pickUp) then
		-- ToDo model by quality
		self.pickUp = createObject(1575, self.x, self.y, self.z - 0.48, 0, 0, self.rz, false)
		
		if (self.pickUp) then
			self.pickUp:setData("ISLOOT", "true", true)
			
			if (self.owner) then
				self.pickUp:setDimension(self.owner:getDimension())
			end
		end
	end
end


function LootClothes_S:deleteLootObject()
	if (self.pickUp) then
		self.pickUp:destroy()
		self.pickUp = nil
	end
end


function LootClothes_S:getObject()
	return self.pickUp
end


function LootClothes_S:getPosition()
	return {x = self.x, y = self.y, z = self.z}
end


function LootClothes_S:clear()
	removeEventHandler("PICKUPLOOT", root, self.m_Pickup)
	
	self:deleteLootObject()
end


function LootClothes_S:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("LootClothes_S " .. self.id .. " was deletes.")
	end
end