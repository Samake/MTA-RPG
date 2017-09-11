Renderer_C = inherit(Singleton)

function Renderer_C:constructor(id)
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.outlineStrength = 0.15
	self.saturation = 1.5
	self.brightness = 1.1
	self.contrast = 0.8
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("Renderer_C was loaded.")
	end
end


function Renderer_C:init()
	if (not self.outlineShader) then
		self.outlineShader = dxCreateShader("res/shader/shader_outline.hlsl")
	end
	
	if (not self.bloomShader) then
		self.bloomShader = dxCreateShader("res/shader/shader_bloom.hlsl")
	end
	
	if (not self.finalShader) then
		self.finalShader = dxCreateShader("res/shader/shader_final_pp.hlsl")
	end
	
	if (not self.renderTargetOutline) then
		self.renderTargetOutline = dxCreateRenderTarget(self.screenWidth, self.screenHeight, true)
	end
	
	if (not self.renderTargetBloom) then
		self.renderTargetBloom = dxCreateRenderTarget(self.screenWidth, self.screenHeight, true)
	end
end


function Renderer_C:update(deltaTime)
	if (self.outlineShader) and (self.bloomShader) and (self.finalShader) and (self.renderTargetOutline) and (self.renderTargetBloom) then
		self.screenSource = ShaderManager_C:getSingleton():getScreenSource()
		self.renderedGUI = GUIManager_C:getSingleton():getRenderedGUI()
		self.rainResult = RainManager_C:getSingleton():getRenderTarget()
		self.notificationsResult = NotificationManager_C:getSingleton():getRenderTarget()
		
		if (self.screenSource) and (self.renderedGUI) then
			if (Settings.shadersEnabled == true) then
				dxSetRenderTarget(self.renderTargetOutline, true)
				
				self.outlineShader:setValue("screenSource", self.screenSource)
				self.outlineShader:setValue("screenSize", {self.screenWidth, self.screenHeight})
				self.outlineShader:setValue("outlineStrength", self.outlineStrength)
				
				dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.outlineShader)
				
				dxSetRenderTarget()
				
				dxSetRenderTarget(self.renderTargetBloom, true)
				
				self.bloomShader:setValue("screenSource", self.screenSource)
				
				dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.bloomShader)
				
				dxSetRenderTarget()

				self.finalShader:setValue("outlineSource", self.renderTargetOutline)
				self.finalShader:setValue("bloomSource", self.renderTargetBloom)
				self.finalShader:setValue("saturation", self.saturation)
				self.finalShader:setValue("brightness", self.brightness)
				self.finalShader:setValue("contrast", self.contrast)

				dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.finalShader)
			end
			
			if (self.rainResult) then
				dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.rainResult)
			end
			
			if (self.notificationsResult) then
				dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.notificationsResult)
			end
			
			if (self.renderedGUI) then
				dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.renderedGUI)
			end
		end
	end
end


function Renderer_C:clear()
	if (self.outlineShader) then
		self.outlineShader:destroy()
		self.outlineShader = nil
	end
	
	if (self.bloomShader) then
		self.bloomShader:destroy()
		self.bloomShader = nil
	end
	
	if (self.finalShader) then
		self.finalShader:destroy()
		self.finalShader = nil
	end
	
	if (self.renderTargetOutline) then
		self.renderTargetOutline:destroy()
		self.renderTargetOutline = nil
	end
	
	if (self.renderTargetBloom) then
		self.renderTargetBloom:destroy()
		self.renderTargetBloom = nil
	end
end


function Renderer_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("Renderer_C " .. self.id .. " was deleted.")
	end
end