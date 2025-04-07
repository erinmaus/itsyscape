--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Orlando_GeneralAttackLogic.lua
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
local Effect = require "ItsyScape.Peep.Effect"
local Probe = require "ItsyScape.Peep.Probe"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CommonLogic = require "Resources.Game.Maps.Sailing_HumanityEdge.Scripts.Tutorial_CommonLogic"

local MAX_NUM_HEALS = 4
local NUM_HEALS = B.Reference("Tutorial_Orlando_DuelLogic", "NUM_HEALS")

local IsInHealRange = Mashina.Check {
	condition = function(mashina)
		local status = mashina:getBehavior(CombatStatusBehavior)
		if not status then
			return false
		end

		local hitpoints = status.currentHitpoints
		local maximumHitpoints = status.maximumHitpoints
		local thresholdHitpoints = math.max(maximumHitpoints - CommonLogic.HEAL_HITPOINTS, math.ceil(maximumHitpoints / 2))

		return hitpoints < thresholdHitpoints
	end
}

local IsInPeril = Mashina.Check {
	condition = function(mashina)
		local status = mashina:getBehavior(CombatStatusBehavior)
		if not status then
			return false
		end

		local hitpoints = status.currentHitpoints
		local maximumHitpoints = status.maximumHitpoints
		local thresholdHitpoints = math.ceil(maximumHitpoints / 3)

		return hitpoints < thresholdHitpoints
	end
}

local DID_YIELD = B.Reference("Tutorial_Orlando_DuelLogic", "DID_YIELD")

local HandleDefense = Mashina.Step {
	Mashina.Peep.WasAttacked,

	Mashina.Step {
		Mashina.ParallelTry {
			Mashina.Step {
				IsInHealRange,

				Mashina.Compare.LessThan {
					left = NUM_HEALS,
					right = MAX_NUM_HEALS
				},

				Mashina.Add {
					left = NUM_HEALS,
					right = 1,
					[NUM_HEALS] = B.Output.result
				},

				Mashina.Peep.PlayAnimation {
					animation = "Human_ActionEat_1",
					priority = 500
				},

				Mashina.Peep.Heal {
					hitpoints = CommonLogic.HEAL_HITPOINTS
				}
			},

			Mashina.Step {
				IsInPeril,

				Mashina.Invert {
					Mashina.Check {
						condition = DID_YIELD
					}
				},

				Mashina.Invert {
					Mashina.Player.IsInterfaceOpen {
						interface = "DialogBox"
					}
				},

				Mashina.Success {
					Mashina.Peep.DisengageCombatTarget
				},

				Mashina.Player.Disable {
					player = CommonLogic.PLAYER
				},

				Mashina.Player.Dialog {
					peep = CommonLogic.ORLANDO,
					player = CommonLogic.PLAYER,
					main = "quest_tutorial_duel.orlando_yielded"
				},

				Mashina.Player.Enable {
					player = CommonLogic.PLAYER
				},

				Mashina.Set {
					value = true,
					[DID_YIELD] = B.Output.result
				}
			},

			Mashina.Step {
				Mashina.Check {
					condition = DID_YIELD
				},

				Mashina.Peep.WasAttacked,
				Mashina.Peep.WasAttacked,
				Mashina.Peep.WasAttacked,

				Mashina.Player.Disable {
					player = CommonLogic.PLAYER
				},

				CommonLogic.GetKnightCommander,

				Mashina.Player.Dialog {
					peep = CommonLogic.KNIGHT_COMMANDER,
					player = CommonLogic.PLAYER,
					main = "quest_tutorial_duel.punish_player"
				},

				Mashina.Player.Enable {
					player = CommonLogic.PLAYER
				},
			}
		}
	}
}

local DeflectRite = Mashina.Sequence {
	Mashina.Compare.GreaterThanEqual {
		left = NUM_HEALS,
		right = MAX_NUM_HEALS
	},

	IsInPeril,

	Mashina.RandomCheck {
		chance = 0.5
	},

	Mashina.Peep.CanQueuePower {
		power = "Deflect"
	},

	Mashina.Peep.QueuePower {
		power = "Deflect"
	}
}

local MeditateRite = Mashina.Sequence {
	Mashina.Peep.HasEffect {
		effect_type = require "ItsyScape.Peep.Effects.MovementEffect",
		buff_type = Effect.BUFF_TYPE_NEGATIVE,
		min_duration = 15
	},

	Mashina.Peep.CanQueuePower {
		power = "Meditate"
	},

	Mashina.Peep.QueuePower {
		power = "Meditate"
	}
}

local FreedomRite = Mashina.Sequence {
	Mashina.Peep.HasEffect {
		buff_type = Effect.BUFF_TYPE_NEGATIVE,
		min_duration = 15
	},

	Mashina.Try {
		Mashina.Invert {
			Mashina.Peep.HasEffect {
				effect_type = require "ItsyScape.Peep.Effects.MovementEffect",
				buff_type = Effect.BUFF_TYPE_NEGATIVE,
				min_duration = 15
			}
		},

		Mashina.Invert {
			Mashina.Peep.CanQueuePower {
				power = "Meditate"
			}
		}
	},

	Mashina.Peep.CanQueuePower {
		power = "Freedom"
	},

	Mashina.Peep.QueuePower {
		power = "Freedom"
	}
}

local TornadoRite = Mashina.Sequence {
	Mashina.Peep.CanQueuePower {
		power = "Tornado"
	},

	Mashina.Peep.QueuePower {
		power = "Tornado",
		turns = 1
	}
}

local DecapitateRite = Mashina.Sequence {
	Mashina.Peep.CanQueuePower {
		power = "Decapitate"
	},

	Mashina.Peep.QueuePower {
		power = "Decapitate",
		turns = 1
	}
}

local ParryRite = Mashina.Sequence {
	Mashina.Peep.HasQueuedPower {
		target = CommonLogic.PLAYER
	},

	Mashina.Peep.CanQueuePower {
		power = "Parry"	
	},

	Mashina.Peep.WillAttackFirst,

	Mashina.Peep.QueuePower {
		power = "Parry"
	}
}

local EarthquakeRite = Mashina.Sequence {
	Mashina.Peep.CanQueuePower {
		power = "Earthquake"	
	},

	Mashina.Peep.QueuePower {
		power = "Earthquake"
	}
}

local UseRite = Mashina.Try {
	MeditateRite,
	FreedomRite,
	DeflectRite,
	ParryRite,

	Mashina.RandomTry {
		TornadoRite,
		EarthquakeRite
	}
}

local IsPlayerInPeril = Mashina.Check {
	condition = function(mashina, state)
		local peep = state[CommonLogic.PLAYER]
		if not peep then
			return false
		end

		local status = peep:getBehavior(CombatStatusBehavior)
		if not status then
			return false
		end

		local foodCount = peep:getState():count("Item", "CookedLightningStormfish", { ["item-inventory"] = true })
		local hitpoints = status.currentHitpoints
		local halfHitpoints = math.ceil(status.maximumHitpoints / 2)

		return foodCount == 0 and hitpoints < halfHitpoints
	end
}

local ASKED_TO_YIELD = B.Reference("Tutorial_Orlando_DuelLogic", "ASKED_TO_YIELD")

local PlayerShouldYield = Mashina.Step {
	IsPlayerInPeril,

	Mashina.Invert {
		Mashina.Check {
			condition = ASKED_TO_YIELD
		}
	},

	Mashina.Invert {
		Mashina.Player.IsInterfaceOpen {
			interface = "DialogBox"
		}
	},

	Mashina.Success {
		Mashina.Peep.DisengageCombatTarget
	},

	Mashina.Player.Disable {
		player = CommonLogic.PLAYER
	},

	Mashina.Player.Dialog {
		peep = CommonLogic.ORLANDO,
		player = CommonLogic.PLAYER,
		main = "quest_tutorial_duel.player_should_yield"
	},

	Mashina.Player.Enable {
		player = CommonLogic.PLAYER
	},

	Mashina.Set {
		value = true,
		[ASKED_TO_YIELD] = B.Output.result
	},

	Mashina.Peep.Timeout {
		duration = 4
	},

	Mashina.Peep.EngageCombatTarget {
		peep = CommonLogic.PLAYER
	}
}

local HandleRites = Mashina.Step {
	Mashina.Peep.DidAttack,

	UseRite,

	Mashina.Sequence {
		Mashina.Peep.HasQueuedPower,

		Mashina.Peep.OnPoke {
			event = "powerActivated"
		}
	}
}

local DisengageIfYielded = Mashina.Sequence {
	Mashina.Check {
		condition = DID_YIELD
	},

	Mashina.Peep.DisengageCombatTarget
}

local AttackOrDefend = Mashina.ParallelTry {
	Mashina.Failure {
		DisengageIfYielded
	},

	HandleRites,
	Mashina.Failure {
		HandleDefense
	}
}

local DidPlayerYield = Mashina.Step {
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

	Mashina.Player.Disable {
		player = CommonLogic.PLAYER
	},

	Mashina.Player.Dialog {
		peep = CommonLogic.ORLANDO,
		player = CommonLogic.PLAYER,
		main = "quest_tutorial_duel.player_yielded"
	},

	Mashina.Player.Enable {
		player = CommonLogic.PLAYER
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Mashina.Peep.SetStance {
			stance = Weapon.STANCE_CONTROLLED
		},

		Mashina.Peep.GetPlayer {
			[CommonLogic.PLAYER] = B.Output.player
		},

		CommonLogic.GetOrlando,

		Mashina.Step {
			Mashina.Success {
				Mashina.Peep.ApplyEffect {
					target = CommonLogic.PLAYER,
					effect = "Tutorial_NoKill",
					singular = true
				}
			},

			Mashina.Repeat {
				Mashina.Success {
					Mashina.ParallelTry {
						DidPlayerYield,
						PlayerShouldYield,
						AttackOrDefend
					}
				}
			}
		}
	}
}

return Tree
