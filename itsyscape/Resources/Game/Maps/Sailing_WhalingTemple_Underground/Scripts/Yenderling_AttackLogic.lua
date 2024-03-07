--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_WhalingTemple_Underground/Scripts/Yenderling_AttackLogic.lua
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

local PLAYER = B.Reference("Yenderling", "PLAYER")
local TARGET = B.Reference("Yenderling", "TARGET")
local WAS_ATTACKED = B.Reference("Yenderling", "WAS_ATTACKED")

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Mashina.Peep.GetPlayer {
			[PLAYER] = B.Output.player
		},

		Mashina.Repeat {
			Mashina.ParallelSequence {
				Mashina.Success {
					Mashina.Sequence {
						Mashina.Peep.WasAttacked,

						Mashina.Set {
							value = true,
							[WAS_ATTACKED] = B.Output.result
						}
					}
				},

				Mashina.Success {
					Mashina.ParallelTry {
						Mashina.Sequence {
							Mashina.Peep.HasCombatTarget {
								peep = PLAYER,
								[TARGET] = B.Output.target
							},

							Mashina.Check {
								condition = function(mashina, state)
									local playerTarget = state[TARGET]
									return playerTarget == mashina
								end
							},

							Mashina.Peep.EngageCombatTarget {
								peep = PLAYER
							},

							Mashina.Peep.SetState {
								state = "attack"
							}
						},

						Mashina.Sequence {
							Mashina.Invert {
								Mashina.Check {
									condition = WAS_ATTACKED
								}
							},

							Mashina.Step {
								Mashina.Navigation.Wander {
									min_radial_distance = 4,
									radial_distance = 6
								},

								Mashina.Peep.Wait
							}
						}
					}
				}
			}
		}
	}
}

return Tree
