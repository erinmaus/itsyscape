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

local AXE = B.Reference("TheEmptyKing_BeginAttackLogic", "AXE")
local AGGRESSOR = B.Reference("TheEmptyKing_BeginAttackLogic", "AGGRESSOR")
local PRE_SUMMON_WAIT = 12 / 24
local POST_SUMMON_WAIT = 1.25

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Mashina.Success {
			Mashina.Sequence {
				Mashina.Peep.DisengageCombatTarget {
					[AGGRESSOR] = B.Output.current_target
				},

				Mashina.Navigation.Stop
			}
		},

		Mashina.Step {
			Mashina.Peep.PlayAnimation {
				filename = "Resources/Game/Animations/TheEmptyKing_FullyRealized_SummonWeapon/Script.lua",
				priority = math.huge,
				force = true
			},

			Mashina.Peep.GetResource {
				type = "Prop",
				name = "TheEmptyKingsExecutionerAxe",
				[AXE] = B.Output.peep
			},

			Mashina.Peep.PokeSelf {
				event = "summonAxe",
				poke = AXE
			},

			Mashina.Peep.TimeOut {
				duration = PRE_SUMMON_WAIT
			},

			Mashina.Peep.PokeSelf {
				event = "equipAxe"
			},

			-- Mashina.Peep.Talk {
			-- 	message = "I WILL DECIDE YOUR FATE.",
			-- 	duration = 4
			-- },

			Mashina.Peep.TimeOut {
				duration = POST_SUMMON_WAIT
			},

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
