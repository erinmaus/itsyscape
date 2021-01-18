--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Svalbard/AttackLogic.lua
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

local CURRENT_HITS = B.Reference("Svalbard_AttackLogic", "CURRENT_HITS")
local TARGET_HITS = B.Reference("Svalbard_AttackLogic", "TARGET_HITS")
local REACHED_TARGET = B.Reference("Svalbard_AttackLogic", "REACHED_TARGET")
local ATTACK_POKE = B.Reference("Svalbard_AttackLogic", "ATTACK_POKE")

local MIN_HITS = 1
local MAX_HITS = 2

local CHANCE_VOMIT_ADVENTURER = 2 / 3
local CHANCE_SUMMON_STORM     = 1 / 4

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Random {
			min = MIN_HITS,
			max = MAX_HITS,
			[TARGET_HITS] = B.Output.result
		},

		Mashina.Set {
			value = 0,
			[CURRENT_HITS] = B.Output.result
		},

		Mashina.Set {
			value = false,
			[REACHED_TARGET] = B.Output.result
		},

		Mashina.Peep.PokeSelf {
			event = "boss"
		},

		Mashina.Repeat {
			Mashina.Invert {
				Mashina.Compare.GreaterThan {
					left = CURRENT_HITS,
					right = TARGET_HITS
				}
			},

			Mashina.Success {
				Mashina.Sequence {
					Mashina.Invert {
						Mashina.Check {
							condition = REACHED_TARGET
						}
					},

					Mashina.Compare.Equal {
						left = CURRENT_HITS,
						right = TARGET_HITS
					},

					Mashina.Peep.PokeSelf {
						event = "preSpecial"
					},

					Mashina.Set {
						value = true,
						[REACHED_TARGET] = B.Output.result
					}
				}
			},

			Mashina.ParallelSequence {
				Mashina.Success {
					Mashina.Sequence {
						Mashina.Peep.WasAttacked {
							took_damage = true,
							[ATTACK_POKE] = B.Output.attack_poke
						},

						Mashina.RandomCheck {
							chance = CHANCE_VOMIT_ADVENTURER
						},

						Mashina.Peep.PokeSelf {
							event = "vomitAdventurer",
							poke = ATTACK_POKE
						}
					}
				},

				Mashina.Success {
					Mashina.Sequence {
						Mashina.Peep.DidAttack,

						Mashina.Add {
							left = CURRENT_HITS,
							right = 1,
							[CURRENT_HITS] = B.Output.result
						}
					}
				}
			}
		},

		Mashina.Try {
			Mashina.Sequence {
				Mashina.RandomCheck {
					chance = CHANCE_SUMMON_STORM
				},

				Mashina.Peep.SetState {
					state = "summon"
				},
			},

			Mashina.Peep.PokeSelf {
				event = "special"
			}
		}
	}
}

return Tree
