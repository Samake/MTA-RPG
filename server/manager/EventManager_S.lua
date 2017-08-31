EventManager_S = inherit(Singleton)

function EventManager_S:constructor()

	self.events = {}
	self.events[1] = "DoubleXP"
	self.events[2] = "DoubleMoney"
	
	self.doubleXPEvent = true
	self.doubleMoneyEvent = false
	
	self.startTick = 0
	self.currentTickTick = 0
	
	self.currentEvent = nil
	
	self.minDelay = Settings.eventMinDelay
	self.maxDelay = Settings.eventMaxDelay
	
	self.eventDelay = math.random(0, self.maxDelay)
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("EventManager_S was loaded.")
	end
end


function EventManager_S:init()
	self.m_StartEventByCommand = bind(self.startEventByCommand, self)
	self.m_StopEventByCommand = bind(self.stopEventByCommand, self)
	
	addCommandHandler("startEvent", self.m_StartEventByCommand)
	addCommandHandler("stopEvent", self.m_StopEventByCommand)
	
	self.startTick = getTickCount()
	self.currentTickTick = self.startTick
end


function EventManager_S:update()
	self.currentTickTick = getTickCount()
	
	if (self.currentTickTick > self.startTick + self.eventDelay) then
		if (self.currentEvent) then
			self:stopEvent(self.currentEvent)
		end
		
		local randomEvent = math.random(1, #self.events + 1)
		
		if (self.events[randomEvent]) then
			self:startEvent(self.currentEvent)
			self.currentEvent = self.events[randomEvent]
		else
			self.startTick = getTickCount()
			self.eventDelay = math.random(self.minDelay, self.maxDelay)
		end
	end
end


function EventManager_S:startEventByCommand(player, command, eventID, duration)
	if (player) and (command) and (eventID) then
		if (isObjectInACLGroup("user." .. player:getAccount():getName(), aclGetGroup("Admin"))) then
			
			if (not duration) then duration = 1 end
			
			if (self.events[tonumber(eventID)]) then
				if (not self.currentEvent) then
					self.currentEvent = self.events[tonumber(eventID)]
					self:startEvent(self.currentEvent, tonumber(duration), 1)
					NotificationManager_S:getSingleton():sendAllNotification("#44EE44Event #EEEEEE" .. self.currentEvent .. "#44EE44 was started by #EEEEEE" .. removeHEXColorCode(player:getName()) .. "#44EE44!")
				else
					self:stopEvent(self.currentEvent)
					self.currentEvent = self.events[tonumber(eventID)]
					self:startEvent(self.currentEvent, tonumber(duration), 1)
					NotificationManager_S:getSingleton():sendAllNotification("#44EE44Event #EEEEEE" .. self.currentEvent .. "#44EE44 was started by #EEEEEE" .. removeHEXColorCode(player:getName()) .. "#44EE44!")
				end
			end
		end
	end
end


function EventManager_S:stopEventByCommand(player, command, eventID)
	if (player) and (command) and (tonumber(eventID)) then
		if (isObjectInACLGroup("user." .. player:getAccount():getName(), aclGetGroup("Admin"))) then
			if (self.events[tonumber(eventID)]) then
				self:stopEvent(self.currentEvent, 1)
				NotificationManager_S:getSingleton():sendAllNotification("#EE4444Event #EEEEEE" .. self.currentEvent .. "#EE4444 was stopped by #EEEEEE" .. removeHEXColorCode(player:getName()) .. "#EE4444!")
			end
		end
	end
end


function EventManager_S:startEvent(eventName, duration, flag)
	if (eventName) then
		if (eventName == "DoubleXP") then
			self.doubleXPEvent = true
			
			if (not flag) then
				NotificationManager_S:getSingleton():sendAllNotification("#44EE44Event #EEEEEE" .. eventName .. "#44EE44 was started!")
			end
		elseif (eventName == "DoubleMoney") then
			self.doubleMoneyEvent = true
			if (not flag) then
				NotificationManager_S:getSingleton():sendAllNotification("#44EE44Event #EEEEEE" .. eventName .. "#44EE44 event was started!")
			end
		end
		
		self.startTick = getTickCount()
		
		if (duration) then
			self.eventDelay = math.random(self.minDelay, self.maxDelay)
		else
			self.eventDelay = self.minDelay * duration
		end
	end
end


function EventManager_S:stopEvent(eventName)
	if (eventName) then
		if (eventName == "DoubleXP") then
			if (self.doubleXPEvent == true) then
				self.doubleXPEvent = false
				NotificationManager_S:getSingleton():sendAllNotification("#EE4444Event #EEEEEE" .. eventName .. "#EE4444 was stopped!")
			end
		elseif (eventName == "DoubleMoney") then
			if (self.doubleMoneyEvent == true) then
				self.doubleMoneyEvent = false
				NotificationManager_S:getSingleton():sendAllNotification("#EE4444Event #EEEEEE" .. eventName .. "#EE4444 was stopped!")
			end
		end
		
		self.currentEvent = nil
	end
end


function EventManager_S:isDoubleXPEvent()
	return self.doubleXPEvent
end


function EventManager_S:isDoubleMoneyEvent()
	return self.doubleMoneyEvent
end


function EventManager_S:clear()
	removeCommandHandler("startEvent", self.m_StartEventByCommand)
	removeCommandHandler("stopEvent", self.m_StopEventByCommand)
	
	self.doubleXPEvent = false
	self.doubleMoneyEvent = false
	self.currentEvent = nil
end


function EventManager_S:destructor()
	self:clear()

	if (Settings.showManagerDebugInfo == true) then
		sendMessage("EventManager_S was deleted.")
	end
end