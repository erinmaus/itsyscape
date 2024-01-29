--------------------------------------------------------------------------------
-- Resources/Game/Maps/Dream_Teaser/Scripts/TheEmptyKing_BeginAttackLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local BTreeBuilder = require "B.TreeBuilder"
local Mashina = require "ItsyScape.Mashina"
local CombatCortex = require "ItsyScape.Peep.Cortexes.CombatCortex"

local STAFF = B.Reference("TheEmptyKing_BeginAttackLogic", "STAFF")
local AGGRESSOR = B.Reference("TheEmptyKing_BeginAttackLogic", "AGGRESSOR")
local PRE_SUMMON_WAIT = 2
local POST_SUMMON_WAIT = 1.25

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Mashina.Success {
			Mashina.Sequence {
				Mashina.Peep.DisengageCombatTarget {
					[AGGRESSOR] = B.Output.current_target
				},

				Mashina.Navigation.Stop,

				Mashina.Peep.Interrupt,
				Mashina.Peep.Interrupt {
					queue = CombatCortex.QUEUE
				}
			}
		},

		Mashina.Step {
			Mashina.Peep.PlayAnimation {
				filename = "Resources/Game/Animations/TheEmptyKing_FullyRealized_SummonWeapon_Magic/Script.lua",
				priority = math.huge
			},

			Mashina.Peep.PlayAnimation {
				filename = "Resources/Game/Animations/TheEmptyKing_FullyRealized_Idle_Magic/Script.lua",
				priority = 100
			},

			Mashina.Peep.GetResource {
				type = "Prop",
				name = "TheEmptyKing_FullyRealized_Staff",
				[STAFF] = B.Output.peep
			},

			Mashina.Peep.PokeSelf {
				event = "summonStaff",
				poke = STAFF
			},

			Mashina.Peep.TimeOut {
				duration = PRE_SUMMON_WAIT
			},

			Mashina.Peep.PokeSelf {
				event = "equipStaff"
			},

			Mashina.Peep.Talk {
				message = "I WILL DECIDE YOUR FATE.",
				duration = 4
			},

			Mashina.Peep.TimeOut {
				duration = POST_SUMMON_WAIT
			},

			Mashina.Peep.StopAnimation,

			Mashina.Peep.EngageCombatTarget {
				peep = AGGRESSOR
			},

			Mashina.Peep.SetState {
				state = "attack"
			}
		}
	}
}

return Tree
