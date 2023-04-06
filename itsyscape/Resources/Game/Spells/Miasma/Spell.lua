--------------------------------------------------------------------------------
-- Resources/Game/Spells/Miasma/Spell.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local CombatSpell = require "ItsyScape.Game.CombatSpell"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local SummonGooEffect = require "Resources.Game.Effects.Miasma.Effect"

local Miasma = Class(CombatSpell)

function Miasma:cast(peep, target)
	CombatSpell.cast(self, peep, target)

	local position = Utility.Peep.getPosition(peep)
	local size = Utility.Peep.getSize(peep)
	local x = love.math.random() * (size.x * 2 + 4) - (size.x + 2)
	local z = love.math.random() * (size.z * 2 + 4) - (size.z + 2)
	local skeleton = Utility.spawnActorAtPosition(peep, "MiasmaSkeleton", x + position.x, position.y, z + position.z, 0)
	if skeleton then
		skeleton:getPeep():listen('finalize', function(p)
			local a = target:getBehavior(ActorReferenceBehavior)
			a = a and a.actor

			if a then
				local _, t = p:addBehavior(CombatTargetBehavior)
				t.actor = a
			end

			local game = p:getDirector():getGameInstance()
			local stage = game:getStage()

			stage:fireProjectile("Miasma", peep, p)
		end)
	end

	local effect = target:getEffect(MiasmaEffect)
	if not effect then
		Utility.Peep.applyEffect(target, "Miasma", true)
	else
		effect:boost()
	end
end

function Miasma:getProjectile()
	return nil
end

return Miasma
