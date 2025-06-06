--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Orlando_EatLogic.lua
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

local HandleEarlyEat = Mashina.Step {
	Mashina.Peep.OnPoke {
		target = CommonLogic.PLAYER,
		event = "heal"
	},

	Mashina.Player.Disable {
		player = CommonLogic.PLAYER
	},

	Mashina.Player.Dialog {
		peep = CommonLogic.ORLANDO,
		player = CommonLogic.PLAYER,
		main = "quest_tutorial_combat.eat_early"
	},

	Mashina.Player.Enable {
		player = CommonLogic.PLAYER
	},

	Mashina.Peep.SetState {
		state = "tutorial-rites"
	}
}

local HandleOffense = Mashina.Step {
	Mashina.Peep.RemoveEffect {
		effect = "Tutorial_NoDamage",
	},

	Mashina.Peep.ApplyEffect {
		effect = "Tutorial_NoKill",
		singular = true
	},

	Mashina.Peep.ApplyEffect {
		effect = "Tutorial_AlwaysHit",
		singular = true
	},

	Mashina.Peep.EngageCombatTarget {
		peep = CommonLogic.PLAYER
	},

	Mashina.Peep.DidAttack,
	Mashina.Peep.DidAttack,
	Mashina.Peep.DidAttack,

	Mashina.Peep.RemoveEffect {
		effect = "Tutorial_AlwaysHit",
	},

	Mashina.Peep.RemoveEffect {
		effect = "Tutorial_NoKill",
	},

	Mashina.Peep.ApplyEffect {
		effect = "Tutorial_NoDamage",
		singular = true
	},

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
		state = "tutorial-rites"
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
				Mashina.ParallelTry {
					Mashina.Failure {
						CommonLogic.DidYieldDuringCombatTutorial
					},

					Mashina.Try {
						Mashina.Failure {
							CommonLogic.IsYielding
						},

						AttackOrDefend
					}
				}
			}
		}
	}
}

return Tree
