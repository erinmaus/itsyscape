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

local CanDummyUseRite = Mashina.Sequence {
	Mashina.Try {
		Mashina.Sequence {
			Mashina.Peep.IsCombatStyle {
				style = Weapon.STYLE_MAGIC
			},

			Mashina.Peep.CanQueuePower {
				power = "BindShadow"
			}
		},

		Mashina.Sequence {
			Mashina.Peep.IsCombatStyle {
				style = Weapon.STYLE_ARCHERY
			},

			Mashina.Peep.CanQueuePower {
				power = "Snipe"
			}
		},

		Mashina.Sequence {
			Mashina.Peep.IsCombatStyle {
				style = Weapon.STYLE_MELEE
			},

			Mashina.Peep.CanQueuePower {
				power = "Tornado"
			}
		}
	}
}

local DummyUseRite = Mashina.Step {
	Mashina.Try {
		Mashina.Sequence {
			Mashina.Peep.IsCombatStyle {
				style = Weapon.STYLE_MAGIC
			},

			Mashina.Peep.QueuePower {
				power = "BindShadow",
				turns = 2
			}
		},

		Mashina.Sequence {
			Mashina.Peep.IsCombatStyle {
				style = Weapon.STYLE_ARCHERY
			},

			Mashina.Peep.QueuePower {
				power = "Snipe",
				turns = 2
			}
		},

		Mashina.Sequence {
			Mashina.Peep.IsCombatStyle {
				style = Weapon.STYLE_MELEE
			},

			Mashina.Peep.QueuePower {
				power = "Tornado",
				turns = 2
			}
		}
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
	Mashina.Sequence {
		CanDummyUseRite,
		CanPlayerUseRite
	},

	Mashina.Player.Disable {
		player = CommonLogic.PLAYER
	},

	Mashina.ParallelTry {
		DummyUseRite,

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

	CanDummyUseRite,
	CanPlayerUseRite,

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

local WillAttackDummy = Mashina.Sequence {
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
				DummyUseRite
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
				WillAttackDummy,

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
			CanDeflect
		}
	},

	Mashina.Peep.RemoveEffect {
		effect = "Tutorial_NoKill"
	},

	Mashina.Peep.ApplyEffect {
		effect = "Tutorial_NoDamage",
		singular = true
	},

	RiteLoop,

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
