AnimatedTexture_C = inherit(Class)

function AnimatedTexture_C:constructor(textureProperties)
	
	self.id = textureProperties.id
	self.texture = textureProperties.texture
	self.size = textureProperties.size
	self.columns = textureProperties.columns
	self.rows = textureProperties.rows
	
	self.currentColumn = 0
	self.currentRow = 0
		
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("AnimatedTexture_C " .. self.id .. " was started.")
	end
end


function AnimatedTexture_C:init()
	if (not self.renderTarget) then
		self.renderTarget = dxCreateRenderTarget(self.size, self.size, true)
	end
end


function AnimatedTexture_C:update(delta)
	if (self.texture) and (self.renderTarget) then
		self.currentColumn = self.currentColumn + 1
		
		if (self.currentColumn > self.columns - 1) then
			self.currentColumn = 0
			
			self.currentRow = self.currentRow + 1
			
			if (self.currentRow > self.rows - 1) then
				self.currentRow = 0
			end
		end
		
		local u = self.size * self.currentColumn
		local v = self.size * self.currentRow
		
		dxSetRenderTarget(self.renderTarget, true)
		dxDrawImageSection(0, 0, self.size, self.size, u, v, self.size, self.size, self.texture)
		dxSetRenderTarget()
	end
end


function AnimatedTexture_C:getTexture()
	return self.renderTarget
end


function AnimatedTexture_C:clear()
	if (self.renderTarget) then
		self.renderTarget:destroy()
		self.renderTarget = nil
	end
end


function AnimatedTexture_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("AnimatedTexture_C " .. self.id .. " was deleted.")
	end
end