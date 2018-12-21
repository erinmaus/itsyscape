--------------------------------------------------------------------------------
-- Resources/Game/Peeps/UndeadSquid/UndeadSquid_SpawnLogic.lua
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

local HITS = B.Reference("UndeadSquid_SpawnLogic", "HITS")
local ATTACK_POKE = B.Reference("UndeadSquid_SpawnLogic", "ATTACK_POKE")
local TARGET = B.Reference("UndeadSquid_SpawnLogic", "TARGET")
local CURRENT_TILE = B.Reference("UndeadSquid_SpawnLogic", "CURRENT_TILE")
local WAS_HIT_IN_FRONT_OF_CANNON = B.Reference("UndeadSquid_SpawnLogic", "WAS_HIT_IN_FRONT_OF_CANNON")

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Set {
			value = 0,
			[HITS] = B.Output.result
		},

		Mashina.Peep.Talk {
			message = "Raaaaaaaa!"
		},

		Mashina.Repeat {
			Mashina.ParallelTry {
				Mashina.Step {
					Mashina.Peep.WasAttacked {
						[ATTACK_POKE] = B.Output.attack_poke
					},

					Mashina.Check {
						condition = function(mashina, state, executor)
							local poke = state[ATTACK_POKE]
							return poke:getWeaponType() ~= 'cannon'
						end
					},

					Mashina.Peep.PokeSelf {
						event = "enraged"
					},

					Mashina.Peep.Talk {
						message = "Eeeeeeeeeeee'rth!"
					},

					Mashina.Add {
						left = HITS,
						right = 1,
						[HITS] = B.Output.result
					},

					Mashina.Compare.GreaterThanEqual {
						left = HITS,
						right = 5
					},

					Mashina.Get {
						value = function(mashina, state, executor)
							local poke = state[ATTACK_POKE]
							return poke:getAggressor()
						end,

						[TARGET] = B.Output.result
					},

					Mashina.Peep.EngageCombatTarget {
						peep = TARGET
					},

					Mashina.Peep.SetState {
						state = "enraged"
					}
				},

				Mashina.Step {
					Mashina.Peep.WasAttacked {
						[ATTACK_POKE] = B.Output.attack_poke
					},

					Mashina.Check {
						condition = function(mashina, state, executor)
							local poke = state[ATTACK_POKE]
							return poke:getWeaponType() == 'cannon'
						end
					},

					Mashina.Try {
						Mashina.Compare.Equal {
							left = "Anchor_Cannon2",
							right = CURRENT_TILE
						},

						Mashina.Compare.Equal {
							left = "Anchor_Cannon1",
							right = CURRENT_TILE
						}
					},

					Mashina.Set {
						value = true,
						[WAS_HIT_IN_FRONT_OF_CANNON] = B.Output.result
					},

					Mashina.Navigation.PathRandom {
						tiles = {
							"Anchor_Left",
							"Anchor_Right"
						},

						[CURRENT_TILE] = B.Output.selected_tile
					},

					Mashina.Peep.Wait,

					Mashina.Set {
						value = false,
						[WAS_HIT_IN_FRONT_OF_CANNON] = B.Output.result
					}
				},

				Mashina.Step {
					Mashina.Invert {
						Mashina.Check {
							condition = WAS_HIT_IN_FRONT_OF_CANNON
						}
					},

					Mashina.Peep.TimeOut {
						min_duration = 4,
						max_duration = 6
					},

					Mashina.Navigation.PathRandom {
						tiles = {
							"Anchor_Left",
							"Anchor_Right"
						},

						[CURRENT_TILE] = B.Output.selected_tile
					},

					Mashina.Peep.Wait,

					Mashina.Peep.TimeOut {
						min_duration = 0.5,
						max_duration = 0.5,
					},

					Mashina.Navigation.Face {
						direction = 1
					},

					Mashina.Peep.TimeOut {
						min_duration = 4,
						max_duration = 6
					},

					Mashina.Navigation.PathRandom {
						tiles = {
							"Anchor_Spawn",
							"Anchor_Cannon1",
							"Anchor_Cannon2"
						},

						[CURRENT_TILE] = B.Output.selected_tile
					},

					Mashina.Peep.Wait,

					Mashina.Peep.TimeOut {
						min_duration = 0.5,
						max_duration = 0.5,
					},

					Mashina.Navigation.Face {
						direction = 1
					},

					Mashina.Peep.PokeSelf {
						event = "attackShip"
					}
				}
			}
		}
	}
}

return Tree
