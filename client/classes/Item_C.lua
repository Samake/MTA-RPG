Item_C = inherit(Class)

function Item_C:constructor(itemProperties)
	
	self.id = itemProperties.id
	self.itemID = itemProperties.itemID
	self.slotID = itemProperties.slotID
	self.player = itemProperties.player
	self.name = itemProperties.name
	self.description = itemProperties.description
	self.stats = itemProperties.stats
	self.quality = itemProperties.quality
	self.color = itemProperties.color
	self.costs = itemProperties.costs
	self.class = itemProperties.class
	self.icon = itemProperties.icon
	self.stackable = itemProperties.stackable
	self.count = itemProperties.count
	
	self.texture = nil
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Item_C " .. self.itemID .. ", with id " .. self.id .. " was loaded at slot " .. self.slotID .. "!")
	end
end


function Item_C:init()
	if (self.icon) then
		local iconValues = string.split(self.icon, "|")
					
		if (iconValues) then
			if (iconValues[1]) and (iconValues[2]) and (iconValues[3]) then
				if (Textures[iconValues[1]][iconValues[2]][tonumber(iconValues[3])]) then
					if (Textures[iconValues[1]][iconValues[2]][tonumber(iconValues[3])].texture) then
						self.texture = Textures[iconValues[1]][iconValues[2]][tonumber(iconValues[3])].texture
					end
				end
			end
		end
	end
	
	GUIInventory_C:getSingleton():addItem(self)
end


function Item_C:getTexture()
	return self.texture
end


function Item_C:getColor()
	return {r = self.color.r, g = self.color.g, b = self.color.b}
end


function Item_C:getCount()
	return self.count
end


function Item_C:isStackable()
	return self.stackable
end


function Item_C:clear()

end


function Item_C:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("Item_C " .. self.itemID .. ", with id " .. self.id .. " was deleted at slot " .. self.slotID .. "!")
	end
end