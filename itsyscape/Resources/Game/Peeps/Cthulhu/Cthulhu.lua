--------------------------------------------------------------------------------
-- Resources/Peeps/Cthulhu/Cthulhu.lua
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
local Equipment = require "ItsyScape.Game.Equipment"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local Cthulhu = Class(Creep)

function Cthulhu:new(resource, name, ...)
	Creep.new(self, resource, name or 'Cthulhu', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(12, 24, 4)

	local movement = self:getBehavior(MovementBehavior)
	movement.velocityMultiplier = 0.25
	movement.accelerationMultiplier = 0.25

	local status = self:getBehavior(CombatStatusBehavior)
	status.currentHitpoints = 20000
	status.maximumHitpoints = 20000
end

function Cthulhu:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Cthulhu.lskel")
	actor:setBody(body)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Cthulhu/Cthulhu.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Cthulhu_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	Creep.ready(self, director, game)
end

return Cthulhu
