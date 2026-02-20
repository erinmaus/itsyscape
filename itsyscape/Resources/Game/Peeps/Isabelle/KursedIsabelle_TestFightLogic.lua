--------------------------------------------------------------------------------
-- Resources/Game/Peeps/KursedIsabelle/KursedIsabelle_TestFightLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local BTreeBuilder = require "B.TreeBuilder"
local Weapon = require "ItsyScape.Game.Weapon"
local Mashina = require "ItsyScape.Mashina"

local AGGRESSOR = B.Reference("KursedIsabelle_TestFightLogic", "AGGRESSOR")

local BecomeAttackable = Mashina.Sequence {
	Mashina.Peep.SetResource {
		type = "Peep",
		name = "Isabelle_Kursed_Unknown"
	},

	Mashina.Peep.OverrideTeam {
		character = "Player",
		is_enemy = true
	},

	Mashina.Peep.SetStance {
		stance = Weapon.STANCE_AGGRESSIVE
	}
}

local Begin = Mashina.Step {
	Mashina.Peep.WasAttacked {
		[AGGRESSOR] = B.Output.aggressor
	},

	Mashina.Success {
		Mashina.Peep.EngageCombatTarget {
			peep = AGGRESSOR,
		}
	}
}

local TryAndFailToAttack = Mashina.Success {
	Mashina.Step {
		Mashina.Peep.WasAttacked {
			[AGGRESSOR] = B.Output.aggressor
		},

		Mashina.Peep.Zeal {
			zeal = 0.25
		},

		Mashina.Invert {
			Mashina.Peep.EngageCombatTarget {
				peep = AGGRESSOR,
				require_line_of_sight = true,
				shoot = false
			}
		}
	}
}

local TryAttack = Mashina.Step {
	TryAndFailToAttack,
	TryAndFailToAttack,
	TryAndFailToAttack
}

local Snipe = Mashina.Step {
	Mashina.Player.Disable {
		player = AGGRESSOR,
	},

	Mashina.Peep.Dodge {
		target = AGGRESSOR,
		dodge_backwards = true,
		max_distance = 4
	},

	Mashina.Player.Dialog {
		player = AGGRESSOR,
		named_action = "Talk"
	},

	Mashina.Player.Enable {
		player = AGGRESSOR
	},

	Mashina.Peep.EquipInventoryItem {
		item = "IsabelliumLongbow"
	},

	Mashina.Sequence {
		Mashina.Success {
			Mashina.Peep.Interrupt {
				everything = true
			}
		},

		Mashina.Peep.TimeOut {
			duration = 0.5
		}
	},

	Mashina.Peep.QueuePower {
		power = "Snipe",
		turns = 0
	},

	Mashina.Peep.EngageCombatTarget {
		peep = AGGRESSOR
	},

	Mashina.Peep.DidUsePower,

	Mashina.Peep.DidAttack,
	Mashina.Peep.DidAttack,
	Mashina.Peep.DidAttack
}

local Sizzle = Mashina.Step {
	Mashina.Peep.EquipInventoryItem {
		item = "IsabelliumZweihander"
	},

	Mashina.Success {
		Mashina.Peep.Interrupt {
			everything = true,
		}
	},

	Mashina.Peep.SetState {
		state = false
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		BecomeAttackable,

		Mashina.Success {
			Begin
		},

		Mashina.Success {
			TryAttack
		},

		Mashina.Success {
			Snipe
		},

		Mashina.Success {
			Sizzle
		}
	}
}

return Tree
