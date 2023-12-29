--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/FireProjectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Vector = require "ItsyScape.Common.Math.Vector"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local FireProjectile = B.Node("FireProjectile")
FireProjectile.PROJECTILE = B.Reference()
FireProjectile.SOURCE = B.Reference()
FireProjectile.DESTINATION = B.Reference()
FireProjectile.LAYER = B.Reference()

function FireProjectile:update(mashina, state, executor)
	local projectile = state[self.PROJECTILE]
	local source = state[self.SOURCE] or mashina
	local destination = state[self.DESTINATION] or Vector.ZERO
	local layer = state[self.LAYER] or nil

	if not projectile then
		return B.Status.Failure
	end

	local stage = mashina:getDirector():getGameInstance():getStage()
	stage:fireProjectile(projectile, source, destination, layer)

	return B.Status.Success
end

return FireProjectile
