Renderer_C = inherit(Singleton)

function Renderer_C:constructor()
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.outlineStrength = 0.2
	self.shadowModifier = 0.8
	self.saturation = 1.5
	self.brightness = 1.1
	self.contrast = 0.8
	self.blurStrength = 0.0
	
	self.currentBlurStrength = self.blurStrength
	self.currentSaturation = self.saturation
	self.currentBrightness = self.brightness
	self.currentContrast = self.contrast
	
	self.targetBlurStrength = self.blurStrength
	self.targetSaturation = self.saturation
	self.targetBrightness = self.brightness
	self.targetContrast = self.contrast

	
	self.isFaded = false
	
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
	
	if (not self.blurShader) then
		self.blurShader = dxCreateShader("res/shader/shader_blur.hlsl")
	end
	
	if (not self.mixShader) then
		self.mixShader = dxCreateShader("res/shader/shader_mix_pp.hlsl")
	end
	
	if (not self.playerCutShader) then
		self.playerCutShader = dxCreateShader("res/shader/shader_player_cut.hlsl")
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
	
	if (not self.renderTargetBlur) then
		self.renderTargetBlur = dxCreateRenderTarget(self.screenWidth, self.screenHeight, true)
	end
	
	if (not self.renderTargetMixed) then
		self.renderTargetMixed = dxCreateRenderTarget(self.screenWidth, self.screenHeight, true)
	end
	
	if (not self.renderTargetPlayerCut) then
		self.renderTargetPlayerCut = dxCreateRenderTarget(self.screenWidth, self.screenHeight, true)
	end
	
	if (not self.renderTargetFinal) then
		self.renderTargetFinal = dxCreateRenderTarget(self.screenWidth, self.screenHeight, true)
	end
end


function Renderer_C:update(deltaTime)
	if (self.outlineShader) and (self.bloomShader) and (self.blurShader) and (self.finalShader) and (self.mixShader) and (self.playerCutShader) and (self.renderTargetOutline) and (self.renderTargetBloom) and (self.renderTargetBlur) and (self.renderTargetPlayerCut) and (self.renderTargetMixed) and (self.renderTargetFinal) then
		self:fadeValues()
		
		self.screenSource = ShaderManager_C:getSingleton():getScreenSource()
		self.renderedGUI = GUIManager_C:getSingleton():getRenderedGUI()
		self.rainResult = RainManager_C:getSingleton():getRenderTarget()
		self.notificationsResult = NotificationManager_C:getSingleton():getRenderTarget()
		
		if (self.screenSource) and (self.renderedGUI) then
			if (Settings.shadersEnabled == true) then
				
				-- ## OUTLINE ## -- 
				dxSetRenderTarget(self.renderTargetOutline, true)
					self.outlineShader:setValue("screenSource", self.screenSource)
					self.outlineShader:setValue("screenSize", {self.screenWidth, self.screenHeight})
					self.outlineShader:setValue("outlineStrength", self.outlineStrength)
					
					dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.outlineShader)
				dxSetRenderTarget()
				
				-- ## Bloom ## -- 
				dxSetRenderTarget(self.renderTargetBloom, true)
					self.bloomShader:setValue("screenSource", self.screenSource)
					
					dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.bloomShader)
				dxSetRenderTarget()
				
				-- ## Mix ## -- 
				dxSetRenderTarget(self.renderTargetMixed, true)				
					self.mixShader:setValue("outlineSource", self.renderTargetOutline)
					self.mixShader:setValue("bloomSource", self.renderTargetBloom)
					
					dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.mixShader)
				dxSetRenderTarget()
				
				-- ## PlayerCut ## -- 
				if (GUIManager_C:getSingleton():isShowInventory() == true) then
					dxSetRenderTarget(self.renderTargetPlayerCut, true)				
						self.playerCutShader:setValue("screenSource", self.renderTargetMixed)
						
						dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.playerCutShader)
					dxSetRenderTarget()
				end
				
				-- ## Blur ## -- 
				dxSetRenderTarget(self.renderTargetBlur, true)
					self.blurShader:setValue("screenSource", self.renderTargetMixed)
					self.blurShader:setValue("screenSize", {self.screenWidth, self.screenHeight})
					self.blurShader:setValue("blurStrength", self.currentBlurStrength)
					
					dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.blurShader)
				dxSetRenderTarget()

				-- ## Final ## -- 
				dxSetRenderTarget(self.renderTargetFinal, true)
					self.finalShader:setValue("screenResult", self.renderTargetBlur)
					self.finalShader:setValue("saturation", self.currentSaturation)
					self.finalShader:setValue("brightness", self.currentBrightness)
					self.finalShader:setValue("contrast", self.currentContrast)
					
					dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.finalShader)
				dxSetRenderTarget()
				
				-- ## Draw Result ## -- 
				dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.renderTargetFinal)
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


function Renderer_C:fadeValues()
	if (self.isFaded == false) then
		self.targetBlurStrength = self.blurStrength
		self.targetSaturation = self.saturation
		self.targetBrightness = self.brightness
		self.targetContrast = self.contrast
	else
		self.targetBlurStrength = 6.0
		self.targetSaturation = self.saturation * 2.0
		self.targetBrightness = self.brightness * 0.8
		self.targetContrast = self.contrast * 1.3
	end
	
	if (self.currentBlurStrength < self.targetBlurStrength) then
		self.currentBlurStrength = self.currentBlurStrength + 0.25
		
		if (self.currentBlurStrength >= self.targetBlurStrength) then
			self.currentBlurStrength = self.targetBlurStrength
		end
	end
	
	if (self.currentBlurStrength > self.targetBlurStrength) then
		self.currentBlurStrength = self.currentBlurStrength - 0.25
		
		if (self.currentBlurStrength <= self.targetBlurStrength) then
			self.currentBlurStrength = self.targetBlurStrength
		end
	end
	
	if (self.currentSaturation < self.targetSaturation) then
		self.currentSaturation = self.currentSaturation + 0.25
		
		if (self.currentSaturation >= self.targetSaturation) then
			self.currentSaturation = self.targetSaturation
		end
	end
	
	if (self.currentSaturation > self.targetSaturation) then
		self.currentSaturation = self.currentSaturation - 0.25
		
		if (self.currentSaturation <= self.targetSaturation) then
			self.currentSaturation = self.targetSaturation
		end
	end
	
	if (self.currentBrightness < self.targetBrightness) then
		self.currentBrightness = self.currentBrightness + 0.25
		
		if (self.currentBrightness >= self.targetBrightness) then
			self.currentBrightness = self.targetBrightness
		end
	end
	
	if (self.currentBrightness > self.targetBrightness) then
		self.currentBrightness = self.currentBrightness - 0.25
		
		if (self.currentBrightness <= self.targetBrightness) then
			self.currentBrightness = self.targetBrightness
		end
	end
	
	if (self.currentContrast < self.targetContrast) then
		self.currentContrast = self.currentContrast + 0.25
		
		if (self.currentContrast >= self.targetContrast) then
			self.currentContrast = self.targetContrast
		end
	end
	
	if (self.currentContrast > self.targetContrast) then
		self.currentContrast = self.currentContrast - 0.25
		
		if (self.currentContrast <= self.targetContrast) then
			self.currentContrast = self.targetContrast
		end
	end
end


function Renderer_C:fadeScreen(bool)
	self.isFaded = bool
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
	
	if (self.blurShader) then
		self.blurShader:destroy()
		self.blurShader = nil
	end
	
	if (self.mixShader) then
		self.mixShader:destroy()
		self.mixShader = nil
	end
	
	if (self.playerCutShader) then
		self.playerCutShader:destroy()
		self.playerCutShader = nil
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
	
	if (self.renderTargetBlur) then
		self.renderTargetBlur:destroy()
		self.renderTargetBlur = nil
	end
	
	if (self.renderTargetMixed) then
		self.renderTargetMixed:destroy()
		self.renderTargetMixed = nil
	end
	
	if (self.renderTargetPlayerCut) then
		self.renderTargetPlayerCut:destroy()
		self.renderTargetPlayerCut = nil
	end
	
	if (self.renderTargetFinal) then
		self.renderTargetFinal:destroy()
		self.renderTargetFinal = nil
	end
end


function Renderer_C:getShadowModifier()
	return self.shadowModifier
end


function Renderer_C:getMixedScreenResult()
	return self.renderTargetMixed
end


function Renderer_C:getPlayerCutScreenResult()
	return self.renderTargetPlayerCut
end


function Renderer_C:getFinalScreenResult()
	return self.renderTargetFinal
end


function Renderer_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("Renderer_C " .. self.id .. " was deleted.")
	end
end