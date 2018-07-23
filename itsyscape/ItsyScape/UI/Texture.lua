--------------------------------------------------------------------------------
-- ItsyScape/UI/Texture.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Widget = require "ItsyScape.UI.Widget"

local Texture = Class(Widget)

function Texture:new()
	Widget.new(self)

	self.texture = false
	self.left = 0
	self.right = 1
	self.top = 0
	self.bottom = 1
	self.keepAspect = true
	self.rotation = 0
end

-- Sets the texture 'resource' (a Love2D image).
function Texture:setTexture(resource, l, r, t, b)
	self.texture = resource
	self.left = l or 0
	self.right = r or 1
	self.top = t or 0
	self.bottom = b or 1
end

-- Gets the texture.
function Texture:getTexture()
	return self.texture
end

-- Gets the bounds (left, right, top, bottom).
function Texture:getBounds()
	return self.left, self.right, self.top, self.bottom
end

-- Gets whether the texture keeps the aspect ratio.
function Texture:getKeepAspect()
	return self.keepAspect
end

function Texture:setKeepAspect(value)
	self.keepAspect = value or false
end

function Texture:getRotation()
	return self.rotation
end

function Texture:setRotation(value)
	self.rotation = value or self.rotation
end

return Texture
