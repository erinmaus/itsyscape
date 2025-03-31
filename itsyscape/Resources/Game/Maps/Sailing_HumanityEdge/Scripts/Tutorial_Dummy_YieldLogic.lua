--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Orlando_FleeLogic.lua
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

local PLAYER = B.Reference("Tutorial_Orlando_FleeLogic", "PLAYER")

local HandleOffense = Mashina.Step {
	Mashina.Peep.ApplyEffect {
		effect = "Tutorial_NoDamage",
		singular = true
	},

	Mashina.Peep.DidAttack,
	Mashina.Peep.DidAttack,
	Mashina.Peep.DidAttack,

	CommonLogic.GetOrlando,

	Mashina.Peep.Talk {
		peep = CommonLogic.ORLANDO,
		message = "The dummy will hold back. Now yield!"
	},

	Mashina.Peep.PokeMap {
		event = "showYieldTutorial",
		poke = PLAYER
	},

	Mashina.Peep.DisengageCombatTarget,

	Mashina.Repeat {
		Mashina.Invert {
			Mashina.Peep.HasCombatTarget {
				peep = PLAYER
			}
		}
	},

	Mashina.Peep.RemoveEffect {
		effect = "Tutorial_NoDamage",
		singular = true
	}
}

local AttackOrDefend = Mashina.ParallelTry {
	HandleDefense,
	CommonLogic.HandleHealing,
	HandleOffense
}

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Mashina.Peep.GetPlayer {
			[PLAYER] = B.Output.player
		},

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
