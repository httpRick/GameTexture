-- ----------------------------------------------------------------------------
-- <github.com/httpRick> wrote this code. As long as you retain this 
-- notice, you can do whatever you want with this stuff. If we
-- meet someday, and you think this stuff is worth it, you can
-- buy me a beer in return.
-- ----------------------------------------------------------------------------

exampleObject = createObject(1499, 1936.44, -2369.94, 12.55)
setElementData(exampleObject, "GameTexture", { {index = 1, red = 0, green = 0, blue = 0 }, {index = 2, red = 0, green = 0, blue = 0 } } )

function setTextureCommand(cmd, ...)
	local args = {...}
	if args[1] == "texture" then
		local data = getElementData(exampleObject, "GameTexture")
		local number, texture = tonumber(args[2]), tonumber(args[3])
		if not texture and texture == "false" then
			texture = false
		end

		if data[number] then
			data[number].texture = texture
		end
		setElementData(exampleObject, "GameTexture", data)
	elseif args[1] == "brightness" then
		local data = getElementData(Object, "GameTexture")
		local number, brightness = tonumber(args[2]), tonumber(args[3])
		if data[number] then
			data[number].brightness = brightness
		end
		setElementData(exampleObject, "GameTexture", data)
	elseif args[1] == "color" then
		local data = getElementData(exampleObject, "GameTexture")
		local number, red, green, blue = tonumber(args[2]), tonumber(args[3]), tonumber(args[4]), tonumber(args[5])
		if data[number] then
			data[number].red = red or data[number].red
			data[number].blue = blue or data[number].blue
			data[number].green = green or data[number].green
		end
		setElementData(exampleObject, "GameTexture", data)
	end
end
addCommandHandler("setObject", setTextureCommand)
