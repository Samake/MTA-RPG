NameTags_C = inherit(Class)

function NameTags_C:constructor()
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.player = getLocalPlayer()
	
	self.maxDistance = 150
	self.minScale = 0.3
	self.maxScale = 8.0
	self.minAlpha = 32
	self.maxAlpha = Settings.guiAlpha
	
	self.width = self.screenWidth * 0.075
	self.height = self.width * 0.2
	
	self.postGUI = true
	self.subPixelPositioning = true
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("NameTags_C was started.")
	end
end


function NameTags_C:init()

end


function NameTags_C:update(delta)
	for index, ped in pairs(getElementsByType("ped")) do
		if (ped) and (isElement(ped)) then
			
			local lifeValue = tonumber(ped:getData("NPC:LIFEVALUE")) or 1
				
			if (lifeValue > 0) then
			
				local npcName = ped:getData("NPC:NAME") or "Unknown"
				local npcLevel = ped:getData("NPC:LEVEL") or 1
				local cx, cy, cz = getCameraMatrix()
				local pedPos = ped:getPosition()
				local distance = getDistanceBetweenPoints3D(cx, cy, cz, pedPos.x, pedPos.y, pedPos.z)
				
				if (distance <= self.maxDistance) then
					local ntx, nty = getScreenFromWorldPosition(pedPos.x, pedPos.y, pedPos.z + 1.5)
					local scale = self:getScale(distance)
					local alpha = self:getAlpha(distance)
					local shadowOffset = 1 * scale

					if (ntx) and (nty) and (isLineOfSightClear(cx, cy, cz, pedPos.x, pedPos.y, pedPos.z + 1, true, true, false)) then
						if (not isLineOfSightClear(cx, cy, cz, pedPos.x, pedPos.y, pedPos.z + 1, true, true, true)) then
							alpha = alpha * 0.4
						end
						
						local width = self.width * scale
						local height = (self.height / 4) * scale

						-- // name // --
						local x = ntx
						local y = nty + height
						
						dxDrawRectangle((x - width / 2), (y - height / 2) + (15 * scale), width, height, tocolor(0, 0, 0, alpha), self.postGUI, self.subPixelPositioning)
						
						if (lifeValue > 0) then
							dxDrawRectangle((x - width / 2) + (2 * scale), (y - height / 2) + (16 * scale), (width * lifeValue) - (2 * scale), height - (2 * scale), tocolor(255 - (165 * lifeValue), 220 * lifeValue, 90, alpha), self.postGUI, self.subPixelPositioning)
						end
						
						dxDrawText(npcName .. " / Lvl. " .. npcLevel, (x - width / 2) + shadowOffset, (y - height / 2) + shadowOffset, (x + width / 2) + shadowOffset, (y + height / 2) + shadowOffset, tocolor(0, 0, 0, alpha), scale, "default-bold", "center", "center", false, false, self.postGUI, false, self.subPixelPositioning)
						dxDrawText(npcName .. " / Lvl. " .. npcLevel, (x - width / 2), (y - height / 2), (x + width / 2), (y + height / 2), tocolor(255, 255, 255, alpha), scale, "default-bold", "center", "center", false, false, self.postGUI, true, self.subPixelPositioning)
					end
				end
			end
		end
	end
end


function NameTags_C:getScale(distanceValue)
    local scaleVar = (self.maxDistance * self.minScale) / (distanceValue * self.maxScale)
    
    if (scaleVar <= self.minScale) then
        scaleVar = self.minScale
    elseif (scaleVar >= self.maxScale) then
        scaleVar = self.maxScale 
    end
	
    return scaleVar
end


function NameTags_C:getAlpha(distanceValue)
	local alphaVar = self.maxAlpha - ((self.maxAlpha / self.maxDistance) * distanceValue)
    
    if (alphaVar <= self.minAlpha) then
        alphaVar = self.minAlpha
    elseif (alphaVar >= self.maxAlpha) then
        alphaVar = self.maxAlpha 
    end

    return alphaVar
end


function NameTags_C:clear()
	if (self.renderTarget) then
		self.renderTarget:destroy()
		self.renderTarget = nil	
	end
end


function NameTags_C:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("NameTags_C was deleted.")
	end
end