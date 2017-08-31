GUIAnimations_C = inherit(Class)

function GUIAnimations_C:constructor(time, type, isLoop)
	self.time = time
	self.type = type
	self.isLoop = isLoop
	
	-- Linear, InQuad, OutQuad, InOutQuad, OutInQuad, InElastic, OutElastic, InOutElastic
	-- OutInElastic, InBack, OutBack, InOutBack, OutInBack, InBounce, OutBounce, InOutBounce
	-- OutInBounce, SineCurve, CosineCurve
	
	self.easingTable = {}
	self.easingTime = self.time
	self.easingTable.startTime = getTickCount()
	self.easingTable.endTime = self.easingTable.startTime + self.easingTime
	self.easingTable.easingFunction = self.type
	self.easingValue = 0
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUIAnimations_C was loaded.")
	end
end


function GUIAnimations_C:init()

end


function GUIAnimations_C:update()
	if (self.easingTable) then
		self.now = getTickCount()
		self.elapsedTime = self.now - self.easingTable.startTime
		self.duration = self.easingTable.endTime - self.easingTable.startTime
		self.progress = self.elapsedTime / self.duration
		self.easingValue = getEasingValue(self.progress, self.easingTable.easingFunction, 0.5, 1, 1.7)
				
		if (self.isLoop == false) then
			if (self.easingValue >= 1) then
				self.easingValue = 1
			end
		end
	end
end


function GUIAnimations_C:reset()
	self.easingTable.startTime = getTickCount()
	self.easingTable.endTime = self.easingTable.startTime + self.easingTime
	self.easingValue = 0
end


function GUIAnimations_C:getFactor()
	return self.easingValue
end


function GUIAnimations_C:clear()

end


function GUIAnimations_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUIAnimations_C was deleted.")
	end
end