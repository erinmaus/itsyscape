--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Bug/Chocoroach.lua
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
local Utility = require "ItsyScape.Game.Utility"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local Bug = require "Resources.Game.Peeps.Bug.Bug"

local Chocoroach = Class(Bug)

function Chocoroach:new(resource, name, ...)
	Bug.new(self, resource, name or 'Chocoroach_Base', ...)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = 12

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = 12

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2, 3, 3)
end

function Chocoroach:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Chocoroach/Chocoroach.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)

	Utility.Peep.equipXWeapon(self, "ChocoroachVomit")

	Bug.ready(self, director, game)
end

return Chocoroach
