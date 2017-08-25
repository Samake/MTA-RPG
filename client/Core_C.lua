Core_C = inherit(Singleton)

function Core_C:constructor()
	if (Settings.showCoreDebugInfo == true) then
		sendMessage("Core_C was loaded.")
	end

	self.showMTAHUD = false

	self:initClient()
	self:initComponents()
end


function Core_C:initClient()
	setDevelopmentMode(true, true)
	setPedTargetingMarkerEnabled(false)
	
	self.m_ToggleDebug = bind(self.toggleDebug, self)
	bindKey(Bindings["DEBUG"], "down", self.m_ToggleDebug)
	
	self.m_Update = bind(self.update, self)
	addEventHandler("onClientPreRender", root, self.m_Update)
end


function Core_C:initComponents()
	
	Textures.init()
	
	XMLManager_C:new()
	ClickSystem_C:new()
	CameraManager_C:new()
	ShaderManager_C:new()
	GUIManager_C:new()
	MousePointer_C:new()
	Player_C:new()
	WeatherManager_C:new()
end


function Core_C:toggleDebug()
	Settings.debugEnabled = not Settings.debugEnabled
end


function Core_C:update(deltaTime)
	setPlayerHudComponentVisible("all", self.showMTAHUD)
	
	if (deltaTime) then
		self.delta = (1 / 17) * deltaTime
	end
	
	ClickSystem_C:getSingleton():update(self.delta)
	CameraManager_C:getSingleton():update(self.delta)
	ShaderManager_C:getSingleton():update(self.delta)
	GUIManager_C:getSingleton():update(self.delta)
	MousePointer_C:getSingleton():update(self.delta)
	Player_C:getSingleton():update(self.delta)
	WeatherManager_C:getSingleton():update(self.delta)
end


function Core_C:clear()
	removeEventHandler("onClientPreRender", root, self.m_Update)
	unbindKey(Bindings["DEBUG"], "down", self.m_ToggleDebug)
	
	setDevelopmentMode(false, false)
	setPlayerHudComponentVisible("all", true)
	setPedTargetingMarkerEnabled(true)
	
	delete(ClickSystem_C:getSingleton())
	delete(Player_C:getSingleton())
	delete(CameraManager_C:getSingleton())
	delete(ShaderManager_C:getSingleton())
	delete(GUIManager_C:getSingleton())
	delete(MousePointer_C:getSingleton())
	delete(Player_C:getSingleton())
	delete(XMLManager_C:getSingleton())
	delete(WeatherManager_C:getSingleton())
end


function Core_C:destructor()
	self:clear()
	
	Textures.cleanUp()
	
	if (Settings.showCoreDebugInfo == true) then
		sendMessage("Core_C was deleted.")
	end
end


addEventHandler("onClientResourceStart", resourceRoot,
function()
	Core_C:new()
end)


addEventHandler("onClientResourceStop", resourceRoot,
function()
	delete(Core_C:getSingleton())
end)
