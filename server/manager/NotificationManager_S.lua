NotificationManager_S = inherit(Singleton)

function NotificationManager_S:constructor()

	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("NotificationManager_S was loaded.")
	end
end


function NotificationManager_S:init()

end


function NotificationManager_S:sendPlayerNotification(player, text)
	if (text) then
		if (player) then
			triggerClientEvent(player, "SENDNOTIFICATION", player, text)
		end
	end
end


function NotificationManager_S:sendAllNotification(text)
	if (text) then
		triggerClientEvent(root, "SENDNOTIFICATION", root, text)
	end
end


function NotificationManager_S:clear()

end


function NotificationManager_S:destructor()
	self:clear()

	if (Settings.showManagerDebugInfo == true) then
		sendMessage("NotificationManager_S was deleted.")
	end
end