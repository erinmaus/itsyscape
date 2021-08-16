--------------------------------------------------------------------------------
-- Resources/Game/Peeps/GoryMass/IdleLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local BTreeBuilder = require "B.TreeBuilder"
local Mashina = require "ItsyScape.Mashina"
local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"

local TARGET = B.Reference("GoryMass_IdleLogic", "TARGET")

local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.Try {
			-- Do nothing when moving
			Mashina.Check {
				condition = function(peep)
					return peep:isMoving()
				end
			},

			Mashina.Success {
				Mashina.Sequence {
					-- Find target if and only if NOT moving
					Mashina.Check {
						condition = function(peep)
							return not peep:isMoving()
						end
					},

					Mashina.Peep.FindNearbyCombatTarget {
						include_npcs = true,
						distance = 12,
						filter = function(peep)
							local isTarget = peep:hasBehavior(PlayerBehavior) or peep:hasBehavior(FollowerBehavior)
							local isAggressive = peep:hasBehavior(CombatTargetBehavior)
							return isTarget and isAggressive
						end,
						[TARGET] = B.Output.result
					},

					Mashina.Peep.PokeSelf {
						event = "startRoll",
						poke = TARGET
					}
				}
			}
		}
	}
}

return Tree
