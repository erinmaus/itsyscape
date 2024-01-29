--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/TheEmptyKing_FullyRealized_SummonStaff/Projectile.lua
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
local Tween = require "ItsyScape.Common.Math.Tween"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Equipment = require "ItsyScape.Game.Equipment"
local Prop = require "ItsyScape.Game.Model.Prop"
local Projectile = require "ItsyScape.Graphics.Projectile"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local StaffPropView = require "Resources.Game.Props.TheEmptyKing_FullyRealized_Staff.View"

local Staff = Class(Projectile)
Staff.DURATION = 1.5
Staff.OFFSET_POSITION = Vector(-4.15, -9, 0.1)
Staff.OFFSET_ANGLE = math.pi / 4 + math.pi / 2
Staff.TARGET_ANGLE = math.pi * 4
Staff.CLAMP_BOTTOM = true

function Staff:attach()
	Projectile.attach(self)
end

function Staff:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	resources:queue(
		TextureResource,
		"Resources/Game/Projectiles/TheEmptyKing_FullyRealized_SummonStaff/Texture.png",
		function(texture)
			self.texture = texture
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Projectiles/TheEmptyKing_FullyRealized_SummonStaff/Model.lstatic",
		function(mesh)
			self.zweihander = DecorationSceneNode()
			self.zweihander:fromGroup(mesh:getResource(), "Staff")
			self.zweihander:getMaterial():setTextures(self.texture)
			self.zweihander:setParent(root)
		end)
	resources:queueEvent(
		function()
			self.isLoaded = true
		end)
end

function Staff:poof()
	Projectile.poof(self)

	local gameView = self:getGameView()
	local actorView = gameView:getActor(self:getDestination())
	if actorView then
		local zweihanderSkin = CacheRef(
			"ItsyScape.Game.Skin.ModelSkin",
			"Resources/Game/Skins/TheEmptyKing_FullyRealized/Staff.lua")
		actorView:changeSkin(Equipment.PLAYER_SLOT_TWO_HANDED, Equipment.SKIN_PRIORITY_BASE, zweihanderSkin)
	end
end

function Staff:tick()
	local gameView = self:getGameView()

	if not self.isLoaded then
		return
	end

	if not self.spawnPosition then
		self.spawnPosition = self:getTargetPosition(self:getSource())

		local source = self:getSource()
		if Class.isCompatibleType(source, Prop) then
			local propView = gameView:getProp(source)
			if Class.isCompatibleType(propView, StaffPropView) then
				propView:disable()
			end
		end
	end
end

function Staff:getDuration()
	return Staff.DURATION
end

function Staff:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		local gameView = self:getGameView()

		local handPosition, handRotation
		do
			local actorView = gameView:getActor(self:getDestination())
			if actorView then
				handPosition = actorView:getBoneWorldPosition("hand.r", self.OFFSET_POSITION)

				local _
				_, _, handRotation = actorView:getBoneTransform("hand.r")
			else
				handPosition = Vector.ZERO
				handRotation = Quaternion.IDENTITY
			end
		end

		local destinationPosition = handPosition
		local startPosition = self.spawnPosition

		local delta = self:getDelta()
		local mu = Tween.sineEaseOut(delta)

		local position = startPosition:lerp(destinationPosition, mu)
		local angle = Vector(Staff.OFFSET_ANGLE, 0, 0):lerp(Vector(Staff.TARGET_ANGLE, 0, 0), mu).x
		local rotation = Quaternion.fromAxisAngle(Vector.UNIT_Z, angle) * Quaternion.IDENTITY:slerp(handRotation, mu)
		local root = self:getRoot()
		root:getTransform():setLocalTranslation(position)
		root:getTransform():setLocalRotation(rotation:getNormal())
	end
end

return Staff
