--------------------------------------------------------------------------------
-- Resources/Game/TitleScreens/IsabelleIsland/Title.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local NullActor = require "ItsyScape.Game.Null.Actor"
local ActorView = require "ItsyScape.Graphics.ActorView"
local Color = require "ItsyScape.Graphics.Color"
local FogSceneNode = require "ItsyScape.Graphics.FogSceneNode"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local TitleScreen = require "ItsyScape.Graphics.TitleScreen"

local IsabelleIsland = Class(TitleScreen)
IsabelleIsland.CLOUD_SPAWN_TIME = 3

function IsabelleIsland:load(filename, t)
	TitleScreen.load(self, filename, t)

	local fog = FogSceneNode()
	fog:setNearDistance(20)
	fog:setFarDistance(70)
	fog:setColor(Color(33 / 255, 162 / 255, 234 / 255))

	fog:setParent(self:getScene())

	self:getResources():queue(
		TextureResource,
		"Resources/Game/TitleScreens/IsabelleIsland/Sun.png",
		function(texture)
			self.sun = texture
		end)
	self:getResources():queue(
		TextureResource,
		"Resources/Game/TitleScreens/IsabelleIsland/SunRays.png",
		function(texture)
			self.sunRays = texture
		end)
	self:getResources():queue(
		TextureResource,
		"Resources/Game/TitleScreens/IsabelleIsland/Cloud.png",
		function(texture)
			self.cloud = texture
		end)

	self.squidActor = NullActor()
	self.squidActorView = ActorView(self.squidActor, "Squid")
	self.squidActorView:attach(self:getGameView())
	self.squidActor:setBody(
		CacheRef(
			"ItsyScape.Game.Body",
			"Resources/Game/Bodies/UndeadSquid.lskel"))
	self.squidActor:setSkin(
		1,
		math.huge,
		CacheRef(
			"ItsyScape.Game.Skin.ModelSkin",
			"Resources/Game/Skins/UndeadSquid/UndeadSquid.lua"))
	self.squidActor:playAnimation(
		1,
		math.huge,
		CacheRef(
			"ItsyScape.Graphics.AnimationResource",
			"Resources/Game/Animations/UndeadSquid_Idle/Script.lua"))
	self.squid = SceneNode()
	self.squid:getTransform():setLocalScale(Vector(1 / 64))
	self.squidActorView:getSceneNode():setParent(self.squid)
	self.squid:setParent(self:getScene())
	self:getResources():queueEvent(
		function()
			--self.scene = self.squid
		end)
end

function IsabelleIsland:update(delta)
	TitleScreen.update(self, delta)

	self.lastCloudSpawn = (self.lastCloudSpawn or 0) + delta
	if self.lastCloudSpawn > self.CLOUD_SPAWN_TIME then

	end

	self.squidActorView:update(delta)
	self.squidActorView:updateAnimations()

	local squidPosition = TitleScreen.performRotate(
		Vector(-0.5, 0, 1),
		self:getAngle())
	self.squid:getTransform():setLocalTranslation(squidPosition)
	self.squid:getTransform():setPreviousTransform(squidPosition, nil, nil)
end

function IsabelleIsland:drawSkybox()
	local width, height = love.window.getMode()
	love.graphics.setColor(33 / 255, 162 / 255, 234 / 255, 1)
	love.graphics.rectangle('fill', 0, 0, width, height)

	love.graphics.setColor(1, 1, 1, 1)
end

function IsabelleIsland:drawTitle()
	local angle = self:getAngle()
	local scale = math.abs(math.sin(self:getTime())) * 0.3 + 0.8
	local width, height = love.window.getMode()

	if self.sun and self.sunRays then
		local sun = self.sun:getResource()
		local sunRays = self.sunRays:getResource()
		love.graphics.draw(
			sunRays,
			width / 4,
			96,
			angle,
			scale, scale,
			sun:getWidth() / 2, sun:getHeight() / 2)
		love.graphics.draw(
			sun,
			width / 4,
			96,
			0,
			1, 1,
			sun:getWidth() / 2, sun:getHeight() / 2)
	end

	TitleScreen.drawTitle(self)
end

return IsabelleIsland
