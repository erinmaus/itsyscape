--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/DecorationLerpView.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local PropView = require "ItsyScape.Graphics.PropView"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"

local DecorationLerpView = Class(PropView)

function DecorationLerpView:getCurrentDecorationName()
	return Class.ABSTRACT()
end

function DecorationLerpView:getNextDecorationName()
	return Class.ABSTRACT()
end

function DecorationLerpView:getDecorationSceneNodesByName(current, next)
	local decorations = self:getGameView():getDecorationSceneNodes()
	return decorations[current], decorations[next]
end

function DecorationLerpView:getModelNode()
	return self.decoration
end

function DecorationLerpView:load()
	PropView.load(self)

	local root = self:getRoot()
	self.decoration = DecorationSceneNode()
	self.decoration:setParent(root)
end

function DecorationLerpView:lerp(delta)
	local current = self:getCurrentDecorationName()
	local next = self:getNextDecorationName()
	current, next = self:getDecorationSceneNodesByName(current, next)

	if current and next then
		self.decoration:lerp(current, next, delta)
		self.decoration:getMaterial():setTextures(
			current:getMaterial():getTexture(1))

		current:setParent(nil)
		next:setParent(nil)
	end

end

return DecorationLerpView
