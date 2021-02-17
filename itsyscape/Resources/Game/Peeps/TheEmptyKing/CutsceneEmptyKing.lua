--------------------------------------------------------------------------------
-- Resources/Peeps/TheEmptyKing/CutsceneEmptyKing.lua
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
local Player = require "ItsyScape.Peep.Peeps.Player"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local TheEmptyKing = Class(Player)

function TheEmptyKing:new(resource, name, ...)
	Player.new(self, resource, name or 'TheEmptyKing', ...)

	local status = self:getBehavior(CombatStatusBehavior)
	status.currentHitpoints = math.huge
	status.maxHitpoints = math.huge
end

function TheEmptyKing:ready(director, game)
	Player.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/TheEmptyKing/TheEmptyKing.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_SELF, Equipment.SKIN_PRIORITY_BASE, body)
end

return TheEmptyKing
