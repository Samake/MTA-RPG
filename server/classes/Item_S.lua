Item_S = inherit(Class)

function Item_S:constructor(itemProperties)
	
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
	self.slot = itemProperties.slot
	self.clothes = itemProperties.clothes
	self.class = itemProperties.class
	self.icon = itemProperties.icon
	self.stackable = itemProperties.stackable
	self.count = itemProperties.count
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Item_S " .. self.itemID .. ", with id " .. self.id .. " was loaded at slot " .. self.slotID .. "!")
	end
end


function Item_S:init()
	
end


function Item_S:clear()

end


function Item_S:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("Item_S " .. self.itemID .. ", with id " .. self.id .. " was deleted at slot " .. self.slotID .. "!")
	end
end