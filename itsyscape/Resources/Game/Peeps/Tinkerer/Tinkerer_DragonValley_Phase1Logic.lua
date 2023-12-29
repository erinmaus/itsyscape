--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Tinkerer/Tinkerer_DragonValley_Phase1Logic.lua
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
local Weapon = require "ItsyScape.Game.Weapon"
local Mashina = require "ItsyScape.Mashina"
local Probe = require "ItsyScape.Peep.Probe"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"

local EXPERIMENT_X = B.Reference("Tinkerer", "EXPERIMENT_X")
local CURRENT_X_HEALTH = B.Reference("Tinkerer", "CURRENT_X_HEALTH")
local PREVIOUS_X_HEALTH = B.Reference("Tinkerer", "PREVIOUS_X_HEALTH")
local CURRENT_TINKERER_HEALTH = B.Reference("Tinkerer", "CURRENT_TINKERER_HEALTH")
local PREVIOUS_TINKERER_HEALTH = B.Reference("Tinkerer", "PREVIOUS_TINKERER_HEALTH")
local TARGET = B.Reference("Tinkerer", "TARGET")

local HEALTH_THRESHOLD = 800

local Attack = Mashina.Sequence {
	Mashina.Peep.FindNearbyCombatTarget {
		[TARGET] = B.Output.result
	},

	Mashina.Peep.PokeSelf {
		event = "boss",
		poke = function(_, state)
			return {
				target = state[TARGET],
				experiment = state[EXPERIMENT_X]
			}
		end
	},

	Mashina.Peep.Talk {
		message = "Caw! I'll take care of you MYSELF!"
	},

	Mashina.Peep.EngageCombatTarget {
		peep = TARGET,
	},

	Mashina.Peep.SetState {
		state = "attack"
	}
}

local Setup = Mashina.Sequence {
	Mashina.Peep.FindNearbyMapObject {
		name = "ExperimentX",
		[EXPERIMENT_X] = B.Output.result
	},

	Mashina.Success {
		Mashina.Sequence {
			Mashina.Peep.IsDead {
				peep = EXPERIMENT_X
			},

			Attack
		}
	}
}

local Transfer = Mashina.Success {
	Mashina.Sequence {
		Mashina.Compare.LessThan {
			left = CURRENT_X_HEALTH,
			right = PREVIOUS_X_HEALTH
		},

		Mashina.Peep.PokeSelf {
			event = "transferHitpoints",

			poke = function(_, state)
				return {
					target = state[EXPERIMENT_X],
					hitpoints = state[PREVIOUS_X_HEALTH] - state[CURRENT_X_HEALTH]
				}
			end,
		},

		Mashina.Set {
			value = CURRENT_X_HEALTH,
			[PREVIOUS_X_HEALTH] = B.Output.result
		},

		Mashina.Success {
			Mashina.Sequence {
				Mashina.RandomCheck {
					chance = 0.25
				},

				Mashina.Peep.Talk {
					message = "Caw! Caw! Caw!",
					log = false
				}
			}
		}
	}
}

local DropGoryMass = Mashina.Success {
	Mashina.Sequence {
		Mashina.Invert {
			Mashina.Peep.FindNearbyPeep {
				filters = { Probe.resource("Peep", "GoryMass") }
			}
		},

		Mashina.Step {
			Mashina.Check {
				condition = function(_, state)
					local experimentX = state[EXPERIMENT_X]
					local hasTarget = experimentX and experimentX:hasBehavior(CombatTargetBehavior)
					local hasValidTarget = hasTarget and experimentX:getBehavior(CombatTargetBehavior).actor

					return hasValidTarget
				end
			},

			Mashina.Peep.PokeSelf {
				event = "dropGoryMass",
				poke = function(_, state)
					return {
						experiment = state[EXPERIMENT_X]
					}
				end
			},

			Mashina.Peep.Talk {
				message = "Caw! Try and avoid THIS!"
			},

			Mashina.Peep.TimeOut {
				duration = 0.5
			},

			Mashina.Peep.FindNearbyPeep {
				filters = { Probe.resource("Peep", "GoryMass") }
			}
		}
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Setup,

		Mashina.Set {
			value = function(_, state)
				local experimentX = state[EXPERIMENT_X]

				local status = experimentX:getBehavior(CombatStatusBehavior)

				return status and status.currentHitpoints or 0
			end,

			[CURRENT_X_HEALTH] = B.Output.result
		},

		Mashina.Set {
			value = CURRENT_X_HEALTH,
			[PREVIOUS_X_HEALTH] = B.Output.result
		},

		Mashina.Set {
			value = function(mashina)
				local status = mashina:getBehavior(CombatStatusBehavior)
				return status and status.currentHitpoints or 0
			end,

			[CURRENT_TINKERER_HEALTH] = B.Output.result
		},

		Mashina.Set {
			value = CURRENT_TINKERER_HEALTH,
			[PREVIOUS_TINKERER_HEALTH] = B.Output.result
		},

		Mashina.Repeat {
			Mashina.Set {
				value = function(_, state)
					local experimentX = state[EXPERIMENT_X]
					local status = experimentX:getBehavior(CombatStatusBehavior)
					return status and status.currentHitpoints or 0
				end,

				[CURRENT_X_HEALTH] = B.Output.result
			},

			Mashina.Set {
				value = function(mashina)
					local status = mashina:getBehavior(CombatStatusBehavior)
					return status and status.currentHitpoints or 0
				end,

				[CURRENT_TINKERER_HEALTH] = B.Output.result
			},

			Transfer,

			Mashina.Success {
				Mashina.Sequence {
					Mashina.Compare.LessThan {
						left = CURRENT_TINKERER_HEALTH,
						right = HEALTH_THRESHOLD
					},

					Attack
				}
			},

			DropGoryMass
		}
	}
}

return Tree
