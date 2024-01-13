--------------------------------------------------------------------------------
-- Resources/Peeps/Behemoth/BehemothMap.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local Probe = require "ItsyScape.Peep.Probe"
local BasicPortal = require "Resources.Game.Peeps.Props.BasicPortal"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local TeleportalBehavior = require "ItsyScape.Peep.Behaviors.TeleportalBehavior"

local BehemothMap = Class(BasicPortal)

function BehemothMap:new(resource, name, ...)
	BasicPortal.new(self, resource, name or 'BehemothMap', ...)
end

function BehemothMap:onSpawnedByPeep(e)
	self.behemoth = e.peep

	self.behemoth:listen('onPoof', self.onParentPoof, self)
end

function BehemothMap:onTeleport(peep)
	if self.behemoth then
		self.behemoth:poke("rise")
		self.behemoth:poke("shedMimic", self, peep)
		self.behemoth:poke("climb", self, peep)
	end
end

function BehemothMap:ready(director, game)
	BasicPortal.ready(self, director, game)

	local portal = self:getBehavior(TeleportalBehavior)

	local ores = director:probe(self:getLayerName(), Probe.layer(portal.layer), Probe.resource("Prop", "ItsyRock_Default"))
	for _, ore in ipairs(ores) do
		ore:listen("resourceHit", function(_, e)
			if self.behemoth then
				self.behemoth:poke("hit", AttackPoke({
					aggressor = e.peep,
					damage = e.damage
				}))
			end
		end)

		ore:listen("resourceObtained", function(_, e)
			if self.behemoth then
				self.behemoth:poke("drop", self, e.peep)
			end
		end)
	end
end

function BehemothMap:onParentPoof()
	Utility.Peep.poof(self)
end

function BehemothMap:getPropState()
	local state = BasicPortal.getPropState(self)
	local portal = self:getBehavior(TeleportalBehavior)

	state.k = (portal and portal.k) or 0
	state.x = (portal and portal.x) or 0
	state.y = (portal and portal.y) or 0
	state.z = (portal and portal.z) or 0 
	state.bone = (portal and portal.bone) or "back"
	state.rotation = portal and portal.rotation and { portal.rotation:get() }

	if self.behemoth then
		local actor = self.behemoth:getBehavior(ActorReferenceBehavior)
		actor = actor and actor.actor

		if actor then
			state.actorID = actor:getID()
		end
	end

	return state
end

return BehemothMap
