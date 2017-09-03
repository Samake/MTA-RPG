Item_S = inherit(Class)

function Item_S:constructor(itemProperties)
	
	self.id = itemProperties.id
	self.slotID = itemProperties.slotID
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
		sendMessage("Item_S " .. self.id .. " was loaded.")
	end
end


function Item_S:init()
	
end


function Item_S:clear()

end


function Item_S:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("Item_S " .. self.id .. " was deleted.")
	end
end