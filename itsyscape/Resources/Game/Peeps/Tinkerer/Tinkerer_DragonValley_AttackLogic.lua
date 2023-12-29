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

local AGGRESSOR = B.Reference("Tinkerer", "AGGRESSOR")
local PRAYER = B.Reference("Tinkerer", "PRAYER")
local NUM_HITS = B.Reference("Tinkerer", "NUM_HITS")
local NUM_GORY_MASSES = B.Reference("Tinkerer", "NUM_GORY_MASSES")
local PREVIOUS_PHASE = B.Reference("Tinkerer", "PREVIOUS_PHASE")
local CURRENT_PHASE = B.Reference("Tinkerer", "CURRENT_PHASE")
local MAXIMUM_HEALTH = B.Reference("Tinkerer", "MAXIMUM_HEALTH")
local CURRENT_HEALTH = B.Reference("Tinkerer", "CURRENT_HEALTH")
local PREVIOUS_HEALTH = B.Reference("Tinkerer", "PREVIOUS_HEALTH")

local SPECIAL_THRESHOLD = 4

local PHASE_1 = 1
local PHASE_2 = 2
local PHASE_3 = 3
local PHASE_4 = 4
local MAX_PHASES = 4

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
				filters = { Probe.resource("Peep", "GoryMass") },
				[NUM_GORY_MASSES] = B.Output.count
			}
		},

		Mashina.Step {
			Mashina.Check {
				condition = function(_, state)
					local phase = state[CURRENT_PHASE]

					if phase >= PHASE_2 then
						return (state[NUM_GORY_MASSES] or 0) < 2
					else
						return (state[NUM_GORY_MASSES] or 0) < 1
					end
				end
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
	Mashina.Peep.Talk {
		message = CURRENT_PHASE,
	},

	Mashina.Compare.GreaterThanEqual {
		left = CURRENT_PHASE,
		right = PHASE_1
	},

	Mashina.Peep.Talk {
		message = "bone blast success"
	},

	Mashina.Peep.PokeSelf {
		event = "summonBoneBlast"
	}
}

local SummonIntestines = Mashina.Sequence {
	Mashina.Compare.GreaterThanEqual {
		left = CURRENT_PHASE,
		right = PHASE_2
	},

	Mashina.Peep.PokeSelf {
		event = "summonIntestines"
	}
}

local SummonSurgeonZombi = Mashina.Sequence {
	Mashina.Compare.GreaterThanEqual {
		left = CURRENT_PHASE,
		right = PHASE_3
	},

	Mashina.Peep.PokeSelf {
		event = "summonSurgeonZombi"
	}
}

local SummonFleshyPillars = Mashina.Sequence {
	Mashina.Compare.GreaterThanEqual {
		left = CURRENT_PHASE,
		right = PHASE_4
	},

	Mashina.Peep.PokeSelf {
		event = "summonFleshyPillars"
	}
}

local AttackSequence = Mashina.Success {
	Mashina.Step {
		AttackWaitSequence,

		Mashina.RandomTry {
			SummonBoneBlast,
			SummonIntestines,
			SummonSurgeonZombi,
			SummonFleshyPillars
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

				SummonIntestines
			},

			Mashina.Step {
				Mashina.Compare.Equal {
					left = CURRENT_PHASE,
					right = PHASE_3
				},

				SummonSurgeonZombi
			},

			Mashina.Step {
				Mashina.Compare.Equal {
					left = CURRENT_PHASE,
					right = PHASE_3
				},

				SummonFleshyPillars
			}
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
				PhaseManager,
				PhaseTransition,
				DropGoryMass,
				AttackSequence
			}
		}
	}
}

return Tree
