-- ----------------------------------------------------------------------------
--  <github.com/httpRick> wrote this code. As long as you retain this 
-- notice, you can do whatever you want with this stuff. If we
-- meet someday, and you think this stuff is worth it, you can
-- buy me a beer in return.
-- ----------------------------------------------------------------------------


local DataTexture = "GameTexture" -- Your Texture Data
local Cache = {}
Cache.stream = {}
Cache.object = {}
Cache.shader = {}
Cache.texture = {}

function onClientInitTexture()
	for index, thisObject in ipairs(getElementsByType("object")) do
		if isElementStreamable(thisObject) then
			local SATexture = getElementData(thisObject, DataTexture)
			if SATexture then
				Cache.stream[thisObject] = true
				engineApplyTexture(thisObject, SATexture)
			end
		end
	end
end
addEventHandler( "onClientResourceStart", getResourceRootElement(getThisResource()), onClientInitTexture)

function getTextureNameFromString(modelTextureNames, name)
	for i,v in pairs(modelTextureNames) do
		if v == name then
			return v
		end
	end
	return false
end

function getShaderFormTextureName(texture, index, layred)
	if not Cache.shader[texture] then
		Cache.shader[texture] = {counter = 0}
	end
	if not Cache.shader[texture][index] then
		Cache.shader[texture][index] = shaderManager(Cache.shader[texture].counter, layred)
		Cache.shader[texture].counter = Cache.shader[texture].counter+1
	end
	return Cache.shader[texture][index]
end

function getTextureFromName(name)
	if not Cache.texture[name] then
		Cache.texture[name] = textureManager(name)
	end
	return Cache.texture[name]
end

function engineApplyTexture(thisObject, SATexture)
	if getElementType(thisObject) == "object" and type(SATexture) == "table" then
		local modelTextureNames = engineGetModelTextureNames( tostring( getElementModel( thisObject ) ) )
		local textureName
		for i,v in pairs(SATexture) do
			if tonumber(v.index) then
				textureName = modelTextureNames[tonumber(v.index)]
			else
				textureName = getTextureNameFromString(modelTextureNames, v.index)
			end
			if textureName and v.texture then
				local shader, texture = getShaderFormTextureName(v.texture, textureName, v.layred), getTextureFromName(v.texture)
				if shader and texture then
					if type(Cache.object[thisObject]) ~= "table" then
						Cache.object[thisObject] = {}
					end
					Cache.object[thisObject][textureName] = {texture = texture, shader = shader}
					shader:setBrightess(v.brightness or 1.0)
					shader:setColor(v.red or 0, v.green or 0, v.blue or 0)
					shader:setTexture(texture.this)
					shader:engineApplyWorldTexture(textureName, thisObject)
				end
			end
		end
	end
end

function refreshTexture(thisObject, nowTable, oldTable)
	if Cache.object[thisObject] and type(nowTable) == "table" and type(oldTable) == "table" and not table.compare(nowTable, oldTable) and isElementStreamable(thisObject) then
		local changeTable = {}
		local modelTextureNames = engineGetModelTextureNames( tostring( getElementModel( thisObject ) ) )
		for i,oldData in ipairs(oldTable) do
			for i,nowData in ipairs(nowTable) do
				if oldData.index == nowData.index then
					if oldData.red ~= nowData.red or oldData.green ~= nowData.green or oldData.blue ~= nowData.blue or oldData.brightness ~= nowData.brightness or (oldData.texture ~= nowData.texture and nowData.texture ~= false) then
						table.insert(changeTable, nowData)
					elseif oldData.texture ~= nowData.texture and nowData.texture == false then
						if tonumber(nowData.index) then
							textureName = modelTextureNames[tonumber(nowData.index)]
						else
							textureName = getTextureNameFromString(modelTextureNames, nowData.index)
						end
						engineRemoveTexture(thisObject, textureName)
					end
				end
			end
		end
		for i,v in ipairs(changeTable) do
			local textureName
			if tonumber(v.index) then
				textureName = modelTextureNames[tonumber(v.index)]
			else
				textureName = getTextureNameFromString(modelTextureNames, v.index)
			end
			if Cache.object[thisObject][textureName] then
				if v.texture and (v.texture == false or v.texture == nil) then
					local modelTextureNames = engineGetModelTextureNames( tostring( getElementModel( thisObject ) ) )
					if tonumber(v.index) then
						textureName = modelTextureNames[tonumber(v.index)]
					else
						textureName = getTextureNameFromString(modelTextureNames, v.index)
					end
					engineRemoveTexture(thisObject, textureName)
				else
					local data = Cache.object[thisObject][textureName]
					local texture = getTextureFromName(v.texture)
					data.shader:setBrightess(v.brightness or 1.0)
					data.shader:setColor(v.red or 0, v.green or 0, v.blue or 0)
					data.shader:setTexture(texture.this)
					data.shader:engineApplyWorldTexture(textureName, thisObject)
				end
			end
		end
	elseif isElementStreamable(thisObject) and type(nowTable) == "table" then
		local SATexture = getElementData(thisObject, DataTexture)
		engineApplyTexture(thisObject, SATexture )
	end
end

function engineRemoveTexture(thisObject, textureName)
	if type(Cache.object[thisObject]) == "table" then
		if Cache.object[thisObject][textureName] then
			local data = Cache.object[thisObject][textureName]
			if data.shader then
				local result = data.shader:engineRemoveWorldTexture(textureName, thisObject)
			end
		end
	end
end


function DataChangeGameTexture(theKey, oldValue, newValue)
    if (getElementType(source) == "object") and (theKey == DataTexture) and isElementStreamable(source) == true then
       	if type(newValue) == "table" then
        	refreshTexture(source, newValue, oldValue)
        else
        	local modelTextureNames = engineGetModelTextureNames( tostring( getElementModel( source ) ) )
			for i,textureName in ipairs(modelTextureNames) do
				engineRemoveTexture(source, textureName)
			end
        end
    end
end
addEventHandler("onClientElementDataChange", root, DataChangeGameTexture)


addEventHandler("onClientElementDestroy", root, function()
	if getElementType( source ) == "object" and Cache.stream[source] then
		local modelTextureNames = engineGetModelTextureNames( tostring( getElementModel( source ) ) )
		for i,textureName in ipairs(modelTextureNames) do
			engineRemoveTexture(source, textureName, true)
		end
		Cache.object[source] = nil
		Cache.stream[source] = false
	end
end)

addEventHandler( "onClientElementStreamIn", root, function()
    if getElementType( source ) == "object" and type( getElementData(source, DataTexture) ) == "table" then
    	if not Cache.stream[source] and Cache.object[source] then
    		Cache.stream[source] = true
    		engineApplyTexture(source, getElementData(source, DataTexture) )
    	end
    end
end)

addEventHandler( "onClientElementStreamOut", root, function()
	if getElementType(source) == "object" and Cache.stream[source] then
		local modelTextureNames = engineGetModelTextureNames( tostring( getElementModel( source ) ) )
		for i,textureName in ipairs(modelTextureNames) do
			engineRemoveTexture(source, textureName)
		end
		Cache.stream[source] = false
	end
end)
