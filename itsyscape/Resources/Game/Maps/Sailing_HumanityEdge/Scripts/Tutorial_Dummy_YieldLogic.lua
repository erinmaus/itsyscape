--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Dummy_YieldLogic.lua
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

local HandleOffense = Mashina.Step {
	Mashina.Peep.ApplyEffect {
		effect = "Tutorial_NoDamage",
		singular = true
	},

	Mashina.Peep.DidAttack,
	Mashina.Peep.DidAttack,
	Mashina.Peep.DidAttack,

	Mashina.Success {
		Mashina.Peep.DisengageCombatTarget
	},

	Mashina.Player.Disable {
		player = CommonLogic.PLAYER
	},

	Mashina.Player.Dialog {
		peep = CommonLogic.ORLANDO,
		player = CommonLogic.PLAYER,
		main = "quest_tutorial_combat.yield"
	},

	Mashina.Player.Enable {
		player = CommonLogic.PLAYER
	},

	Mashina.Peep.PokeMap {
		event = "showYieldHint",
		poke = CommonLogic.PLAYER
	},

	Mashina.Repeat {
		Mashina.Success {
			Mashina.Peep.DisengageCombatTarget
		},

		Mashina.Invert {
			Mashina.ParallelTry {
				Mashina.Invert {
					Mashina.Peep.HasCombatTarget {
						peep = CommonLogic.PLAYER
					}
				},

				Mashina.Failure {
					Mashina.Step {
						Mashina.Invert {
							Mashina.Player.IsInterfaceOpen {
								player = CommonLogic.PLAYER,
								interface = "TutorialHint"
							}
						},

						Mashina.Peep.WasAttacked,
						Mashina.Peep.WasAttacked,
						Mashina.Peep.WasAttacked,

						Mashina.Player.Disable {
							player = CommonLogic.PLAYER
						},

						Mashina.Player.Dialog {
							peep = CommonLogic.ORLANDO,
							player = CommonLogic.PLAYER,
							main = "quest_tutorial_combat.did_not_yield"
						},

						Mashina.Player.Enable {
							player = CommonLogic.PLAYER
						},

						Mashina.Peep.PokeMap {
							event = "showYieldHint",
							poke = CommonLogic.PLAYER
						}
					}
				}
			}
		}
	},

	Mashina.Player.Disable {
		player = CommonLogic.PLAYER
	},

	Mashina.Player.Dialog {
		peep = CommonLogic.ORLANDO,
		player = CommonLogic.PLAYER,
		main = "quest_tutorial_combat.did_yield"
	},

	Mashina.Player.Enable {
		player = CommonLogic.PLAYER
	},

	Mashina.Peep.RemoveEffect {
		effect = "Tutorial_NoDamage"
	},

	Mashina.Peep.SetState {
		state = "tutorial-eat"
	}
}

local AttackOrDefend = Mashina.ParallelTry {
	Mashina.Failure {
		CommonLogic.Heal
	},

	HandleOffense
}

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Mashina.Peep.GetPlayer {
			[CommonLogic.PLAYER] = B.Output.player
		},

		CommonLogic.GetOrlando,

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
