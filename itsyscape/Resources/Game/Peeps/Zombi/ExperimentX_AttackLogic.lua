--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Zombi/ExperimentX_AttackLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local BTreeBuilder = require "B.TreeBuilder"
local Mashina = require "ItsyScape.Mashina"

local NUM_HITS = B.Reference("ExperimentX_AttackLogic", "NUM_HITS")
local STYLE = B.Reference("ExperimentX_AttackLogic", "STYLE")
local TARGET = B.Reference("ExperimentX_IdleLogic", "TARGET")

local SPECIAL_THRESHOLD = 3
local POWER_TIMEOUT_SECONDS = 1.5

local GetStyle = Mashina.Set {
	value = function(mashina)
		local weapon = Utility.Peep.getEquippedWeapon(mashina, true)
		if weapon and Class.isCompatibleType(weapon, Weapon) then
			return weapon:getStyle()
		end
	end,

	[STYLE] = B.Output.result
}

local CanQueuePower = Mashina.Try {
	Mashina.Sequence {
		Mashina.Compare.Equal {
			left = STYLE,
			right = Weapon.STYLE_MAGIC
		},

		Mashina.Try {
			Mashina.Peep.CanQueuePower {
				power = "Corrupt"
			},

			Mashina.Peep.CanQueuePower {
				power = "IceBarrage"
			}
		}
	},

	Mashina.Sequence {
		Mashina.Compare.Equal {
			left = STYLE,
			right = Weapon.STYLE_MELEE
		},

		Mashina.Try {
			Mashina.Peep.CanQueuePower {
				power = "Tornado"
			},

			Mashina.Peep.CanQueuePower {
				power = "Backstab"
			}
		}
	},

	Mashina.Sequence {
		Mashina.Compare.Equal {
			left = STYLE,
			right = Weapon.STYLE_ARCHERY
		},

		Mashina.Try {
			Mashina.Peep.CanQueuePower {
				power = "Snipe"
			},

			Mashina.Peep.CanQueuePower {
				power = "Boom"
			}
		}
	}
}

local QueuePower = Mashina.Success {
	Mashina.Try {
		Mashina.Sequence {
			Mashina.Compare.Equal {
				left = STYLE,
				right = Weapon.STYLE_MAGIC
			},

			Mashina.RandomTry {
				Mashina.Peep.QueuePower {
					power = "Corrupt",
					require_no_cooldown = true
				},

				Mashina.Peep.QueuePower {
					power = "IceBarrage",
					require_no_cooldown = true
				}
			}
		},

		Mashina.Sequence {
			Mashina.Compare.Equal {
				left = STYLE,
				right = Weapon.STYLE_MELEE
			},

			Mashina.RandomTry {
				Mashina.Peep.QueuePower {
					power = "Tornado",
					require_no_cooldown = true
				},

				Mashina.Peep.QueuePower {
					power = "Backstab",
					require_no_cooldown = true
				}
			}
		},

		Mashina.Sequence {
			Mashina.Compare.Equal {
				left = STYLE,
				right = Weapon.STYLE_ARCHERY
			},

			Mashina.RandomTry {
				Mashina.Peep.QueuePower {
					power = "Snipe",
					require_no_cooldown = true
				},

				Mashina.Peep.QueuePower {
					power = "Boom",
					require_no_cooldown = true
				}
			}
		}
	}
}

local AttackWaitSequence = Mashina.Repeat {
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
}

local AttackSequence = Mashina.Success {
	Mashina.Step {
		AttackWaitSequence,

		Mashina.Peep.TimeOut {
			duration = POWER_TIMEOUT_SECONDS,
		},

		GetStyle,

		Mashina.Success {
			Mashina.Sequence {
				CanQueuePower,
				QueuePower
			}
		},

		Mashina.Peep.DidAttack,

		Mashina.Set {
			value = 0,
			[NUM_HITS] = B.Output.result
		}
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Set {
			value = 1,
			[NUM_HITS] = B.Output.result
		},

		Mashina.Repeat {
			AttackSequence
		}
	}
}

return Tree
