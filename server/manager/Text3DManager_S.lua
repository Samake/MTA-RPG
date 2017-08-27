Text3DManager_S = inherit(Singleton)

function Text3DManager_S:constructor()

	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("Text3DManager_S was loaded.")
	end
end


function Text3DManager_S:init()

end


function Text3DManager_S:sendText(player, text, x, y, z, r, g, b, size)
	if (text) and (x) and (y) and (z) then
		local textProperties = {}
		textProperties.text = text
		textProperties.x = x + (math.random(-50, 50) / 100)
		textProperties.y = y + (math.random(-50, 50) / 100)
		textProperties.z = z + (math.random(0, 100) / 100)
		textProperties.r = r or 255
		textProperties.g = g or 255
		textProperties.b = b or 255
		textProperties.size = size or 1
		
		if (not player) then player = root end
		triggerClientEvent(player, "DRAW3DTEXT", player, textProperties)
	end
end


function Text3DManager_S:clear()

end


function Text3DManager_S:destructor()
	self:clear()

	if (Settings.showManagerDebugInfo == true) then
		sendMessage("Text3DManager_S was deleted.")
	end
end