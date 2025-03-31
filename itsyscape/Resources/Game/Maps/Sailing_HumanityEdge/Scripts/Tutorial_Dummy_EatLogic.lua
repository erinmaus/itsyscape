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
	Mashina.Peep.RemoveEffect {
		effect = "Tutorial_NoDamage",
		singular = true
	},

	Mashina.Peep.ApplyEffect {
		effect = "Tutorial_NoKill",
		singular = true
	},

	Mashina.Peep.EngageCombatTarget {
		peep = CommonLogic.PLAYER
	},

	Mashina.Peep.DidAttack,
	Mashina.Peep.DidAttack,
	Mashina.Peep.DidAttack,

	Mashina.Peep.RemoveEffect {
		effect = "Tutorial_NoKill",
		singular = true
	},

	Mashina.Peep.ApplyEffect {
		effect = "Tutorial_NoDamage",
		singular = true
	},

	CommonLogic.GetOrlando,

	Mashina.Player.Disable {
		player = CommonLogic.PLAYER
	},

	Mashina.Player.Dialog {
		peep = CommonLogic.ORLANDO,
		player = CommonLogic.PLAYER,
		main = "quest_tutorial_combat.eat"
	},

	Mashina.Player.Enable {
		player = CommonLogic.PLAYER
	},

	Mashina.Peep.PokeMap {
		event = "showEatHint",
		poke = CommonLogic.PLAYER
	},

	Mashina.Repeat {
		Mashina.Success {
			Mashina.Peep.DisengageCombatTarget
		},

		Mashina.Invert {
			Mashina.ParallelTry {
				Mashina.Peep.OnPoke {
					target = CommonLogic.PLAYER,
					event = "heal"
				},

				Mashina.Failure {
					Mashina.Step {
						Mashina.Invert {
							Mashina.Player.IsInterfaceOpen {
								player = CommonLogic.PLAYER,
								interface = "TutorialHint"
							},
						},

						Mashina.Peep.DidAttack,
						Mashina.Peep.DidAttack,
						Mashina.Peep.DidAttack,

						Mashina.Player.Disable {
							player = CommonLogic.PLAYER
						},

						Mashina.Player.Dialog {
							peep = CommonLogic.ORLANDO,
							player = CommonLogic.PLAYER,
							main = "quest_tutorial_combat.did_not_eat"
						},

						Mashina.Player.Enable {
							player = CommonLogic.PLAYER
						},

						Mashina.Peep.PokeMap {
							event = "showEatHint",
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
		main = "quest_tutorial_combat.did_eat"
	},

	Mashina.Player.Enable {
		player = CommonLogic.PLAYER
	},

	Mashina.Peep.RemoveEffect {
		effect = "Tutorial_NoDamage",
	},

	Mashina.Peep.SetState {
		state = false
	}
}

local AttackOrDefend = Mashina.ParallelTry {
	Mashina.Failure {
		CommonLogic.Heal
	},

	HandleOffense
}

local Disengage = Mashina.Step {
	Mashina.Peep.HasCombatTarget {
		peep = CommonLogic.PLAYER
	},

	Mashina.Repeat {
		Mashina.Peep.HasCombatTarget {
			peep = CommonLogic.PLAYER
		}
	},

	Mashina.Success {
		Mashina.Peep.DisengageCombatTarget
	},

	CommonLogic.GetOrlando,

	Mashina.Player.Disable {
		player = CommonLogic.PLAYER
	},

	Mashina.Player.Dialog {
		peep = CommonLogic.ORLANDO,
		player = CommonLogic.PLAYER,
		main = "quest_tutorial_combat.yield_during_eat"
	},

	Mashina.Player.Enable {
		player = CommonLogic.PLAYER
	},
}

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Mashina.Peep.GetPlayer {
			[CommonLogic.PLAYER] = B.Output.player
		},

		Mashina.Peep.SetStance {
			stance = Weapon.STANCE_CONTROLLED
		},

		Mashina.Repeat {
			Mashina.Success {
				Mashina.ParallelTry {
					Disengage,
					AttackOrDefend
				}
			}
		}
	}
}

return Tree
