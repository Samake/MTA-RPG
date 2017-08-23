Player_S = inherit(Class)

function Player_S:constructor(playerSettings)
	
	self.id = playerSettings.id
	self.player = playerSettings.player
	self.x = 0
	self.y = 0
	self.z = 0
	self.rx = 0
	self.ry = 0
	self.rz = 0
	
	self.skinID = 0
	self.dimension = 0
	
	self.targetX = nil
	self.targetY = nil
	self.targetZ = nil
	
	self.minDistance = 0
	self.distance = 0
	self.tolerance = 1.0
	
	self.headID = 1
	self.torsoID = 1
	self.legID = 1
	self.feetID = 1
	
	self.state = "idle"

	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Player_S " .. self.id .. " was loaded.")
	end
end


function Player_S:init()
	self.m_SetTargetPosition = bind(self.setTargetPosition, self)
	addEvent("SETPLAYERTARGET", true)
	addEventHandler("SETPLAYERTARGET", root, self.m_SetTargetPosition)
	
	
	if (self.player) then
		--self.player:spawn(self.x, self.y, self.z + 5, self.rz, self.skinID, 0, self.dimension)
	end
end


function Player_S:update()
	if (self.player) and (isElement(self.player)) then
		self:updateCoords()
		self:updatePosition()
		
		if (self.state == "run") then
			self:correctPosition()
		end
	end
end


function Player_S:updateCoords()
	self.playerPos = self.player:getPosition()
	
	if (self.playerPos) then
		self.x = self.playerPos.x
		self.y = self.playerPos.y
		self.z = self.playerPos.z
	end
	
	self.playerRot = self.player:getRotation()
	
	if (self.playerRot) then
		self.rx = self.playerRot.x
		self.ry = self.playerRot.y
		self.rz = self.playerRot.z
	end
end


function Player_S:updatePosition()
	if (self.targetX) and (self.targetY) and (self.targetZ) then
		self.distance = getDistanceBetweenPoints2D(self.x, self.y, self.targetX, self.targetY)
		
		if (self.distance <= self.tolerance) then
			self:jobIdle()
		end
	end
end


function Player_S:correctPosition()
	if (self.player) and (isElement(self.player)) then
		if (self.distance <= self.minDistance) then
			self.minDistance = self.distance
		else
			local rotZ = findRotation(self.x, self.y, self.targetX, self.targetY)
			self.player:setRotation(self.rx, self.ry, rotZ, "default", true)
		end
	end
end


function Player_S:setTargetPosition(x, y, z)
	if (self.player) and (isElement(self.player)) then
			if (self.player == client) and (x) and (y) and (z) then
			self.targetX = x
			self.targetY = y
			self.targetZ = z
			
			local rotZ = findRotation(self.x, self.y, self.targetX, self.targetY)
			self.player:setRotation(self.rx, self.ry, rotZ, "default", true)
			
			self.distance = getDistanceBetweenPoints2D(self.x, self.y, self.targetX, self.targetY)
			self.minDistance = getDistanceBetweenPoints2D(self.x, self.y, self.targetX, self.targetY)
			
			self:jobRun()
		end
	end
end


function Player_S:jobIdle()
	if (self.player) and (isElement(self.player)) then
		self.player:setAnimation()
		self.targetX = nil
		self.targetY = nil
		self.targetZ = nil
		self.state = "idle"
	end
end


function Player_S:jobRun()
	if (self.player) and (isElement(self.player)) then
		self.player:setAnimation("ped", "run_player")
		self.state = "run"
	end
end


function Player_S:clear()
	removeEventHandler("SETPLAYERTARGET", root, self.m_SetTargetPosition)
	
	self:jobIdle()
end


function Player_S:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("Player_S " .. self.id .. " was deleted.")
	end
end