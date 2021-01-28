--------------------------------------------------------------------------------
-- Resources/Peeps/CreepyDoll/CreepyDoll.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Equipment = require "ItsyScape.Game.Equipment"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"

local CreepyDoll = Class(Creep)

function CreepyDoll:new(resource, name, ...)
	Creep.new(self, resource, name or 'CreepyDoll', ...)
end

function CreepyDoll:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/CreepyDoll.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/CreepyDoll_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/CreepyDoll/CreepyDoll.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)

	Creep.ready(self, director, game)
end

return CreepyDoll
