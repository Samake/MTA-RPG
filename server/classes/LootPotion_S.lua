LootPotion_S = inherit(Attack_S)

function LootPotion_S:constructor(lootSettings)
	
	self.settings = lootSettings
	self.id = lootSettings.id
	self.x = lootSettings.x
	self.y = lootSettings.y
	self.z = lootSettings.z
	self.rz = math.random(0,360)
	self.money = lootSettings.money
	self.playerClass = lootSettings.playerClass
	
	self.itemContainer = lootSettings.itemContainer
	self.itemContainer.instance = nil
	
	self.owner = nil
	
	self.startCount = 0
	self.currentCount = 0
	
	self.isLocked = true
	self.isPickedUp = false
	self.pickUp = nil
	self.aura = nil
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("LootPotion_S " .. self.id .. " was loaded.")
	end
end


function LootPotion_S:init()
	if (self.playerClass) then
		self.owner = self.playerClass.player
		
		if (not self.owner) then
			LootManager_S:getSingleton():deleteLoot(self.id)
		end
	end
	
	self.m_PickupItem = bind(self.pickupItem, self)
	addEvent("PICKUPLOOT", true)
	addEventHandler("PICKUPLOOT", root, self.m_PickupItem)
	
	self:createLootObject()
	
	self.startCount = getTickCount()
end


function LootPotion_S:update()
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


function LootPotion_S:pickupItem(element)
	if (self.isPickedUp == false) then
		if (client) and (isElement(client)) and (element) and (self.pickUp) then
			if (element == self.pickUp) then
				if (self.owner) then
					if (self.owner == client) then
						if (self.playerClass) then
							if (self.itemContainer) then
								self.isPickedUp = true
								self.playerClass:changeMoney(self.money)

								NotificationManager_S:getSingleton():sendPlayerNotification(self.owner, "#EEEEEEYou got #EEDD44" .. self.itemContainer.name)
								LootManager_S:getSingleton():deleteLoot(self.id)
							end
						end
					else
						NotificationManager_S:getSingleton():sendPlayerNotification(client, "#EE4444Not allowed to loot this!")
					end
				else
					self.owner = client
					self.playerClass = PlayerManager_S:getSingleton():getPlayerClass(self.owner)
					
					if (self.playerClass) then
						if (self.itemContainer) then
							self.isPickedUp = true
							self.playerClass:changeMoney(self.money)

							NotificationManager_S:getSingleton():sendPlayerNotification(self.owner, "#EEEEEEYou got #EEDD44" .. self.itemContainer.name)
							LootManager_S:getSingleton():deleteLoot(self.id)
						end
					end
				end
			end
		end
	end
end


function LootPotion_S:createLootObject()
	if (not self.pickUp) and (self.owner) then
		self.pickUp = createObject(1512, self.x, self.y, self.z - 0.48, 0, 0, self.rz, false)
		
		if (self.pickUp) then
			self.pickUp:setData("ISLOOT", "true", true)
			self.pickUp:setDimension(self.owner:getDimension())
			
			if (self.itemContainer) then
				if (self.itemContainer.color) then
					if (not self.aura) then
						self.aura = createMarker(self.x, self.y, self.z - 0.48, "corona", 0.25, self.itemContainer.color.r, self.itemContainer.color.g, self.itemContainer.color.b, 90)
					
						if (self.aura) then
							self.aura:setDimension(self.owner:getDimension())
						end
					end
				end
			end
		end
	end
end


function LootPotion_S:deleteLootObject()
	if (self.pickUp) then
		self.pickUp:destroy()
		self.pickUp = nil
	end
	
	if (self.aura) then
		self.aura:destroy()
		self.aura = nil
	end
end


function LootPotion_S:getObject()
	return self.pickUp
end


function LootPotion_S:getPosition()
	return {x = self.x, y = self.y, z = self.z}
end


function LootPotion_S:clear()
	removeEventHandler("PICKUPLOOT", root, self.m_PickupItem)
	
	self:deleteLootObject()
end


function LootPotion_S:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("LootPotion_S " .. self.id .. " was deletes.")
	end
end