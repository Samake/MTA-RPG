Notification_C = inherit(Class)

function Notification_C:constructor(notificationSettings)

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.id = notificationSettings.id
	self.text = notificationSettings.text
	self.x = notificationSettings.x
	self.y = notificationSettings.y
	self.width = notificationSettings.width
	self.height = notificationSettings.height
	self.alpha = notificationSettings.alpha
	
	self.shadowOffset = 1
	self.scale = 1
	self.font = "default-bold"
	self.alignX = "center"
	self.alignY = "center"
	self.clip = true
	self.wordBreak = true
	self.colorCoded = true
	self.rotation = 0
	self.rotationCenterX = 0
	self.rotationCenterY = 0
	
	self.maxNotifications = 10
	
	self.postGUI = false
	self.subPixelPositioning = true
	
	self.animationFactor = 1
	self.currentWidth = 0
	self.currentX = 0
	self.currentScale = 0
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Notification_C " .. self.id .. " was loaded.")
	end
end


function Notification_C:init()
	if (not self.animations) then
		self.animations = GUIAnimations_C:new(350, "InBack", false)
	end
end


function Notification_C:update(deltaTime)

	if (self.animations) then
		self.animations:update()
		self.animationFactor = self.animations:getFactor()
	end
	
	self.currentX = self.screenWidth - (self.x * self.animationFactor)
	self.currentWidth = self.width * self.animationFactor
	self.currentScale = self.scale * self.animationFactor
	
	dxDrawRectangle(self.x, self.y, self.currentWidth, self.height, tocolor(90, 90, 90, self.alpha), self.postGUI, self.subPixelPositioning)
	dxDrawRectangle(self.x + 2, self.y + 2, self.currentWidth - 4, self.height - 4, tocolor(15, 15, 15, self.alpha), self.postGUI, self.subPixelPositioning)
	
	dxDrawText(removeHEXColorCode(self.text), self.x + self.shadowOffset, self.y + self.shadowOffset, self.x + self.currentWidth + self.shadowOffset, self.y + self.height + self.shadowOffset, tocolor(0, 0, 0, self.alpha), self.currentScale, self.font, self.alignX, self.alignY, self.clip, self.wordBreak, self.postGUI, false, self.subPixelPositioning, self.rotation, self.rotationCenterX, self.rotationCenterY)
	dxDrawText(self.text, self.x, self.y, self.x + self.currentWidth, self.y + self.height, tocolor(255, 255, 255, self.alpha), self.currentScale, self.font, self.alignX, self.alignY, self.clip, self.wordBreak, self.postGUI, self.colorCoded, self.subPixelPositioning, self.rotation, self.rotationCenterX, self.rotationCenterY)

	if (self.alpha <= 0) then
		self.alpha = 0
		NotificationManager_C:getSingleton():deleteNotification(self.id)
	end
end


function Notification_C:clear()
	if (self.animations) then
		self.animations:delete()
		self.animations = nil
	end
end


function Notification_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Notification_C " .. self.id .. " was deleted.")
	end
end