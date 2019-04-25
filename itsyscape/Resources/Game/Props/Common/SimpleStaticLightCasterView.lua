--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/SimpleStaticLightCasterView.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local LightBeamSceneNode = require "ItsyScape.Graphics.LightBeamSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local SimpleStaticLightCasterView = Class(PropView)

function SimpleStaticLightCasterView:getTextureFilename()
	return Class.ABSTRACT()
end

function SimpleStaticLightCasterView:getModelFilename()
	return Class.ABSTRACT()
end

function SimpleStaticLightCasterView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.decoration = DecorationSceneNode()

	resources:queue(
		TextureResource,
		self:getTextureFilename(),
		function(texture)
			self.texture = texture
		end)
	resources:queue(
		StaticMeshResource,
		self:getModelFilename(),
		function(mesh)
			local _, group = self:getModelFilename()
			self.decoration:fromGroup(mesh:getResource(), group)
			self.decoration:getMaterial():setTextures(self.texture)
			self.decoration:setParent(root)
		end)

	self.lights = {}
end

function SimpleStaticLightCasterView:tick()
	PropView.tick(self)

	if self.lights then
		local rays = self:getProp():getState().rays
		for i = 1, #rays do
			local light = self.lights[i]
			if not light then
				light = LightBeamSceneNode()
				light:setParent(self:getGameView():getScene())

				self.lights[i] = light
			end

			light:build(rays[i])
		end
	end
end

function SimpleStaticLightCasterView:remove()
	PropView.remove(self)

	if self.light then
		self.light:setParent(nil)
	end
end

return SimpleStaticLightCasterView
