--------------------------------------------------------------------------------
-- Resources/Game/Peeps/ViziersRock/Knight_IdleLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local BTreeBuilder = require "B.TreeBuilder"
local Utility = require "ItsyScape.Game.Utility"
local Mashina = require "ItsyScape.Mashina"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"

local TARGET = B.Reference("Knight_AttackLogic", "TARGET")

local Tree = BTreeBuilder.Node() {
	Mashina.Try {
		Mashina.Sequence {
			Mashina.Try {
				Mashina.Peep.FindNearbyCombatTarget {
					include_npcs = true,
					distance = 16,

					filter = function(peep, mashina)
						local target = peep:getBehavior(CombatTargetBehavior)
						target = target and target.actor and target.actor:getPeep()

						if target == mashina then
							return false
						end

						if target then
							local resource = Utility.Peep.getResource(target)
							return resource and resource.name == "Knight_ViziersRock"
						end

						return false
					end,

					[TARGET] = B.Output.result
				},

				Mashina.Failure {
					Mashina.Set {
						value = false,
						[TARGET] = B.Output.result
					}
				}
			},

			Mashina.Step {
				Mashina.Peep.DidAttack {
					peep = TARGET
				},

				Mashina.Navigation.WalkToPeep {
					peep = TARGET,
					distance = 1.5,
					as_close_as_possible = false
				},

				Mashina.Repeat {
					Mashina.Success {
						Mashina.Sequence {
							Mashina.Navigation.TargetMoved {
								peep = TARGET
							},

							Mashina.Navigation.WalkToPeep {
								peep = TARGET,
								distance = 1.5,
								as_close_as_possible = false
							}
						}
					},

					Mashina.Invert {
						Mashina.Peep.Wait
					}
				},

				Mashina.Peep.QueuePower {
					power = "Backstab",
				},

				Mashina.Peep.EngageCombatTarget {
					peep = TARGET
				},

				Mashina.Peep.Talk {
					message = "Halt, villian!"
				},

				Mashina.Peep.SetState {
					state = "attack"
				}
			}
		},

		Mashina.Repeat {
			Mashina.Success {
				Mashina.Sequence {
					Mashina.Check {
						condition = function(_, state) return not state[TARGET] end
					},

					Mashina.Step {
						Mashina.Navigation.Wander {
							radial_distance = 8
						},

						Mashina.Peep.Wait,

						Mashina.Peep.TimeOut {
							min_duration = 3,
							max_duration = 4
						}
					}
				}
			}
		}
	}
}

return Tree
