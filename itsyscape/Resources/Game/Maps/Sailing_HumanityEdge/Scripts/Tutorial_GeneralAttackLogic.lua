--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_GeneralAttackLogic.lua
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
local Weapon = require "ItsyScape.Game.Weapon"
local Mashina = require "ItsyScape.Mashina"
local Probe = require "ItsyScape.Peep.Probe"
local CommonLogic = require "Resources.Game.Maps.Sailing_HumanityEdge.Scripts.Tutorial_CommonLogic"

local CURRENT_TARGET = B.Reference("Tutorial_GeneralAttackLogic", "CURRENT_TARGET")

local DidKillTarget = Mashina.Sequence {
	Mashina.Invert {
		Mashina.Peep.HasCombatTarget,
	},

	Mashina.Invert {
		Mashina.Check {
			condition = CURRENT_TARGET
		}
	},

	Mashina.Peep.SetState {
		state = "tutorial-follow-player"
	}
}

local HandleDefense = Mashina.RandomTry {
	Mashina.Sequence {
		Mashina.Peep.CanQueuePower {
			power = "Riposte"
		},

		Mashina.RandomCheck {
			chance = 0.5
		},

		Mashina.Peep.QueuePower {
			power = "Riposte"
		}
	},

	Mashina.Sequence {
		Mashina.Peep.CanQueuePower {
			power = "Parry"
		},

		Mashina.RandomCheck {
			chance = 0.5
		},

		Mashina.Peep.QueuePower {
			power = "Parry"
		}
	},

	Mashina.Sequence {
		Mashina.Peep.CanQueuePower {
			power = "Deflect"
		},

		Mashina.RandomCheck {
			chance = 0.5
		},

		Mashina.Peep.QueuePower {
			power = "Deflect"
		}
	}
}

local HandleOffense = Mashina.RandomTry {
	Mashina.Sequence {
		Mashina.Peep.CanQueuePower {
			power = "Tornado"
		},

		Mashina.RandomCheck {
			chance = 0.5
		},

		Mashina.Peep.QueuePower {
			power = "Tornado"
		}
	},

	Mashina.Sequence {
		Mashina.Peep.CanQueuePower {
			power = "Decapitate"
		},

		Mashina.RandomCheck {
			chance = 0.5
		},

		Mashina.Peep.QueuePower {
			power = "Decapitate"
		}
	},

	Mashina.Sequence {
		Mashina.Peep.CanQueuePower {
			power = "Earthquake"
		},

		Mashina.RandomCheck {
			chance = 0.5
		},

		Mashina.Peep.QueuePower {
			power = "Earthquake"
		}
	}
}

local HandlePowers = Mashina.Step {
	Mashina.ParallelTry {
		Mashina.Sequence {
			Mashina.Peep.OnPoke {
				event = "heal"
			},

			HandleDefense
		},

		Mashina.Sequence {
			Mashina.Peep.DidAttack,

			Mashina.Peep.HasZeal {
				zeal = 0.5
			},

			HandleOffense
		}
	},

	Mashina.Sequence {
		Mashina.Peep.HasQueuedPower,

		Mashina.Peep.OnPoke {
			event = "powerActivated"
		}
	}
}

local HandleKeelhaulerCharge = Mashina.Step {
	Mashina.Peep.OnEvent {
		event = "tutorialKeelhaulerCharge"
	},

	Mashina.Success {
		Mashina.Sequence {
			Mashina.Peep.HasCombatTarget,

			Mashina.Peep.HasCombatTarget {
				[CURRENT_TARGET] = B.Output.target
			}
		}
	},

	Mashina.Sequence {
		Mashina.Success {
			Mashina.Peep.DisengageCombatTarget
		},

		Mashina.Step {
			Mashina.Try {
				Mashina.Peep.Strafe {
					distance = 10
				},

				Mashina.Failure {
					Mashina.Set {
						value = nil,
						[CURRENT_TARGET] = B.Output.result
					}
				}
			},

			Mashina.Peep.Wait,

			Mashina.Success {
				Mashina.Peep.EngageCombatTarget {
					peep = CURRENT_TARGET
				}
			}
		}
	}
}

local HandleGunner = Mashina.Step {
	Mashina.Peep.OnEvent {
		event = "tutorialGunnerAimCannon"
	},

	Mashina.Success {
		Mashina.Sequence {
			Mashina.Peep.HasCombatTarget,

			Mashina.Peep.HasCombatTarget {
				[CURRENT_TARGET] = B.Output.target
			}
		}
	},

	Mashina.Sequence {
		Mashina.Success {
			Mashina.Peep.DisengageCombatTarget
		},

		Mashina.Step {
			Mashina.Try {
				Mashina.Peep.Strafe {
					target = Vector.UNIT_Z,
					distance = 10
				},

				Mashina.Failure {
					Mashina.Set {
						value = nil,
						[CURRENT_TARGET] = B.Output.result
					}
				}
			},

			Mashina.Peep.Wait,

			Mashina.Peep.TimeOut {
				duration = 1
			},

			Mashina.Success {
				Mashina.Peep.EngageCombatTarget {
					peep = CURRENT_TARGET
				}
			}
		}
	}
}

local AttackOrDefend = Mashina.ParallelTry {
	HandleGunner,
	HandleKeelhaulerCharge,
	DidKillTarget,
	HandlePowers,

	Mashina.Failure {
		CommonLogic.Heal
	},

	Mashina.Sequence {
		CommonLogic.GetPlayer,
		CommonLogic.AvoidCrowding
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Mashina.Peep.SetStance {
			stance = Weapon.STANCE_CONTROLLED
		},

		Mashina.Repeat {
			Mashina.Success {
				AttackOrDefend
			}
		}
	}
}

return Tree
