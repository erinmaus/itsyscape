--------------------------------------------------------------------------------
-- ItsyScape/Graphics/SkinRenderer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
-------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local SceneNode = require "ItsyScape.Graphics.SceneNode"

local SkinRenderer = Class(SceneNode)

-- Constructs a SkinRenderer for the provided Skin.
function SkinRenderer:new(skin)
	SceneNode.new(self)

	if not skin:isType(self.TYPE) then
		error("skin/renderer mismatch", 2)
	end

	self.skin = skin
end

-- Gets the Skin this SkinRenderer is rendering. :)
function SkinRenderer:getSkin()
	return self.skin
end

local Renderers = {}
function SkinRenderer.Definition(skinType)
	local Type = Renderers[skinType]
	if Type == nil then
		Type = Class(SkinRenderer)
		Type.TYPE = skinType
		Renderers[skinType] = Type
	end

	return Type
end

function SkinRenderer.getDefinition(skinType)
	return Renderers[skinType]
end

function SkinRenderer.hasDefinition(skinType)
	return Renderers[skinType] ~= nil
end

return SkinRenderer
