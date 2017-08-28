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
	self.eventDelay = math.random(360000, 2160000)
	
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
			self.eventDelay = math.random(360000, 2160000)
		end
	end
end


function EventManager_S:startEventByCommand(player, command, eventID, duration)
	outputChatBox("1")
	if (player) and (command) and (eventID) then
		outputChatBox("2")
		if (isObjectInACLGroup("user." .. player:getAccount():getName(), aclGetGroup("Admin"))) then
			outputChatBox("3")
			if (self.events[tonumber(eventID)]) then
				outputChatBox("4")
				self.currentEvent = self.events[tonumber(eventID)]
				self:startEvent(self.currentEvent, tonumber(duration))
			end
		end
	end
end


function EventManager_S:stopEventByCommand(player, command, eventID)
	if (player) and (command) and (tonumber(eventID)) then
		if (isObjectInACLGroup("user." .. player:getAccount():getName(), aclGetGroup("Admin"))) then
			if (self.events[tonumber(eventID)]) then
				self:stopEvent(self.currentEvent)
			end
		end
	end
end


function EventManager_S:startEvent(eventName, duration)
	if (eventName) then
		if (eventName == "DoubleXP") then
			self.doubleXPEvent = true
			sendMessage("SERVER || Double XP event was started!")
		elseif (eventName == "DoubleMoney") then
			self.doubleMoneyEvent = true
			sendMessage("SERVER || Double Money event was started!")
		end
		
		self.startTick = getTickCount()
		
		if (duration) then
			self.eventDelay = math.random(360000, 2160000)
		else
			self.eventDelay = 360000 * duration
		end
	end
end


function EventManager_S:stopEvent(eventName)
	if (eventName) then
		if (eventName == "DoubleXP") then
			if (self.doubleXPEvent == true) then
				self.doubleXPEvent = false
				sendMessage("SERVER || Double XP event was stopped!")
			end
		elseif (eventName == "DoubleMoney") then
			if (self.doubleMoneyEvent == true) then
				self.doubleMoneyEvent = false
				sendMessage("SERVER || Double Money event was stopped!")
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