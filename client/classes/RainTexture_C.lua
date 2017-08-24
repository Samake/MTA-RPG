RainTexture_C = inherit(Class)

function RainTexture_C:constructor(id)

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.id = id
	
	self.width = self.screenHeight * (math.random(10, 65) / 100)
	self.height = self.width * (math.random(10, 30) / 10)
	
	self.x = math.random(-self.width / 2, self.screenWidth - (self.width / 2))
	self.y = math.random(-self.height, 0)

	self.speed = math.random(8, 25)
	self.alpha = 0
	
	if (Textures["Effects"]["Rain"][1]) then
		if (Textures["Effects"]["Rain"][1].texture) then
			self.texture = Textures["Effects"]["Rain"][1].texture
		end
	end
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("RainTexture_C " .. self.id .. " was loaded.")
	end
end


function RainTexture_C:init()

end


function RainTexture_C:update(deltaTime)
	if (RainManager_C:getSingleton():getRenderTarget()) and (self.texture) then
		self.alpha = RainManager_C:getSingleton():getAlpha()
		
		self.y = self.y + self.speed
		
		if (self.y >= self.screenHeight) then
			RainManager_C:getSingleton():removeParticle(self.id)
		end
		
		dxSetRenderTarget(RainManager_C:getSingleton():getRenderTarget(), false)
		dxSetBlendMode("add")
		dxDrawImage(self.x, self.y, self.width, self.height, self.texture, 0, 0, 0, tocolor(255, 255, 255, self.alpha))
		dxSetBlendMode("blend") 
		dxSetRenderTarget()
	end
end


function RainTexture_C:clear()

end


function RainTexture_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("RainTexture_C " .. self.id .. " was deleted.")
	end
end