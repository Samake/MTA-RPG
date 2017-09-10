Renderer_C = inherit(Singleton)

function Renderer_C:constructor(id)
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.bitDepth = 128
	self.outlineStrength = 0.15
	self.saturation = 1.25
	self.brightness = 1.25
	self.contrast = 1.05
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("Renderer_C was loaded.")
	end
end


function Renderer_C:init()
	if (not self.shader) then
		self.shader = dxCreateShader("res/shader/shader_cartoon.hlsl")
	end
end


function Renderer_C:update(deltaTime)
	if (self.shader) then
		self.screenSource = ShaderManager_C:getSingleton():getScreenSource()
		self.renderedGUI = GUIManager_C:getSingleton():getRenderedGUI()
		self.rainResult = RainManager_C:getSingleton():getRenderTarget()
		self.notificationsResult = NotificationManager_C:getSingleton():getRenderTarget()
		
		if (self.screenSource) and (self.renderedGUI) then
			if (Settings.shadersEnabled == true) then
				self.shader:setValue("screenSource", self.screenSource)
				self.shader:setValue("screenSize", {self.screenWidth, self.screenHeight})
				self.shader:setValue("bitDepth", self.bitDepth)
				self.shader:setValue("outlineStrength", self.outlineStrength)
				self.shader:setValue("saturation", self.saturation)
				self.shader:setValue("brightness", self.brightness)
				self.shader:setValue("contrast", self.contrast)

				dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.shader)
			end
			
			if (self.rainResult) then
				dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.rainResult)
			end
			
			if (self.notificationsResult) then
				dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.notificationsResult)
			end
			
			dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.renderedGUI)
		end
	end
end


function Renderer_C:clear()
	if (self.shader) then
		self.shader:destroy()
		self.shader = nil
	end
end


function Renderer_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("Renderer_C " .. self.id .. " was deleted.")
	end
end