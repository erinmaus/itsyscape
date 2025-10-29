--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Yendorian_DeflectLogic.lua
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

local CanUseRite = Mashina.Peep.CanQueuePower {
	power = "Snipe"
}

local UseRite = Mashina.Step {
	Mashina.Peep.QueuePower {
		power = "Snipe",
		turns = 1
	},

	Mashina.Peep.DidAttack,

	Mashina.Peep.HasQueuedPower {
		target = CommonLogic.PLAYER
	},

	Mashina.Peep.OnPoke {
		event = "powerActivated"
	}
}

local CanPlayerUseRite = Mashina.Try {
	Mashina.Sequence {
		Mashina.Peep.IsStance {
			stance = Weapon.STANCE_DEFENSIVE
		},

		Mashina.Peep.CanQueuePower {
			peep = CommonLogic.PLAYER,
			power = "Bash"
		}
	},

	Mashina.Sequence {
		Mashina.Peep.IsCombatStyle {
			style = Weapon.STYLE_MAGIC
		},

		Mashina.Peep.CanQueuePower {
			peep = CommonLogic.PLAYER,
			power = "Confuse"
		}
	},

	Mashina.Sequence {
		Mashina.Peep.IsCombatStyle {
			style = Weapon.STYLE_ARCHERY
		},

		Mashina.Peep.CanQueuePower {
			peep = CommonLogic.PLAYER,
			power = "Shockwave"
		}
	},

	Mashina.Sequence {
		Mashina.Peep.IsCombatStyle {
			style = Weapon.STYLE_MELEE
		},

		Mashina.Peep.CanQueuePower {
			peep = CommonLogic.PLAYER,
			power = "Parry"
		}
	}
}

local CanDeflect = Mashina.Step {
	CanUseRite,

	Mashina.Player.Disable {
		player = CommonLogic.PLAYER
	},

	Mashina.ParallelTry {
		UseRite,

		Mashina.Sequence {
			Mashina.Player.Dialog {
				peep = CommonLogic.ORLANDO,
				player = CommonLogic.PLAYER,
				main = "quest_tutorial_combat.can_deflect"
			}
		}
	},

	Mashina.Player.Enable {
		player = CommonLogic.PLAYER
	}
}

local DidUseCorrectRite = Mashina.Peep.OnPoke {
	target = CommonLogic.PLAYER,
	event = "powerActivated",
	callback = function(_, _, _, _, e)
		local resourceID = e.power:getResource().name

		if resourceID == "Confuse" or resourceID == "Shockwave" or resourceID == "Parry" or resourceID == "Bash" then
			return nil, B.Status.Success
		end

		return nil, B.Status.Failure
	end
}

local DidUseCorrectDeflectRite = Mashina.Step {
	DidUseCorrectRite,

	Mashina.Player.Disable {
		player = CommonLogic.PLAYER,
	},

	Mashina.Player.Dialog {
		peep = CommonLogic.ORLANDO,
		player = CommonLogic.PLAYER,
		main = "quest_tutorial_combat.correct_deflect"
	},

	Mashina.Player.Enable {
		player = CommonLogic.PLAYER,
	}
}

local DidUseIncorrectDeflectRite = Mashina.Step {
	Mashina.Invert {
		DidUseCorrectRite
	},

	Mashina.Player.Disable {
		player = CommonLogic.PLAYER,
	},

	Mashina.Player.Dialog {
		peep = CommonLogic.ORLANDO,
		player = CommonLogic.PLAYER,
		main = "quest_tutorial_combat.incorrect_deflect"
	},

	Mashina.Player.Enable {
		player = CommonLogic.PLAYER,
	}
}

local WasAttackedWithoutQueuedPower = Mashina.Sequence {
	Mashina.Invert {
		Mashina.Peep.HasQueuedPower {
			target = CommonLogic.PLAYER
		}
	},

	Mashina.Invert {
		Mashina.Player.IsCombatRingOpen {
			player = CommonLogic.PLAYER
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

	Mashina.ParallelTry {
		Mashina.Step {
			WasAttackedWithoutQueuedPower,
			WasAttackedWithoutQueuedPower,
			WasAttackedWithoutQueuedPower,
			CanUseRite,
			CanPlayerUseRite
		},

		Mashina.Peep.TimeOut {
			duration = 20
		}
	},

	Mashina.Player.Disable {
		player = CommonLogic.PLAYER
	},

	Mashina.Player.Dialog {
		peep = CommonLogic.ORLANDO,
		player = CommonLogic.PLAYER,
		main = "quest_tutorial_combat.did_not_deflect"
	},

	Mashina.Player.Enable {
		player = CommonLogic.PLAYER
	}
}

local FollowedInstructions = Mashina.ParallelTry {
	DidUseCorrectDeflectRite,
	Mashina.Failure {
		DidUseIncorrectDeflectRite
	}
}

local WillAttack = Mashina.Sequence {
	Mashina.Peep.HasCombatTarget {
		peep = CommonLogic.PLAYER,
		[CommonLogic.PLAYER_TARGET] = B.Output.target
	},

	Mashina.Check {
		condition = function(mashina, state)
			return state[CommonLogic.PLAYER_TARGET] == mashina
		end
	}
}

local DidNotAttack = Mashina.Sequence {
	Mashina.Invert {
		Mashina.Peep.HasCombatTarget {
			peep = CommonLogic.PLAYER
		}
	},

	Mashina.Step {
		Mashina.Peep.DidAttack,
		Mashina.Peep.DidAttack,
		Mashina.Peep.DidAttack,

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

local RiteLoop = Mashina.Repeat {
	Mashina.Invert {
		Mashina.ParallelTry {
			Mashina.Failure {
				UseRite
			},

			Mashina.ParallelTry {
				FollowedInstructions,
				Mashina.Failure {
					IgnoredInstructions
				}
			}
		}
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
				WillAttack,

				Mashina.Failure {
					DidNotAttack
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
			CanDeflect
		}
	},

	RiteLoop,

	Mashina.Peep.SetState {
		state = false
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Mashina.Peep.GetPlayer {
			[CommonLogic.PLAYER] = B.Output.player
		},

		Mashina.Peep.SetStance {
			stance = Weapon.STANCE_CONTROLLED
		},

		CommonLogic.GetOrlando,

		Mashina.Repeat {
			Mashina.Success {
				Mashina.ParallelSequence {
					Mashina.Success {
						CommonLogic.Heal
					},

					HandleOffense
				}
			}
		}
	}
}

return Tree
