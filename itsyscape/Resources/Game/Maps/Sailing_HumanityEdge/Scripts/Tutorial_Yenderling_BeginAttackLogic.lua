--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Yenderling_AttackLogic.lua
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
local CommonLogic = require "Resources.Game.Maps.Sailing_HumanityEdge.Scripts.Tutorial_CommonLogic"

local TARGET = B.Reference("Tutorial_Yenderling_AttackLogic", "TARGET")

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		CommonLogic.GetPlayer,

		Mashina.Step {
			Mashina.Sequence {
				Mashina.Success {
					Mashina.Peep.DisengageCombatTarget
				},

				Mashina.Step {
					Mashina.Peep.ApplyEffect {
						effect = "Tutorial_NoKill",
						singular = true
					},

					Mashina.Peep.ApplyEffect {
						effect = "Tutorial_AlwaysHit",
						singular = true
					},

					Mashina.Player.Disable {
						player = PLAYER
					},

					Mashina.Peep.TimeOut {
						duration = 1,
					},

					Mashina.Player.Enable {
						player = PLAYER
					}
				}
			},

			Mashina.Step {
				Mashina.Peep.EngageCombatTarget {
					peep = CommonLogic.PLAYER
				},

				Mashina.Peep.DidAttack,

				Mashina.Peep.RemoveEffect {
					effect = "Tutorial_AlwaysHit",
				},

				Mashina.Peep.RemoveEffect {
					effect = "Tutorial_NoKill",
				},

				Mashina.Peep.SetState {
					state = "attack"
				}
			}
		}
	}
}

return Tree
