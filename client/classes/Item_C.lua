Item_C = inherit(Class)

function Item_C:constructor(itemProperties)
	
	self.id = itemProperties.id
	self.player = itemProperties.player
	self.name = itemProperties.name
	self.description = itemProperties.id
	self.stats = itemProperties.stats
	self.quality = itemProperties.quality
	self.color = itemProperties.color
	self.costs = itemProperties.costs
	self.class = itemProperties.class
	self.icon = itemProperties.icon
	self.stackable = itemProperties.stackable
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Item_C " .. self.id .. " was loaded.")
	end
end


function Item_C:init()
	
end


function Item_C:clear()

end


function Item_C:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("Item_C " .. self.id .. " was deleted.")
	end
end