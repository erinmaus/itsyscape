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
				power = "BindShadow"
			},

			Mashina.Peep.QueuePower {
				power = "BindShadow"
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

	Mashina.Peep.OnPoke {
		event = "powerActivated"
	}
}

local CanUseRite = Mashina.Try {
	Mashina.Sequence {
		Mashina.Peep.IsCombatStyle {
			style = Weapon.STYLE_MAGIC
		},

		Mashina.Peep.CanQueuePower {
			peep = CommonLogic.PLAYER,
			power = "Corrupt"
		}
	},

	Mashina.Sequence {
		Mashina.Peep.IsCombatStyle {
			style = Weapon.STYLE_ARCHERY
		},

		Mashina.Peep.CanQueuePower {
			peep = CommonLogic.PLAYER,
			power = "Snipe"
		}
	},

	Mashina.Sequence {
		Mashina.Peep.IsCombatStyle {
			style = Weapon.STYLE_MELEE
		},

		Mashina.Peep.CanQueuePower {
			peep = CommonLogic.PLAYER,
			power = "Tornado"
		}
	}
}

local CanUseRiteDialog = Mashina.Step {
	CanUseRite,

	Mashina.Invert {
		Mashina.Player.IsInterfaceOpen {
			interface = "DialogBox",
			player = CommonLogic.Player
		}
	},

	Mashina.Player.Disable {
		player = CommonLogic.PLAYER
	},

	Mashina.Player.Dialog {
		peep = CommonLogic.ORLANDO,
		player = CommonLogic.PLAYER,
		main = "quest_tutorial_combat.can_use_rite"
	},

	Mashina.Player.Enable {
		player = CommonLogic.PLAYER
	},
}

local DidUseRiteBefore = Mashina.Peep.OnPoke {
	target = CommonLogic.PLAYER,
	event = "powerActivated"
}

local DidUseRiteBeforeDialog = Mashina.Step {
	DidUseRiteBefore,

	Mashina.Invert {
		Mashina.Player.IsInterfaceOpen {
			interface = "DialogBox",
			player = CommonLogic.Player
		}
	},

	Mashina.Player.Disable {
		player = CommonLogic.PLAYER
	},

	Mashina.Player.Dialog {
		peep = CommonLogic.ORLANDO,
		player = CommonLogic.PLAYER,
		main = "quest_tutorial_combat.preemptively_used_rite"
	},

	Mashina.Player.Enable {
		player = CommonLogic.PLAYER
	}
}

local DidUseCorrectRite = Mashina.Step {
	Mashina.Peep.OnPoke {
		target = CommonLogic.PLAYER,
		event = "powerActivated",
		callback = function(_, _, _, _, e)
			local resourceID = e.power:getResource().name

			if resourceID == "Corrupt" or resourceID == "Snipe" or resourceID == "Tornado" or resourceID == "Bash" then
				return nil, B.Status.Success
			end

			return nil, B.Status.Failure
		end
	},

	Mashina.Player.Disable {
		player = CommonLogic.PLAYER,
	},

	Mashina.Player.Dialog {
		peep = CommonLogic.ORLANDO,
		player = CommonLogic.PLAYER,
		main = "quest_tutorial_combat.correct_rite"
	},

	Mashina.Player.Enable {
		player = CommonLogic.PLAYER,
	}
}

local DidUseIncorrectRite = Mashina.Step {
	Mashina.Peep.OnPoke {
		target = CommonLogic.PLAYER,
		event = "powerActivated"
	},

	Mashina.Player.Disable {
		player = CommonLogic.PLAYER,
	},

	Mashina.Player.Dialog {
		peep = CommonLogic.ORLANDO,
		player = CommonLogic.PLAYER,
		main = "quest_tutorial_combat.incorrect_rite"
	},

	Mashina.Player.Enable {
		player = CommonLogic.PLAYER,
	}
}

local ShowDefensiveRiteHint = Mashina.Sequence {
	Mashina.Peep.IsStance {
		stance = Weapon.STANCE_DEFENSIVE
	},

	Mashina.Peep.PokeMap {
		event = "showDefensiveRiteHint",
		poke = CommonLogic.PLAYER
	}
}

local ShowOffensiveRiteHint = Mashina.Sequence {
	Mashina.Peep.PokeMap {
		event = "showOffensiveRiteHint",
		poke = CommonLogic.PLAYER
	}
}

local WasAttackedWithoutQueuedPower = Mashina.Sequence {
	Mashina.Invert {
		Mashina.Peep.HasQueuedPower {
			target = CommonLogic.PLAYER
		}
	},

	Mashina.Peep.WasAttacked,
}

local IgnoredInstructions = Mashina.Step {
	Mashina.Invert {
		Mashina.Player.IsInterfaceOpen {
			player = CommonLogic.PLAYER,
			interface = "TutorialHint"
		}
	},

	WasAttackedWithoutQueuedPower,
	WasAttackedWithoutQueuedPower,
	WasAttackedWithoutQueuedPower,

	CanUseRite,

	Mashina.Player.Disable {
		player = CommonLogic.PLAYER
	},

	Mashina.Player.Dialog {
		peep = CommonLogic.ORLANDO,
		player = CommonLogic.PLAYER,
		main = "quest_tutorial_combat.did_not_use_rite"
	},

	Mashina.Player.Enable {
		player = CommonLogic.PLAYER
	}
}

local FollowedInstructions = Mashina.ParallelTry {
	Mashina.Failure {
		DidUseIncorrectRite
	},

	DidUseCorrectRite
}

local DidAttackDummy = Mashina.Peep.HasCombatTarget {
	peep = CommonLogic.PLAYER
}

local DidNotAttackDummy = Mashina.Sequence {
	Mashina.Invert {
		Mashina.Peep.HasCombatTarget {
			peep = CommonLogic.PLAYER
		}
	},

	Mashina.Step {
		Mashina.Peep.DidAttack,
		Mashina.Peep.DidAttack,
		Mashina.Peep.DidAttack,

		CommonLogic.GetOrlando,

		Mashina.Player.Disable {
			player = CommonLogic.PLAYER
		},

		Mashina.Player.Dialog {
			peep = CommonLogic.ORLANDO,
			player = CommonLogic.PLAYER,
			main = "quest_tutorial_combat.attack_dummy_again"
		},

		Mashina.Player.Enable {
			player = CommonLogic.PLAYER
		},
	}
}

local HandleOffense = Mashina.Step {
	Mashina.Peep.ApplyEffect {
		effect = "Tutorial_NoDamage",
		singular = true
	},

	Mashina.Peep.EngageCombatTarget {
		peep = CommonLogic.PLAYER
	},

	Mashina.Repeat {
		Mashina.Invert {
			Mashina.ParallelTry {
				DidAttackDummy,

				Mashina.Failure {
					DidNotAttackDummy
				}
			}
		}
	},

	Mashina.Peep.RemoveEffect {
		effect = "Tutorial_NoDamage"
	},

	Mashina.Peep.ApplyEffect {
		effect = "Tutorial_NoKill",
		singular = true
	},

	Mashina.Repeat {
		Mashina.Invert {
			Mashina.Step {
				Mashina.Peep.DidAttack,
				UseRite
			}
		}
	},

	Mashina.Repeat {
		CommonLogic.GetOrlando,

		Mashina.Invert {
			Mashina.ParallelTry {
				CanUseRiteDialog,
				DidUseRiteBeforeDialog
			}
		}
	},

	Mashina.Peep.RemoveEffect {
		effect = "Tutorial_NoKill"
	},

	Mashina.Peep.ApplyEffect {
		effect = "Tutorial_NoDamage",
		singular = true
	},

	Mashina.Repeat {
		Mashina.Invert {
			Mashina.ParallelTry {
				FollowedInstructions,
				Mashina.Failure {
					IgnoredInstructions
				}
			}
		}
	},

	Mashina.Peep.RemoveEffect {
		effect = "Tutorial_NoDamage"
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
					Mashina.Failure {
						CommonLogic.DidYieldDuringCombatTutorial
					},

					AttackOrDefend
				}
			}
		}
	}
}

return Tree
