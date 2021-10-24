--------------------------------------------------------------------------------
-- Resources/Peeps/Sleepyrosy/Sleepyrosy.lua
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
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"

local Sleepyrosy = Class(Creep)

function Sleepyrosy:new(resource, name, ...)
	Creep.new(self, resource, name or 'Sleepyrosy_Base', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(4, 4, 5)
	size.offset = Vector.UNIT_Y * 4

	self:addBehavior(RotationBehavior)
end

function Sleepyrosy:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Sleepyrosy.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Sleepyrosy_Idle_Flying/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Sleepyrosy/Sleepyrosy.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)

	Creep.ready(self, director, game)

	Utility.Peep.equipXWeapon(self, "MimicBite")
end

function Sleepyrosy:update(...)
	Creep.update(self, ...)
	Utility.Peep.face3D(self)
end

return Sleepyrosy
