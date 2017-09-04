LootMoney_S = inherit(Attack_S)

function LootMoney_S:constructor(moneySettings)
	
	self.settings = moneySettings
	self.id = moneySettings.id
	self.x = moneySettings.x
	self.y = moneySettings.y
	self.z = moneySettings.z
	self.rz = math.random(0,360)
	self.money = moneySettings.money
	self.playerClass = moneySettings.playerClass
	self.owner = nil
	
	self.startCount = 0
	self.currentCount = 0
	
	self.isLocked = true
	self.isPickedUp = false
	self.pickUp = nil
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("LootMoney_S " .. self.id .. " was loaded.")
	end
end


function LootMoney_S:init()
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


function LootMoney_S:update()
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


function LootMoney_S:pickupItem(element)
	if (self.isPickedUp == false) then
		if (client) and (isElement(client)) and (element) and (self.pickUp) then
			if (element == self.pickUp) then
				if (self.owner) then
					if (self.owner == client) then
						if (self.playerClass) then
							self.isPickedUp = true
							self.playerClass:changeMoney(self.money)

							NotificationManager_S:getSingleton():sendPlayerNotification(self.owner, "#EEEEEEYou got #EEDD44" .. self.money .. " $")
							LootManager_S:getSingleton():deleteLoot(self.id)
						end
					else
						NotificationManager_S:getSingleton():sendPlayerNotification(client, "#EE4444Not allowed to loot this!")
					end
				else
					self.owner = client
					self.playerClass = PlayerManager_S:getSingleton():getPlayerClass(self.owner)
					
					if (self.playerClass) then
						self.isPickedUp = true
						self.playerClass:changeMoney(self.money)

						NotificationManager_S:getSingleton():sendPlayerNotification(self.owner, "#EEEEEEYou got #EEDD44" .. self.money .. " $")
						LootManager_S:getSingleton():deleteLoot(self.id)
					end
				end
			end
		end
	end
end


function LootMoney_S:createLootObject()
	if (not self.pickUp) then
		self.pickUp = createObject(1212, self.x, self.y, self.z - 0.48, 0, 0, self.rz, false)
		
		if (self.pickUp) then
			self.pickUp:setData("ISLOOT", "true", true)
			
			if (self.owner) then
				self.pickUp:setDimension(self.owner:getDimension())
			end
		end
	end
end


function LootMoney_S:deleteLootObject()
	if (self.pickUp) then
		self.pickUp:destroy()
		self.pickUp = nil
	end
end


function LootMoney_S:getObject()
	return self.pickUp
end


function LootMoney_S:getPosition()
	return {x = self.x, y = self.y, z = self.z}
end


function LootMoney_S:clear()
	removeEventHandler("PICKUPLOOT", root, self.m_PickupItem)
	
	self:deleteLootObject()
end


function LootMoney_S:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("LootMoney_S " .. self.id .. " was deletes.")
	end
end