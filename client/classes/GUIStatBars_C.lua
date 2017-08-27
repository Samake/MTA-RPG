GUIStatBars_C = inherit(Class)

function GUIStatBars_C:constructor(id)

	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUIStatBars_C was loaded.")
	end
end


function GUIStatBars_C:init()
	self.playerClass = Player_C:getSingleton()
	
	if (not self.xpBar) then
		self.xpBar = dxProgessBar:new(0.2, 0.865, 0.6, 0.02, nil, true)
		self.xpBar:setPostGUI(true)
		self.xpBar:setColor(90, 220, 90)
		self.xpBar:setAlpha(180)
		self.xpBar:setScale(0.9)
	end
	
	if (not self.lifeBar) then
		self.lifeBar = dxProgessBar:new(0.2, 0.84, 0.27, 0.02, nil, true)
		self.lifeBar:setPostGUI(true)
		self.lifeBar:setColor(220, 90, 90)
		self.lifeBar:setAlpha(180)
		self.lifeBar:setScale(0.9)
	end
	
	if (not self.manaBar) then
		self.manaBar = dxProgessBar:new(0.53, 0.84, 0.27, 0.02, nil, true)
		self.manaBar:setPostGUI(true)
		self.manaBar:setColor(90, 90, 220)
		self.manaBar:setAlpha(180)
		self.manaBar:setScale(0.9)
	end
	
	if (not self.levelText) then
		self.levelText = dxText:new("", 0.47, 0.84, 0.06, 0.02, nil, true)
		self.levelText:setPostGUI(true)
		self.levelText:setAlpha(180)
		self.levelText:setScale(1.2)
	end
end


function GUIStatBars_C:update(deltaTime)
	if (self.playerClass) then
		if (self.xpBar) then
			self.xpBar:update()
			
			local value = ((1 / self.playerClass:getMaxXP()) * self.playerClass:getCurrentXP()) or 0
			self.xpBar:setValue(value)
			self.xpBar:setText(self.playerClass:getCurrentXP() .. " / " .. self.playerClass:getMaxXP())
			
			if (self.xpBar:isCursorInside() == true) then
				GUIManager_C:getSingleton():setCursorOnGUIElement(true)
			end
		end
		
		if (self.lifeBar) then
			self.lifeBar:update()
			
			local value = ((1 / self.playerClass:getMaxLife()) * self.playerClass:getCurrentLife()) or 0
			self.lifeBar:setValue(value)
			self.lifeBar:setText(self.playerClass:getCurrentLife() .. " / " .. self.playerClass:getMaxLife())

			if (self.lifeBar:isCursorInside() == true) then
				GUIManager_C:getSingleton():setCursorOnGUIElement(true)
			end
		end
		
		if (self.manaBar) then
			self.manaBar:update()
			
			local value = ((1 / self.playerClass:getMaxMana()) * self.playerClass:getCurrentMana()) or 0
			self.manaBar:setValue(value)
			self.manaBar:setText(self.playerClass:getCurrentMana() .. " / " .. self.playerClass:getMaxMana())
			
			if (self.manaBar:isCursorInside() == true) then
				GUIManager_C:getSingleton():setCursorOnGUIElement(true)
			end
		end
		
		if (self.levelText) then
			self.levelText:update()

			self.levelText:setText("#FFFFFFLvl. #FFDD77" .. self.playerClass:getLevel())
		end
	end
end


function GUIStatBars_C:clear()
	if (self.xpBar) then
		self.xpBar:delete()
		self.xpBar = nil
	end
	
	if (self.lifeBar) then
		self.lifeBar:delete()
		self.lifeBar = nil
	end
	
	if (self.manaBar) then
		self.manaBar:delete()
		self.manaBar = nil
	end
	
	if (self.levelText) then
		self.levelText:delete()
		self.levelText = nil
	end
end


function GUIStatBars_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUIStatBars_C was deleted.")
	end
end