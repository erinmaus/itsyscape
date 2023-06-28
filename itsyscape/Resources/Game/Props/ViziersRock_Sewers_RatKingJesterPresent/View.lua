--------------------------------------------------------------------------------
-- Resources/Game/Props/ViziersRock_Sewers_RatKingJesterPresent/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Present = Class(PropView)
Present.MAX_SHAPES = 4

Present.PAPER_SIZE = 128
Present.PAPER_SHAPE_SIZE = 16
Present.OFFSETS = {
	{  0,  0 },
	{ -1,  0 },
	{  1,  0 },
	{  0, -1 },
	{  0,  1 }
}

function Present:new(prop, gameView)
	PropView.new(self, prop, gameView)
end

function Present:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.ribbon = DecorationSceneNode()
	self.ribbon:setParent(root)

	self.paper = DecorationSceneNode()
	self.paper:setParent(root)

	do
		local shapes = {}

		for i = 1, Present.MAX_SHAPES do
			resources:queue(
				TextureResource,
				string.format("Resources/Game/Props/ViziersRock_Sewers_RatKingJesterPresent/Shape%d.png", i),
				function(texture)
					self.texture = texture
				end)
		end

		resources:queueEvent(function()
			self.shapes = shapes
		end)
	end

	resources:queue(
		TextureResource,
		"Resources/Game/Props/ViziersRock_Sewers_RatKingJesterPresent/Texture.png",
		function(texture)
			self.texture = texture
		end)

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/ViziersRock_Sewers_RatKingJesterPresent/Model.lstatic",
		function(mesh)
			self.ribbon:fromGroup(mesh:getResource(), "Ribbon")
			self.ribbon:getMaterial():setTextures(self.texture)
			self.ribbon:setParent(root)
		end)

	self.canvas = love.graphics.newCanvas(Present.PAPER_SIZE, Present.PAPER_SIZE)
	self.canvasTexture = TextureResource(self.canvas)

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/ViziersRock_Sewers_RatKingJesterPresent/Model.lstatic",
		function(mesh)
			self.paper:fromGroup(mesh:getResource(), "WrappingPaper")
			self.paper:getMaterial():setTextures(self.canvasTexture)
			self.paper:setParent(root)
		end)
end

function Present:tick()
	PropView.tick(self)

	if self.shapes then
		local state = self:getProp():getState()

		love.graphics.push('all')
		love.graphics.setCanvas(self.canvas)
		love.graphics.clear(unpack(state.color or { 1, 0, 0 }))

		local shapes = state.shapes or {}
		for i = 1, shapes do
			local shapeState = shapes[i]

			local shapeTexture = self.shapes[shapeState.index]
			shapeTexture = shapeTexture and shapeTexture:getResource()

			if shapeTexture then
				for _, offset in ipairs(Present.OFFSETS) do
					love.graphics.setColor(unpack(shapeState.color or { 1, 1, 0 }))

					love.graphics.draw(
						shapeTexture,
						shapeState.x + offset[1] * self.canvas:getWidth(),
						shapeState.y + offset[2] * self.canvas:getHeight(),
						shapeState.rotation,
						Present.PAPER_SHAPE_SIZE / shapeTexture:getWidth(),
						Present.PAPER_SHAPE_SIZE / shapeTexture:getHeight(),
						shapeTexture:getWidth() / 2
						shapeTexture:getHeight() / 2)
				end
			end
		end

		love.graphics.pop()
	end
end

return Present
