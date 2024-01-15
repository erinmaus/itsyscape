--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Tinkerer/Tinkerer_DragonValley_AttackLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local BTreeBuilder = require "B.TreeBuilder"
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local Mashina = require "ItsyScape.Mashina"
local Probe = require "ItsyScape.Peep.Probe"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"

local EXPERIMENT_X = B.Reference("Tinkerer_DragonValley_AttackLogic", "EXPERIMENT_X")
local EXPERIMENT_X_TARGET = B.Reference("Tinkerer_DragonValley_AttackLogic", "EXPERIMENT_X_TARGET")
local FLESHY_PILLAR = B.Reference("Tinkerer_DragonValley_AttackLogic", "FLESHY_PILLAR")
local FLESHY_PILLAR_HITPOINT_TRANSFER = B.Reference("Tinkerer_DragonValley_AttackLogic", "FLESHY_PILLAR_HITPOINT_TRANSFER")
local AGGRESSOR = B.Reference("Tinkerer_DragonValley_AttackLogic", "AGGRESSOR")
local PRAYER = B.Reference("Tinkerer_DragonValley_AttackLogic", "PRAYER")
local NUM_HITS = B.Reference("Tinkerer_DragonValley_AttackLogic", "NUM_HITS")
local NUM_GORY_MASSES = B.Reference("Tinkerer_DragonValley_AttackLogic", "NUM_GORY_MASSES")
local PREVIOUS_PHASE = B.Reference("Tinkerer_DragonValley_AttackLogic", "PREVIOUS_PHASE")
local CURRENT_PHASE = B.Reference("Tinkerer_DragonValley_AttackLogic", "CURRENT_PHASE")
local MAXIMUM_HEALTH = B.Reference("Tinkerer_DragonValley_AttackLogic", "MAXIMUM_HEALTH")
local CURRENT_HEALTH = B.Reference("Tinkerer_DragonValley_AttackLogic", "CURRENT_HEALTH")
local PREVIOUS_HEALTH = B.Reference("Tinkerer_DragonValley_AttackLogic", "PREVIOUS_HEALTH")

local SPECIAL_THRESHOLD = 5

local PHASE_1 = 1
local PHASE_2 = 2
local PHASE_3 = 3
local MAX_PHASES = 3

local MIN_HEAL = 25
local MAX_HEAL = 50
local HEAL_TIMEOUT_SECONDS = 5

local FLESHY_PILLAR_THROTTLE_SECONDS = 60
local GORY_MASS_THROTTLE_SECONDS     = 60

local ReengageSequence = Mashina.Sequence {
	Mashina.Invert {
		Mashina.Peep.HasCombatTarget
	},

	Mashina.Peep.FindNearbyCombatTarget {
		distance = math.huge,
		[TARGET] = B.Output.RESULT
	},

	Mashina.Peep.EngageCombatTarget {
		peep = TARGET,
	},

	Mashina.Peep.PokeSelf {
		event = "boss"
	}
}

local DamageSequence = Mashina.Success {
	Mashina.Sequence {
		Mashina.Try {
			Mashina.Check {
				condition = function(_, state)
					return state[AGGRESSOR]
				end
			},

			Mashina.Peep.WasAttacked {
				took_damage = true,
				[AGGRESSOR] = B.Output.aggressor
			},
		},

		Mashina.Peep.DidAttack,

		Mashina.Set {
			value = function(_, state)
				local aggressor = state[AGGRESSOR]
				local weapon = Utility.Peep.getEquippedWeapon(aggressor, true)
				if weapon and Class.isCompatibleType(weapon, Weapon) then
					local style = weapon:getStyle()

					if style == Weapon.STYLE_MAGIC then
						return "PrisiumsProtection"
					elseif style == Weapon.STYLE_ARCHERY then
						return "BastielsBarricade"
					elseif style == Weapon.STYLE_MELEE then
						return "GammonsGrace"
					else
						return "MetalSkin"
					end
				end
			end,

			[PRAYER] = B.Output.result
		},

		Mashina.Set {
			value = false,
			[AGGRESSOR] = B.Output.result
		},

		Mashina.Invert {
			Mashina.Peep.HasEffect {
				effect_type = PRAYER
			}
		},

		Mashina.Peep.ActivatePrayer {
			prayer = PRAYER,
			toggle
		}
	}
}

local AttackWaitSequence = Mashina.Success {
	Mashina.Sequence {
		Mashina.Repeat {
			Mashina.Peep.DidAttack,

			Mashina.Add {
				left = NUM_HITS,
				right = 1,

				[NUM_HITS] = B.Output.result
			},

			Mashina.Invert {
				Mashina.Compare.GreaterThanEqual {
					left = NUM_HITS,
					right = SPECIAL_THRESHOLD
				}
			}
		},

		Mashina.Peep.PlayAnimation {
			slot = "x-attack",
			filename = "Resources/Game/Animations/Tinkerer_Special_Attack/Script.lua",
			priority = 1500
		},

		Mashina.Peep.Talk {
			message = "Caw! Let's see how you like this!"
		}
	}
}

local DropGoryMass = Mashina.Success {
	Mashina.Sequence {
		Mashina.Success {
			Mashina.Peep.FindNearbyCombatTarget {
				distance = 16,
				include_npcs = true,
				include_dead = true,
				filters = { Probe.resource("Peep", "GoryMass") },
				[NUM_GORY_MASSES] = B.Output.count
			}
		},

		Mashina.Step {
			Mashina.Check {
				condition = function(_, state)
					local phase = state[CURRENT_PHASE]

					if phase >= PHASE_3 then
						return (state[NUM_GORY_MASSES] or 0) < 2
					else
						return (state[NUM_GORY_MASSES] or 0) < 1
					end
				end
			},

			Mashina.Peep.Throttle {
				duration = GORY_MASS_THROTTLE_SECONDS
			},

			Mashina.Peep.PokeSelf {
				event = "dropGoryMass",
				poke = function(mashina, state)
					return {
						experiment = mashina
					}
				end
			},

			Mashina.Peep.Talk {
				message = "Caw! Try and avoid THIS!"
			}
		}
	}
}

local SummonBoneBlast = Mashina.Sequence {
	Mashina.Compare.GreaterThanEqual {
		left = CURRENT_PHASE,
		right = PHASE_1
	},

	Mashina.Peep.PokeSelf {
		event = "summonBoneBlast"
	}
}

local SummonSurgeonZombi = Mashina.Sequence {
	Mashina.Compare.GreaterThanEqual {
		left = CURRENT_PHASE,
		right = PHASE_2
	},

	Mashina.Invert {
		Mashina.Peep.FindNearbyCombatTarget {
			distance = math.huge,
			include_npcs = true,
			filters = { Probe.resource("Peep", "SurgeonZombi") }
		}
	},

	Mashina.Peep.PokeSelf {
		event = "summonSurgeonZombi"
	}
}

local SummonFleshyPillar = Mashina.Sequence {
	Mashina.Compare.GreaterThanEqual {
		left = CURRENT_PHASE,
		right = PHASE_3
	},

	Mashina.Invert {
		Mashina.Peep.FindNearbyCombatTarget {
			distance = math.huge,
			include_npcs = true,
			filters = { Probe.resource("Peep", "EmptyRuins_DragonValley_FleshyPillar") }
		}
	},

	Mashina.Peep.Throttle {
		duration = FLESHY_PILLAR_THROTTLE_SECONDS
	},

	Mashina.Peep.PokeSelf {
		event = "summonFleshyPillar"
	}
}

local AttackSequence = Mashina.Success {
	Mashina.Step {
		AttackWaitSequence,

		Mashina.Peep.DidAttack,

		Mashina.RandomTry {
			SummonBoneBlast,
			SummonSurgeonZombi,
			SummonFleshyPillar
		},

		Mashina.Peep.DidAttack,

		Mashina.Set {
			value = 0,
			[NUM_HITS] = B.Output.result
		}
	}
}

local PhaseTransition = Mashina.Success {
	Mashina.Sequence {
		Mashina.Compare.GreaterThan {
			left = CURRENT_PHASE,
			right = PREVIOUS_PHASE
		},

		Mashina.Try {
			Mashina.Step {
				Mashina.Compare.Equal {
					left = CURRENT_PHASE,
					right = PHASE_2
				},

				SummonSurgeonZombi
			},

			Mashina.Step {
				Mashina.Compare.Equal {
					left = CURRENT_PHASE,
					right = PHASE_3
				},

				SummonFleshyPillar
			}
		},

		-- Let's not have back-to-back specials, please.
		Mashina.Set {
			value = 0,
			[NUM_HITS] = B.Output.result
		},

		Mashina.Set {
			value = CURRENT_PHASE,
			[PREVIOUS_PHASE] = B.Output.result
		}
	}
}

local PhaseManager = Mashina.Success {
	Mashina.Sequence {
		Mashina.Success {
			Mashina.Sequence {
				Mashina.Invert {
					Mashina.Check {
						condition = MAXIMUM_HEALTH
					}
				},

				Mashina.Set {
					value = function(mashina)
						local status = mashina:getBehavior(CombatStatusBehavior)
						return status and status.currentHitpoints
					end,

					[MAXIMUM_HEALTH] = B.Output.result
				},

				Mashina.Set {
					value = MAXIMUM_HEALTH,
					[PREVIOUS_HEALTH] = B.Output.result
				}
			}
		},

		Mashina.Success {
			Mashina.Sequence {
				Mashina.Invert {
					Mashina.Check {
						condition = CURRENT_PHASE
					}
				},

				Mashina.Set {
					value = PHASE_1,
					[CURRENT_PHASE] = B.Output.result
				},

				Mashina.Set {
					value = CURRENT_PHASE,
					[PREVIOUS_PHASE] = B.Output.result
				}
			}
		},

		Mashina.Success {
			Mashina.Sequence {
				Mashina.Set {
					value = function(mashina)
						local status = mashina:getBehavior(CombatStatusBehavior)
						return status and status.currentHitpoints or 0
					end,

					[CURRENT_HEALTH] = B.Output.result
				},

				Mashina.Compare.LessThan {
					left = CURRENT_HEALTH,
					right = PREVIOUS_HEALTH
				},

				Mashina.Set {
					value = function(_, state)
						local maximumHealth = state[MAXIMUM_HEALTH]
						local currentHealth = state[CURRENT_HEALTH]
						local interval = math.floor(maximumHealth / MAX_PHASES)

						return (MAX_PHASES - math.min(math.ceil(currentHealth / interval), MAX_PHASES)) + 1
					end,

					[CURRENT_PHASE] = B.Output.result
				},

				Mashina.Set {
					value = CURRENT_HEALTH,
					[PREVIOUS_HEALTH] = B.Output.result
				}
			}
		}
	}
}

local RezzExperimentX = Mashina.Success {
	Mashina.Sequence {
		Mashina.Peep.FindNearbyCombatTarget {
			distance = math.huge,
			include_npcs = true,
			include_dead = true,
			filters = { Probe.resource("Peep", "ExperimentX") },
			[EXPERIMENT_X] = B.Output.result
		},

		Mashina.Repeat {
			Mashina.Step {
				Mashina.Peep.FindNearbyCombatTarget {
					distance = math.huge,
					include_npcs = true,
					filters = { Probe.resource("Peep", "EmptyRuins_DragonValley_FleshyPillar") },
					[FLESHY_PILLAR] = B.Output.result
				},

				Mashina.Check {
					condition = function(_, state)
						local experimentX = state[EXPERIMENT_X]
						local status = experimentX:getBehavior(CombatStatusBehavior)

						return status.currentHitpoints < status.maximumHitpoints
					end
				},

				Mashina.Peep.Timeout {
					duration = HEAL_TIMEOUT_SECONDS,
				},

				Mashina.Peep.FindNearbyCombatTarget {
					distance = math.huge,
					include_npcs = true,
					filters = { Probe.resource("Peep", "EmptyRuins_DragonValley_FleshyPillar") },
					[FLESHY_PILLAR] = B.Output.result
				},

				Mashina.Peep.Talk {
					peep = FLESHY_PILLAR,
					message = "Slurp... Slurp... Slurp... *gag*",
					log = false
				},

				Mashina.Random {
					min = MIN_HEAL,
					max = MAX_HEAL,
					[FLESHY_PILLAR_HITPOINT_TRANSFER] = B.Output.result
				},

				Mashina.Peep.Hit {
					peep = FLESHY_PILLAR,
					damage = FLESHY_PILLAR_HITPOINT_TRANSFER
				},

				Mashina.Multiply {
					left = FLESHY_PILLAR_HITPOINT_TRANSFER,
					right = 3,
					[FLESHY_PILLAR_HITPOINT_TRANSFER]= B.Output.result
				},

				Mashina.Peep.Heal {
					peep = EXPERIMENT_X,
					hitpoints = FLESHY_PILLAR_HITPOINT_TRANSFER,
					zealous = true
				},

				Mashina.Peep.FireProjectile {
					projectile = "SoulStrike",
					source = FLESHY_PILLAR,
					destination = EXPERIMENT_X
				}
			}
		},
		
		Mashina.Check {
			condition = function(_, state)
				local experimentX = state[EXPERIMENT_X]
				local status = experimentX:getBehavior(CombatStatusBehavior)

				return status.currentHitpoints >= status.maximumHitpoints
			end
		},

		Mashina.Peep.Rezz {
			peep = EXPERIMENT_X
		},

		Mashina.Success {
			Mashina.Sequence {
				Mashina.Peep.FindNearbyCombatTarget {
					distance = math.huge,
					line_of_sight = true,
					[EXPERIMENT_X_TARGET] = B.Output.RESULT
				},

				Mashina.Peep.EngageCombatTarget {
					aggressor = EXPERIMENT_X,
					peep = EXPERIMENT_X_TARGET,
				}
			}
		}
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Peep.ActivatePrayer {
			prayer = "PathOfLight"
		},

		Mashina.Peep.ActivatePrayer {
			prayer = "GammonsReckoning"
		},

		Mashina.Repeat {
			Mashina.ParallelSequence {
				DamageSequence,
				PhaseManager,
				PhaseTransition,
				DropGoryMass,
				AttackSequence,
				RezzExperimentX
			}
		}
	}
}

return Tree
