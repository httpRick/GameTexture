-- ----------------------------------------------------------------------------
-- <github.com/httpRick> wrote this code. As long as you retain this 
-- notice, you can do whatever you want with this stuff. If we
-- meet someday, and you think this stuff is worth it, you can
-- buy me a beer in return.
-- ----------------------------------------------------------------------------

textureManager = {}
textureManager.metatable = {
    __index = textureManager,
}
setmetatable(textureManager, { __call = function(self,...) return self:New(...) end } )

function textureManager:New(name)
	local instance = setmetatable( {}, textureManager.metatable )

	instance.img = IMGLoader()
	local IMGFile = instance.img:LoadFile( "res/img/textures.img" )
	local fileTexture
	if IMGFile then 
		fileTexture = instance.img:GetFile("mmat_"..name..".png" )
	end
	if fileTexture then
		instance.this = dxCreateTexture(fileTexture)
		instance.img:CloseFile()
	end
	return instance
end

function textureManager:set()
	local IMGFile = self.img:LoadFile( "res/img/textures.img" )
	local fileTexture
	if IMGFile then 
		fileTexture = self.img:GetFile("mmat_"..name..".png" )
	end
	self.this = dxCreateTexture(fileTexture)
	self.img:CloseFile()
	return self.this
end

function textureManager:get()
	return self.this
end
