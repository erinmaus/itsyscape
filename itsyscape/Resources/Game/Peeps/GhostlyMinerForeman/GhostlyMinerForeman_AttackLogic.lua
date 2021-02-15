--------------------------------------------------------------------------------
-- Resources/Game/Peeps/GhostlyMinerForeman/GhostlyMinerForeman_IdleLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local BTreeBuilder = require "B.TreeBuilder"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local BTreeBuilder = require "B.TreeBuilder"
local Mashina = require "ItsyScape.Mashina"

local AGGRESSOR = B.Reference("GhostlyMinerForeman", "AGGRESSOR")

local TALK_DURATION = 2.5

-- 10 ticks per second, ~5 seconds to target player
local TARGET_PLAYER_CHANCE    = 1 / 50
local AGGRESSOR_SWITCH_CHANCE = 1 / 2
local AGGRESSOR_SWITCH_WAIT   = 10

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Peep.Talk {
			message = "WHO DARES DISTURB ME?" 
		},

		Mashina.Repeat {
			Mashina.Step {
				Mashina.Success {
					Mashina.ParallelTry {
						Mashina.Step {
							Mashina.Peep.WasAttacked {
								took_damage = false,
								[AGGRESSOR] = B.Output.aggressor
							},

							Mashina.RandomCheck {
								chance = AGGRESSOR_SWITCH_CHANCE
							},

							Mashina.Peep.EngageCombatTarget {
								peep = AGGRESSOR
							},

							Mashina.Peep.Talk {
								message = "Maggot!",
								duration = TALK_DURATION
							}
						},

						Mashina.Step {
							Mashina.RandomCheck {
								chance = TARGET_PLAYER_CHANCE
							},

							Mashina.Peep.GetPlayer {
								[AGGRESSOR] = B.Output.player
							},

							Mashina.Peep.EngageCombatTarget {
								peep = AGGRESSOR
							},

							Mashina.RandomSequence {
								Mashina.Peep.Talk {
									message = "You're unworthy of the Empty King's attention!",
									duration = TALK_DURATION
								},

								Mashina.Peep.Talk {
									message = "I will rip you apart!",
									duration = TALK_DURATION
								},

								Mashina.Peep.Talk {
									message = "The Empty King's plans must proceed!",
									duration = TALK_DURATION
								}
							},

							Mashina.Peep.TimeOut {
								duration = AGGRESSOR_SWITCH_WAIT
							}
						}
					}
				}
			}
		}
	}
}

return Tree
