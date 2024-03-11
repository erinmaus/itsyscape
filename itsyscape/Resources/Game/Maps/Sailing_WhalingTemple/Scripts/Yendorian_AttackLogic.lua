--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_WhalingTemple/Scripts/Yendorian_AttackLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local BTreeBuilder = require "B.TreeBuilder"
local Vector = require "ItsyScape.Common.Math.Vector"
local Probe = require "ItsyScape.Peep.Probe"
local Mashina = require "ItsyScape.Mashina"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local PLAYER = B.Reference("Yendorian", "PLAYER")
local ROSALIND = B.Reference("Yendorian", "ROSALIND")
local TARGET = B.Reference("Yendorian", "TARGET")
local CURRENT_HEALTH = B.Reference("Yendorian", "CURRENT_HEALTH")
local HEALTH_DIFFERENCE = B.Reference("Yendorian", "HEALTH_DIFFERENCE")
local SUMMON_MANTOK = B.Reference("Yendorian", "SUMMON_MANTOK")

local PHASE_1_THRESHOLD_HEALTH = 29

local PHASE_3_THRESHOLD_1_HEALTH = 25
local PHASE_3_THRESHOLD_2_HEALTH = 15
local PHASE_3_THRESHOLD_3_HEALTH = 5

local Setup = Mashina.Sequence {
	Mashina.Peep.GetPlayer {
		[PLAYER] = B.Output.player
	},

	Mashina.Peep.FindNearbyPeep {
		filters = {
			Probe.resource("Peep", "IsabelleIsland_Rosalind")
		},

		[ROSALIND] = B.Output.result
	}
}

local AttackLoop = Mashina.Step {
	Mashina.Peep.EngageCombatTarget {
		peep = PLAYER
	},

	Mashina.Peep.DidAttack,
	Mashina.Peep.DidAttack,

	Mashina.Success {
		Mashina.Peep.EngageCombatTarget {
			peep = ROSALIND,
		}
	},

	Mashina.Peep.DidAttack,
	Mashina.Peep.DidAttack
}

local Phase1AttackLogic = Mashina.Repeat {
	Mashina.Compare.GreaterThan {
		left = CURRENT_HEALTH,
		right = PHASE_1_THRESHOLD_HEALTH
	},

	AttackLoop
}

local Phase2AttackLogic = Mashina.Step {
	Mashina.Peep.FireProjectile {
		projectile = "SummonPortal",
		destination = Vector.ZERO
	},

	Mashina.Peep.Talk {
		message = "(Man'tok... Rend a rift...)",
		duration = 4
	},

	Mashina.Peep.Talk {
		peep = ROSALIND,
		message = "Oh no! This is BAD!",
		duration = 4
	},

	Mashina.Peep.TimeOut {
		duration = 4
	},

	Mashina.ParallelTry {
		Mashina.Step {
			Mashina.Player.Dialog {
				named_action = "TalkAboutBoss",
				peep = ROSALIND,
				player = PLAYER
			},

			Mashina.Repeat {
				Mashina.Invert {
					Mashina.Check {
						condition = SUMMON_MANTOK
					}
				}
			}
		},

		Mashina.Step {
			Mashina.Peep.FireProjectile {
				projectile = "SummonPortal",
				destination = Vector.ZERO
			},

			Mashina.Peep.Talk {
				message = "(Man'tok... Hear the pleas of your *cough* child...)",
				duration = 4
			},

			Mashina.Repeat {
				Mashina.ParallelSequence {
					Mashina.Invert {
						Mashina.Peep.PowerApplied
					},

					Mashina.Step {
						Mashina.Peep.FireProjectile {
							projectile = "SummonPortal",
							destination = Vector.ZERO
						},

						Mashina.Peep.TimeOut {
							duration = 4
						},

						Mashina.Peep.Talk {
							message = "(Man'tok... Hear the pleas of your *cough* child...)",
							log = false,
							duration = 2
						},

						Mashina.Subtract {
							left = 30,
							right = CURRENT_HEALTH,
							[HEALTH_DIFFERENCE] = B.Output.result
						},

						Mashina.Peep.Heal {
							hitpoints = HEALTH_DIFFERENCE
						}
					}
				}
			},

			Mashina.Peep.PokeMap {
				event = "openMantokPortal"
			},

			Mashina.Peep.Talk {
				message = "Fools! *cough* You broke my concentration!",
				duration = 4,
			},

			Mashina.Subtract {
				left = 30,
				right = CURRENT_HEALTH,
				[HEALTH_DIFFERENCE] = B.Output.result
			},

			Mashina.Peep.Heal {
				hitpoints = HEALTH_DIFFERENCE
			},

			Mashina.Set {
				value = true,
				[SUMMON_MANTOK] = B.Output.result
			}
		}
	}
}

local Phase3AttackSpecial = Mashina.ParallelTry {
	Mashina.Peep.PowerApplied,

	Mashina.Repeat {
		Mashina.Step {
			Mashina.Peep.FireProjectile {
				projectile = "SummonPortal",
				destination = Vector.ZERO
			},

			Mashina.Peep.Talk {
				message = "Man'tok! Come forth and slay these vermin!",
				log = false,
				duration = 4
			},

			Mashina.Peep.Talk {
				peep = ROSALIND,
				message = "Quick! Use a power!",
				duration = 4
			},

			Mashina.Peep.TimeOut {
				duration = 4
			},

			Mashina.Peep.Talk {
				message = "OH, MAN'TOK! *cough* FATHER! *hack* TEAR THEM APART!",
				log = false,
				duration = 4
			},

			Mashina.Peep.FireProjectile {
				projectile = "SummonPortal",
				destination = Vector.ZERO
			},

			Mashina.Peep.TimeOut {
				duration = 4
			},

			Mashina.Peep.PokeMap {
				event = "summonMantok"
			},

			Mashina.Failure
		}
	}
}

local Phase3AttackSpecialWrapper = function(health)
	return Mashina.Success {
		Mashina.Try {
			Mashina.Sequence {
				Mashina.Compare.GreaterThan {
					left = CURRENT_HEALTH,
					right = health,
				},

				Mashina.Repeat {
					AttackLoop
				}
			},

			Mashina.Sequence {
				Phase3AttackSpecial,

				Mashina.Failure
			}
		}
	}
end

local Phase3AttackLogic = Mashina.Step {
	Phase3AttackSpecialWrapper(PHASE_3_THRESHOLD_1_HEALTH),
	Phase3AttackSpecialWrapper(PHASE_3_THRESHOLD_2_HEALTH),
	Phase3AttackSpecialWrapper(PHASE_3_THRESHOLD_3_HEALTH),

	Mashina.Peep.Talk {
		message = "*cough* I have failed you, Yendor...",
		duration = 4
	}
}

local Die = Mashina.Repeat {
	Mashina.Peep.IsAlive
}

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Setup,

		Mashina.Set {
			value = function(mashina)
				local status = mashina:getBehavior(CombatStatusBehavior)
				return status and status.currentHitpoints or 0
			end,

			[CURRENT_HEALTH] = B.Output.result
		},

		Mashina.Step {
			Phase1AttackLogic,

			Mashina.Sequence {
				Mashina.Success {
					Mashina.Sequence {
						Mashina.Peep.DisengageCombatTarget
					}
				},

				Phase2AttackLogic,
			},

			Phase3AttackLogic,

			Die
		}
	}
}

return Tree
