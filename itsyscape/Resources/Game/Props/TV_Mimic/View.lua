--------------------------------------------------------------------------------
-- Resources/Game/Props/TV_HexLabs/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local Color = require "ItsyScape.Graphics.Color"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local VideoResource = require "ItsyScape.Graphics.VideoResource"

local TVMimic = Class(PropView)
TVMimic.WIDTH = 256
TVMimic.HEIGHT = 128

function TVMimic:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.spawned = false
	self.transform = love.math.newTransform()
end

function TVMimic:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/TV/Model.lstatic",
		function(mesh)
			self.mesh = mesh
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/TV/Texture.png",
		function(texture)
			self.texture = texture
		end)
	resources:queue(
		VideoResource,
		"Resources/Game/Videos/Tutorial/Static.ogv",
		function(video)
			self.video = video:getResource()
			self.video:play()
			self.video.onVideoFinished:register(function()
				self.video:rewind()
			end)
		end)
	resources:queueEvent(function()
		self.tv = DecorationSceneNode()
		self.tv:fromGroup(self.mesh:getResource(), "TV")
		self.tv:getMaterial():setTextures(self.texture)
		self.tv:setParent(root)
		self.tv:onWillRender(function() self:applyTransform() end)

		self.screen = DecorationSceneNode()
		self.screen:fromGroup(self.mesh:getResource(), "TVScreen")
		self.screen:getMaterial():setTextures(self.texture)
		self.screen:setParent(root)

		self.screen:onWillRender(function(_, delta)
			local texture = self.video:getSnapshot()
			if not self.screenTexture or self.screenTexture:getResource() ~= texture then
				self.screenTexture = TextureResource(texture)
			end

			self.screen:getMaterial():setTextures(self.screenTexture)

			self:applyTransform()
		end)
	end)
end

function PropView:getIsStatic()
	return not self.spawned
end

function TVMimic:tick()
	PropView.tick(self)

	if self.tv then
		local state = self:getProp():getState()
		self.screen:getMaterial():setColor(Color(unpack(state.color or { 1, 1, 1, 1 })))
	end

	self.spawned = true
end

function TVMimic:applyTransform()
	love.graphics.applyTransform(self.transform)
	love.graphics.rotate(1, 0, 0, -math.pi / 2)
end


function TVMimic:calculateTransform(actorID)
	local gameView = self:getGameView()
	local game = gameView:getGame()
	local actor = game:getStage():getActorByID(actorID)
	local actorView = gameView:getActor(actor)

	self.transform = actorView:getLocalBoneTransform("root")
end

function TVMimic:update(delta)
	PropView.update(self, delta)

	if self.video then
		self.video:update()
		self.video:makeSnapshot()
	end

	local state = self:getProp():getState()
	if state.actorID then
		self:calculateTransform(state.actorID)
	end
end

return TVMimic
