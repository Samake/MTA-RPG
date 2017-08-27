NameTags_C = inherit(Class)

function NameTags_C:constructor()
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.player = getLocalPlayer()
	
	self.maxNameTagDistance = 150
	self.minNameTagScale = 0.3
	self.maxNameTagScale = 8.0
	self.minNameTagAlpha = 32
	self.maxNameTagAlpha = Settings.guiAlpha
	
	self.nameTagWidth = self.screenWidth * 0.075
	self.nameTagHeight = self.nameTagWidth * 0.2
	
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
				
				if (distance <= self.maxNameTagDistance) then
					local ntx, nty = getScreenFromWorldPosition(pedPos.x, pedPos.y, pedPos.z + 1.5)
					local scale = self:getNameTagScale(distance)
					local alpha = self:getNameTagAlpha(distance)
					local shadowOffset = 1 * scale

					if (ntx) and (nty) and (isLineOfSightClear(cx, cy, cz, pedPos.x, pedPos.y, pedPos.z + 1, true, true, false)) then
						if (not isLineOfSightClear(cx, cy, cz, pedPos.x, pedPos.y, pedPos.z + 1, true, true, true)) then
							alpha = alpha * 0.4
						end
						
						local width = self.nameTagWidth * scale
						local height = (self.nameTagHeight / 4) * scale

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


function NameTags_C:getNameTagScale(distanceValue)
    local scaleVar = (self.maxNameTagDistance * self.minNameTagScale) / (distanceValue * self.maxNameTagScale)
    
    if (scaleVar <= self.minNameTagScale) then
        scaleVar = self.minNameTagScale
    elseif (scaleVar >= self.maxNameTagScale) then
        scaleVar = self.maxNameTagScale 
    end
	
    return scaleVar
end


function NameTags_C:getNameTagAlpha(distanceValue)
	local alphaVar = self.maxNameTagAlpha - ((self.maxNameTagAlpha / self.maxNameTagDistance) * distanceValue)
    
    if (alphaVar <= self.minNameTagAlpha) then
        alphaVar = self.minNameTagAlpha
    elseif (alphaVar >= self.maxNameTagAlpha) then
        alphaVar = self.maxNameTagAlpha 
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