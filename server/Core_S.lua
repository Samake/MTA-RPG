Core_S = inherit(Singleton)

function Core_S:constructor()
	sendMessage("SERVER || ***** " .. Settings.resName .. " was started! " .. Settings.resVersion .. " *****")

	if (Settings.showCoreDebugInfo == true) then
		sendMessage("Core_S was loaded.")
	end
	
	self:initServer()
	self:initComponents()
end


function Core_S:initServer()
	setFPSLimit(Settings.fpsLimit)
	setGameType(Settings.resName)

	self.m_Update = bind(self.update, self)
	
	if (Settings.advancedDebugMessages == true) then
		self.m_OnDebugMessage = bind(self.onDebugMessage, self)
		addEventHandler("onDebugMessage", root, self.m_OnDebugMessage)
	end
	
	if (not self.updateTimer) then
		self.updateTimer = setTimer(self.m_Update, Settings.serverUpdateInterval, 0)
	end
end


function Core_S:initComponents()
	PlayerManager_S:new()
	NPCManager_S:new()
end


function Core_S:update()
	if (#getElementsByType("player") > 0) then
		local h1, h2, h3 = debug.gethook() 
		debug.sethook() 

		PlayerManager_S:getSingleton():update()
		NPCManager_S:getSingleton():update()
		
		debug.sethook(_, h1, h2, h3) 
	end
end


function Core_S:onDebugMessage(message, level, file, line)
	if level == 1 then
		outputChatBox("ERROR: " .. file .. ":" .. tostring(line) .. ", " .. message, root, 255, 0, 0)
	elseif level == 2 then
		outputChatBox("WARNING: " .. file .. ":" .. tostring(line) .. ", " .. message, root, 255, 165, 0)
	else
		outputChatBox("INFO: " .. file .. ":" .. tostring(line) .. ", " .. message, root, 0, 0, 255)
	end
	
	outputDebugString(debug.traceback())
end


function Core_S:clear()
	if (self.updateTimer) and (self.updateTimer:isValid()) then
		self.updateTimer:destroy()
		self.updateTimer = nil
	end
	
	delete(PlayerManager_S:getSingleton())
	delete(NPCManager_S:getSingleton())
end


function Core_S:destructor()
	self:clear()
	
	if (Settings.advancedDebugMessages == true) then
		removeEventHandler("onDebugMessage", root, self.m_OnDebugMessage)
	end
	
	sendMessage("SERVER || ***** " .. Settings.resName .. " was stopped! " .. Settings.resVersion .. " *****")
	
	if (Settings.showCoreDebugInfo == true) then
		sendMessage("Core_S was deleted.")
	end
end


addEventHandler("onResourceStart", resourceRoot,
function()
	Core_S:new()
end)


addEventHandler("onResourceStop", resourceRoot,
function()
	delete(Core_S:getSingleton())
end)
