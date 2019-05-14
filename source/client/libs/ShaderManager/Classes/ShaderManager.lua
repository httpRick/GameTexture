-- ----------------------------------------------------------------------------
--  <github.com/httpRick> wrote this code. As long as you retain this 
-- notice, you can do whatever you want with this stuff. If we
-- meet someday, and you think this stuff is worth it, you can
-- buy me a beer in return.
-- ----------------------------------------------------------------------------


shaderManager = {}
shaderManager.metatable = {
    __index = shaderManager,
}
setmetatable(shaderManager, { __call = function(self,...) return self:New(...) end } )

function shaderManager:New(priority, layred)
	local priority = priority or 0
	local layred = layred or false
	local instance = setmetatable( {}, shaderManager.metatable )
	instance.this = dxCreateShader("res/shader/SATexture.fx", priority, 0, layred, "object")
	instance.texture = false
	instance.Brightess = 0.8
	instance.RGBColor = {0.0, 0.0, 0.0}
	return instance
end

function shaderManager:engineApplyWorldTexture(textureName, targetElement, appendLayers)
	if self.this then
		dxSetShaderValue(self.this, "SATexture", self.texture)
		dxSetShaderValue(self.this, "Brightess", self.Brightess)
		dxSetShaderValue(self.this, "RGBColor", self.RGBColor[1], self.RGBColor[2], self.RGBColor[3])
		return engineApplyShaderToWorldTexture(self.this, textureName, targetElement, appendLayers)
	else
		return false
	end
end

function shaderManager:engineRemoveWorldTexture(textureName, targetElement)
	if self.this then
		return engineRemoveShaderFromWorldTexture(self.this, textureName, targetElement)
	else
		return false
	end
end

function shaderManager:getBrightess()
	return self.Brightess
end

function shaderManager:getColor()
	return self.RGBColor.r*255, self.RGBColor.g*255, self.RGBColor.b*255
end

function shaderManager:getTexture()
	return self.texture
end

function shaderManager:setTexture(texture)
	if type(texture) == "userdata" then
		self.texture = texture
	end
end

function shaderManager:setBrightess(brightess)
	if brightess >= 0 and brightess <= 1 then
		self.Brightess = brightess
	end
end

function shaderManager:setColor(r, g, b)
	if (r >= 0 and r <= 255) and (g >= 0 and g <= 255) and (b >= 0 and b <= 255) then
		self.RGBColor = {r/255, g/255, b/255}
	end
end

function shaderManager:destroy()
	destroyElement(self.this)
	self.this = nil;
	self = nil
end
