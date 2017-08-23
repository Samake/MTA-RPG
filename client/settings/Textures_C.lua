Textures = {}

Textures["Skins"] = {}
Textures["Skins"]["Head"] = {}
Textures["Skins"]["Head"][1] = {texture = nil, path = "res/textures/skins/head/head_1.png"}

Textures["Skins"]["Torso"] = {}
Textures["Skins"]["Torso"][1] = {texture = nil, path = "res/textures/skins/torso/torso_1.png"}

Textures["Skins"]["Leg"] = {}
Textures["Skins"]["Leg"][1] = {texture = nil, path = "res/textures/skins/leg/leg_1.png"}

Textures["Skins"]["Feet"] = {}
Textures["Skins"]["Feet"][1] = {texture = nil, path = "res/textures/skins/feet/feet_1.png"}

function Textures.init()
	loadSkinTextures()
end


function Textures.cleanUp()
	deleteSkinTextures()
end


function loadSkinTextures()
	for _, section in pairs(Textures["Skins"]) do
		if (section) then
			for _, container in pairs(section) do
				if (container) then
					if (not container.texture) then
						container.texture = dxCreateTexture(container.path)
					end
				end
			end
		end
	end
end


function deleteSkinTextures()
	for _, section in pairs(Textures["Skins"]) do
		if (section) then
			for _, container in pairs(section) do
				if (container) then
					if (container.texture) then
						container.texture:destroy()
						container.texture = nil
					end
				end
			end
		end
	end
	
	Textures["Skins"] = {}
end


