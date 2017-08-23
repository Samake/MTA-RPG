XMLManager_C = inherit(Singleton)

function XMLManager_C:constructor()

	self.path = "userSettings/settings.xml"
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("XMLManager_C was loaded.")
	end
end


function XMLManager_C:init()
	self.file = xmlLoadFile(self.path)
	
	if (not self.file) then
		local newFile = xmlCreateFile(self.path, "ShaderSettings")
		
		if (newFile) then
			xmlSaveFile(newFile)
			xmlUnloadFile(newFile)
		end

		if (not self.file) then
			sendMessage("ERROR || XML settings were not created!")
		end
	end
end


function XMLManager_C:getSettingsForShader(name)
	if (name) then
		self.file = xmlLoadFile(self.path)
		
		local shaderNode = xmlFindChild(self.file, name, 0)
		
		if (shaderNode) then
			local childs = xmlNodeGetChildren(shaderNode)
			
			if (childs) then
				local settingsTable = {}
				
				for index, child in pairs(childs) do
					if (child) then
						settingsTable[xmlNodeGetName(child)] = xmlNodeGetValue(child)  
					end
				end
				
				xmlSaveFile(self.file)
				xmlUnloadFile(self.file)
				
				return settingsTable
			end
		end
	end
	
	return nil
end


function XMLManager_C:setSettingsForShader(name, settings)
	if (name) and (settings) then
		self.file = xmlLoadFile(self.path)
		
		local shaderNode = xmlFindChild(self.file, name, 0)
		
		if (shaderNode) then
			for index, value in pairs(settings) do
				if (value) then
					local node = xmlFindChild(shaderNode, index, 0)
					
					if (node) then
						xmlNodeSetValue(node, value)
					end
				end
			end
		end
		  
		xmlSaveFile(self.file)
		xmlUnloadFile(self.file)
	end
end


function XMLManager_C:createSettingsForShader(name, settings)
	if (name) and (settings) then
		self.file = xmlLoadFile(self.path)
		
		local shaderNode = xmlCreateChild(self.file, name)
		
		if (shaderNode) then
			for index, value in pairs(settings) do
				if (value) then
					local node = xmlCreateChild(shaderNode, index)
					
					if (node) then
						xmlNodeSetValue(node, value)
					end
				end
			end
		end
		
		xmlSaveFile(self.file)
		xmlUnloadFile(self.file)
	end
end


function XMLManager_C:clear()

end


function XMLManager_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("XMLManager_C was deleted.")
	end
end