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

Textures["World"] = {}
Textures["World"]["Water"] = {}
Textures["World"]["Water"][1] = {texture = nil, path = "res/textures/water/water_caustic_1.png"}
Textures["World"]["Water"][2] = {texture = nil, path = "res/textures/water/water_caustic_2.png"}
Textures["World"]["Water"][3] = {texture = nil, path = "res/textures/water/water_caustic_3.png"}
Textures["World"]["Water"][4] = {texture = nil, path = "res/textures/water/water_caustic_4.png"}
Textures["World"]["Water"][5] = {texture = nil, path = "res/textures/water/water_caustic_5.png"}
Textures["World"]["Water"][6] = {texture = nil, path = "res/textures/water/water_caustic_6.png"}
Textures["World"]["Water"][7] = {texture = nil, path = "res/textures/water/water_caustic_7.png"}
Textures["World"]["Water"][8] = {texture = nil, path = "res/textures/water/water_caustic_8.png"}
Textures["World"]["Water"][9] = {texture = nil, path = "res/textures/water/water_caustic_9.png"}
Textures["World"]["Water"][10] = {texture = nil, path = "res/textures/water/water_caustic_10.png"}
Textures["World"]["Water"][11] = {texture = nil, path = "res/textures/water/water_caustic_11.png"}
Textures["World"]["Water"][12] = {texture = nil, path = "res/textures/water/water_caustic_12.png"}
Textures["World"]["Water"][13] = {texture = nil, path = "res/textures/water/water_caustic_13.png"}
Textures["World"]["Water"][14] = {texture = nil, path = "res/textures/water/water_caustic_14.png"}
Textures["World"]["Water"][15] = {texture = nil, path = "res/textures/water/water_caustic_15.png"}
Textures["World"]["Water"][16] = {texture = nil, path = "res/textures/water/water_caustic_16.png"}


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
	
	for _, section in pairs(Textures["World"]) do
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
	
	for _, section in pairs(Textures["World"]) do
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
	
	Textures["World"] = {}
end


