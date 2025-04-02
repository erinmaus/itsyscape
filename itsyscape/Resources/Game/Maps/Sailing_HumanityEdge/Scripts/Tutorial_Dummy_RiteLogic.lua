--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Dummy_RiteLogic.lua
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
local Probe = require "ItsyScape.Peep.Probe"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CommonLogic = require "Resources.Game.Maps.Sailing_HumanityEdge.Scripts.Tutorial_CommonLogic"

local UseRite = Mashina.Step {
	Mashina.ParallelTry {
		Mashina.Sequence {
			Mashina.Peep.IsCombatStyle {
				style = Weapon.STYLE_MAGIC
			},

			Mashina.Peep.CanQueuePower {
				power = "Gravity"
			},

			Mashina.Peep.QueuePower {
				power = "Gravity"
			}
		},

		Mashina.Sequence {
			Mashina.Peep.IsCombatStyle {
				style = Weapon.STYLE_ARCHERY
			},

			Mashina.Peep.CanQueuePower {
				power = "Snipe"
			},

			Mashina.Peep.QueuePower {
				power = "Snipe"
			}
		},

		Mashina.Sequence {
			Mashina.Peep.IsCombatStyle {
				style = Weapon.STYLE_MELEE
			},

			Mashina.Peep.CanQueuePower {
				power = "Tornado"
			},

			Mashina.Peep.QueuePower {
				power = "Tornado"
			}
		}
	},

	Mashina.Peep.DidAttack
}

local DidUseCorrectRite = {
	Mashina.Step {
		Mashina.Peep.OnPoke {
			target = CommonLogic.PLAYER,
			event = "powerActivated",
			callback = function(_, _, _, _, e)
				local resourceID = e.power:getResource().name

				return resourceID == "Corrupt" or resourceID == "Snipe" or resourceID == "Tornado"
			end
		},

		Mashina.Sequence { 
			Mashina.Success {
				Mashina.DisengageCombatTarget
			},

			Mashina.Step {
				Mashina.Player.Disable {
					player = CommonLogic.PLAYER,
				},

				Mashina.Player.Dialog {
					peep = CommonLogic.ORLANDO,
					player = CommonLogic.PLAYER,
					main = "quest_tutorial_combat.correct_rite"
				}
			}
		}
	}
}

local HandleOffense = Mashina.Step {
	Mashina.Peep.ApplyEffect {
		effect = "Tutorial_NoKill",
		singular = true
	},

	Mashina.Peep.EngageCombatTarget {
		peep = CommonLogic.PLAYER
	},

	Mashina.Repeat {
		Mashina.Step {
			Mashina.Peep.DidAttack,

			Mashina.Invert {
				UseRite
			}
		}
	},

	CommonLogic.GetOrlando,

	Mashina.Player.Disable {
		player = CommonLogic.PLAYER
	},

	Mashina.Player.Dialog {
		peep = CommonLogic.ORLANDO,
		player = CommonLogic.PLAYER,
		main = "quest_tutorial_combat.rites"
	},

	Mashina.Player.Enable {
		player = CommonLogic.PLAYER
	},

	Mashina.Repeat {
		Mashina.ParallelTry {
		},
	}
}