NotificationManager_C = inherit(Singleton)

function NotificationManager_C:constructor()
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.notificationClasses = {}
	
	self.x = self.screenWidth * 0.77
	self.y = self.screenHeight * 0.3
	self.width = self.screenWidth * 0.22
	self.height = self.screenHeight * 0.4
	
	self.maxNotifications = 10
	
	self.notificationHeight = self.height / self.maxNotifications
	self.alphaModifier = 0.25

	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("NotificationManager_C was loaded.")
	end
end


function NotificationManager_C:init()
	self.m_AddNotification = bind(self.addNotification, self)
	addEvent("SENDNOTIFICATION", true)
	addEventHandler("SENDNOTIFICATION", root, self.m_AddNotification)
end


function NotificationManager_C:update(delta)
	for i = 1, self.maxNotifications do
		if (self.notificationClasses[i]) then
			self.notificationClasses[i].alpha = self.notificationClasses[i].alpha - self.alphaModifier
			self.notificationClasses[i].y = (self.y + (self.notificationHeight * i)) + (self.notificationHeight * 0.05)
		end
	end
		
	for index, notificationClass in pairs(self.notificationClasses) do
		if (notificationClass) then
			notificationClass:update()
		end
	end
end


function NotificationManager_C:addNotification(text)
	if (text) then
		if (self.notificationClasses[self.maxNotifications]) then
			self.notificationClasses[self.maxNotifications]:delete()
			self.notificationClasses[self.maxNotifications] = nil
		end
		
		for i = self.maxNotifications, 1, -1 do
			if (not self.notificationClasses[i]) then
				if (self.notificationClasses[i - 1]) then
					self.notificationClasses[i] = self.notificationClasses[i - 1]
					self.notificationClasses[i].id = i
					self.notificationClasses[i - 1] = nil
				end
			end
		end
		
		local notificationSettings = {}
		notificationSettings.id = 1
		notificationSettings.text = text
		notificationSettings.width = self.width
		notificationSettings.height = self.notificationHeight * 0.9
		notificationSettings.alpha = Settings.guiAlpha
		notificationSettings.x = self.x
		notificationSettings.y = self.y + (self.notificationHeight * 0.05)
		
		if (not self.notificationClasses[notificationSettings.id]) then
			self.notificationClasses[notificationSettings.id] = Notification_C:new(notificationSettings)
		end
	end
end


function NotificationManager_C:deleteNotification(id)
	if (id) then
		if (self.notificationClasses[id]) then
			self.notificationClasses[id]:delete()
			self.notificationClasses[id] = nil
		end
	end
end


function NotificationManager_C:clear()
	removeEventHandler("SENDNOTIFICATION", root, self.m_AddNotification)
	
	for index, notificationClass in pairs(self.notificationClasses) do
		if (notificationClass) then
			notificationClass:delete()
			notificationClass = nil
		end
	end
end


function NotificationManager_C:destructor()
	self:clear()

	if (Settings.showManagerDebugInfo == true) then
		sendMessage("NotificationManager_C was deleted.")
	end
end