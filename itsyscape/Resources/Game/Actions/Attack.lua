--------------------------------------------------------------------------------
-- Resources/Game/Actions/Debug_Ascend.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Curve = require "ItsyScape.Game.Curve"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Action = require "ItsyScape.Peep.Action"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"

local Attack = Class(Action)
Attack.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }

function Attack:perform(state, player, target)
	if not self:canPerform(state) then
		return false
	end

	local targetActor = target:getBehavior(ActorReferenceBehavior)
	if targetActor and targetActor.actor then
		local s, b = player:addBehavior(CombatTargetBehavior)
		if s then
			b.actor = targetActor.actor
		end
	end
end

return Attack
