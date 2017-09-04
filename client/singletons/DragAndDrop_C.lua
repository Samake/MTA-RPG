DragAndDrop_C = inherit(Singleton)

function DragAndDrop_C:constructor()
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("DragAndDrop_C was loaded.")
	end
end


function DragAndDrop_C:init()

end


function DragAndDrop_C:update(deltaTime)

end


function DragAndDrop_C:clear()

	NotificationManager_C:getSingleton():addNotification("#EEEEEE Debug mode #EE4444 disabled #EEEEEE!")
end


function DragAndDrop_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("DragAndDrop_C was deleted.")
	end
end