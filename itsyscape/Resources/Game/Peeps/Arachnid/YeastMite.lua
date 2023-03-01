--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Arachnid/YeastMite.lua
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
local Mite = require "Resources.Game.Peeps.Arachnid.Mite"

local YeastMite = Class(Mite)

function YeastMite:new(resource, name, ...)
	Mite.new(self, resource, name or 'YeastMite_Base', ...)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = 12

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = 8
end

function YeastMite:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/YeastMite/YeastMite.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)

	Utility.Peep.equipXWeapon(self, "ChocoroachVomit")

	Mite.ready(self, director, game)
end

return YeastMite
