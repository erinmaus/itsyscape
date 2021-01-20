--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Svalbard/SummonLogic.lua
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

local DAMAGE_THRESHOLD = 500
local CURRENT_DAMAGE_TAKEN = B.Reference("Svalbard_SummonLogic", "CURRENT_DAMAGE_TAKEN")
local TOTAL_DAMAGE_TAKEN = B.Reference("Svalbard_SummonLogic", "TOTAL_DAMAGE_TAKEN")
local DURATION = 15
local ROAR_DURATION = 2

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Set {
			value = 0,
			[TOTAL_DAMAGE_TAKEN] = B.Output.result
		},

		Mashina.Peep.ApplyAttackCooldown {
			duration = DURATION
		},

		Mashina.Peep.PlayAnimation {
			filename = "Resources/Game/Animations/Svalbard_Summon/Script.lua",
			priority = math.huge,
			slot = 'combat',
			force = true
		},

		Mashina.Repeat {
			Mashina.Invert {
				Mashina.ParallelTry {
					Mashina.Sequence {
						Mashina.Peep.TimeOut {
							duration = DURATION,
						},

						Mashina.Peep.PokeSelf {
							event = "summonStorm"
						}
					},

					Mashina.Sequence {
						Mashina.Peep.WasAttacked {
							took_damage = true,
							[CURRENT_DAMAGE_TAKEN] = B.Output.damage_received
						},

						Mashina.Add {
							right = TOTAL_DAMAGE_TAKEN,
							left = CURRENT_DAMAGE_TAKEN,
							[TOTAL_DAMAGE_TAKEN] = B.Output.result
						},

						Mashina.Compare.GreaterThanEqual {
							left = TOTAL_DAMAGE_TAKEN,
							right = DAMAGE_THRESHOLD
						}
					}
				}
			}
		},

		Mashina.Peep.PlayAnimation {
			filename = "Resources/Game/Animations/Svalbard_Roar/Script.lua",
			priority = math.huge,
			slot = 'combat',
			force = true
		},

		Mashina.Peep.ApplyAttackCooldown {
			duration = ROAR_DURATION,
		},

		Mashina.Peep.TimeOut {
			duration = ROAR_DURATION,
		},

		Mashina.Peep.PokeSelf {
			event = "equipRandomWeapon"
		},

		Mashina.Peep.SetState {
			state = "attack"
		}
	}
}

return Tree
