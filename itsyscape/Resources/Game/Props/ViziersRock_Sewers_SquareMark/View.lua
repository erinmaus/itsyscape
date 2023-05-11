--------------------------------------------------------------------------------
-- Resources/Game/Props/ViziersRock_Sewers_SquareMark/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local PropView = require "ItsyScape.Graphics.PropView"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"

local SquareMark = Class(PropView)

function SquareMark:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	resources:queue(
		TextureResource,
		"Resources/Game/Props/ViziersRock_Sewers_SquareMark/Texture.png",
		function(texture)
			self.texture = texture
		end)
	resources:queueEvent(
		function(mesh)
			self.mark = QuadSceneNode()
			self.mark:setParent(root)
			self.mark:setIsBillboarded(false)
			self.mark:getMaterial():setTextures(self.texture)
			self.mark:getTransform():setLocalRotation(-Quaternion.X_90)
			self.mark:getTransform():setLocalTranslation(Vector(0, 1 / 8, 0))
		end)
end

return SquareMark
