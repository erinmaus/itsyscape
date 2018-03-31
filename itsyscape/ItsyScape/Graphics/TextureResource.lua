--------------------------------------------------------------------------------
-- ItsyScape/Graphics/TextureResource.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
-------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"

local TextureResource = Class()
TextureResource.CURRENT_ID = 1

-- Basic TextureResource resource class.
--
-- This object can be sorted by values returned by getID.
function TextureResource:new(image)
	self.image = image

	self.id = TextureResource.CURRENT_ID
	TextureResource.CURRENT_ID = TextureResource.CURRENT_ID + 1
end

-- Gets the underlying Love2D Image.
function TextureResource:getResource()
	return self.image
end

-- Gets the width of the TextureResource.
function TextureResource:getWidth()
	return self.image:getWidth()
end

-- Gets the height of the TextureResource.
function TextureResource:getHeight()
	return self.image:getHeight()
end

-- Gets the ID of the texture.
function TextureResource:getID()
	return self.id
end

return TextureResource
