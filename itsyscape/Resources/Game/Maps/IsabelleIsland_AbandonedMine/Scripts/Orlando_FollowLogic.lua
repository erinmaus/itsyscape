--------------------------------------------------------------------------------
-- Resources/Game/Maps/IsabelleIsland_AbandonedMine/Scripts/Orlando_FollowLogic.lua
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

local PLAYER = B.Reference("Orlando", "PLAYER")
local AGGRESSOR = B.Reference("Orlando", "AGGRESSOR")

local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.Peep.GetPlayer {
			[PLAYER] = B.Output.player
		},

		Mashina.Success {
			Mashina.Sequence {
				Mashina.Check {
					condition = function(_, state) return state[AGGRESSOR] end
				},

				Mashina.Peep.IsDead {
					peep = AGGRESSOR
				},

				Mashina.Set {
					value = false,
					[AGGRESSOR] = B.Output.result
				},

				Mashina.Check {
					condition = function(_, state) return true end
				},
			}
		},

		Mashina.ParallelTry {
			Mashina.Step {
				Mashina.Peep.WasAttacked {
					target = PLAYER,
					took_damage = false,
					[AGGRESSOR] = B.Output.aggressor
				},

				Mashina.Peep.EngageCombatTarget {
					peep = AGGRESSOR
				},

				Mashina.Peep.QueuePower {
					power = "Taunt",
					clear_cool_down = true
				},

				Mashina.Repeat {
					Mashina.Invert {
						Mashina.Peep.IsDead {
							peep = AGGRESSOR
						}
					}
				}
			},

			Mashina.Sequence {
				Mashina.Check {
					condition = function(_, state) return not state[AGGRESSOR] end
				},

				Mashina.Navigation.TargetMoved {
					peep = PLAYER
				},

				Mashina.Navigation.WalkToPeep {
					peep = PLAYER,
					distance = 2
				}
			}
		}
	}
}

return Tree
