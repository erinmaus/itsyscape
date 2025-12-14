--------------------------------------------------------------------------------
-- Resources/Game/Props/DrakkensonComputer/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local PropView = require "ItsyScape.Graphics.PropView"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local VideoResource = require "ItsyScape.Graphics.VideoResource"
local FlickerGreeble = require "Resources.Game.Props.Common.Greeble.FlickerGreeble"
local StaticGreeble = require "Resources.Game.Props.Common.Greeble.StaticGreeble"

local Computer = Class(PropView)
Computer.MONITOR_WIDTH  = 1920 / 4
Computer.MONITOR_HEIGHT = 1080 / 4

Computer.ROTATION_MULTIPLIER_1 = 1 / 7
Computer.ROTATION_OFFSET_1 = math.pi / 3

Computer.ROTATION_MULTIPLIER_2 = 3 / 8
Computer.ROTATION_OFFSET_2 = math.pi + math.pi / 5

Computer.Z_ROTATION_MIN = -math.pi / 2
Computer.Z_ROTATION_MAX = math.pi / 2

Computer.Y_ROTATION_MIN = -math.pi / 4
Computer.Y_ROTATION_MAX = math.pi / 4

Computer.BOB_HEIGHT = 0.5
Computer.BOB_RADIUS = 0.125
Computer.BOB_INTERVAL = math.pi / 4

function Computer:new(...)
	PropView.new(self, ...)

	self.frameRoot = SceneNode()

	self.frameGreeble = self:addGreeble(StaticGreeble, {
		MESH = "Resources/Game/Props/DrakkensonComputer/Model.lstatic",
		GROUP = "computer.bevel",
		MATERIAL = DecorationMaterial({
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/DrakkensonComputer/Metal.png",

			properties = {
				outlineThreshold = -0.01,
				color = "a692b9",
			},

			uniforms = {
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
				scape_SpecularWeight = { "float", 1 }
			}
		})
	}, nil, self.frameRoot)

	self.screenGreeble = self:addGreeble(StaticGreeble, {
		MESH = "Resources/Game/Props/DrakkensonComputer/Model.lstatic",
		GROUP = "computer.screen",
		MATERIAL = DecorationMaterial({
			shader = "Resources/Shaders/Decoration",
			texture = false,

			properties = {
				outlineThreshold = 0.5,
			}
		})
	}, nil, self.frameRoot)

	self.flickerGreeble = self:addGreeble(FlickerGreeble, {
		MIN_FLICKER_TIME = 1 / 60,
		MAX_FLICKER_TIME = 4 / 60,

		MIN_ATTENUATION = 0.5,
		MAX_ATTENUATION = 1,

		COLORS = {
			Color(0, 1, 0, 1)
		}
	}, {
		translation = Vector(0, 0.75, 0)
	}, nil, self.frameRoot)
end

function Computer:load()
	PropView.load(self)

	self.frameRoot:setParent(self:getRoot())

	self:getResources():queue(
		VideoResource,
		"Resources/Game/Videos/Tutorial/Static.ogv",
		function(video)
			self.video = video:getResource()
			self.video:play()
			self.video.onVideoFinished:register(function()
				self.video:rewind()
			end)

			self.canvas = love.graphics.newCanvas(self.MONITOR_WIDTH, self.MONITOR_HEIGHT)
			self.canvasTexture = TextureResource(self.canvas)

			self:getResources():queueEvent(function()
				while not self.screenGreeble:getDecorationNode() do
					coroutine.yield()
				end

				self.screenGreeble:getDecorationNode():getMaterial():setTextures(self.canvasTexture)
			end)
		end)
end

function Computer:update(delta)
	PropView.update(self, delta)

	if self.video then
		self.video:update()

		local video = self.video:makeSnapshot()

		love.graphics.push("all")
		love.graphics.setColor(0, 1, 0, 1)
		love.graphics.setCanvas(self.canvas)
		local scale = math.max(self.canvas:getWidth() / video:getWidth(), self.canvas:getHeight() / video:getHeight())
		love.graphics.draw(
			video,
			0, 0,
			0,
			scale, scale)
		love.graphics.pop()
	end

	local time = love.timer.getTime()
	local zDelta = math.sin(self.ROTATION_MULTIPLIER_1 * time + self.ROTATION_OFFSET_1) + math.cos(self.ROTATION_MULTIPLIER_1 * time + self.ROTATION_OFFSET_2)
	zDelta = ((zDelta / 2) + 1) / 2

	local yDelta = math.cos(self.ROTATION_MULTIPLIER_1 * time + self.ROTATION_OFFSET_1) + math.sin(self.ROTATION_MULTIPLIER_1 * time + self.ROTATION_OFFSET_2)
	yDelta = ((zDelta / 2) + 1) / 2

	local rotation = Quaternion.fromEulerXYZ(
		0,
		math.lerp(self.Y_ROTATION_MIN, self.Y_ROTATION_MAX, yDelta),
		math.lerp(self.Z_ROTATION_MIN, self.Z_ROTATION_MAX, zDelta))

	local translation = Vector(
		0,
		self.BOB_HEIGHT + math.sin(time * self.BOB_INTERVAL) * self.BOB_RADIUS,
		0)

	local transform = self.frameRoot:getTransform()
	transform:setLocalTranslation(translation)
	transform:setLocalRotation(rotation)
end

return Computer
