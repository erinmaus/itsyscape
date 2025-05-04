--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Pirate_AttackLogic.lua
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

local TARGET = B.Reference("Tutorial_Pirate_AttackLogic", "TARGET")

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Mashina.Peep.SetStance {
			stance = Weapon.STANCE_AGGRESSIVE
		},

		Mashina.Repeat {
			Mashina.Success {
				Mashina.ParallelTry {
					Mashina.Sequence {
						Mashina.Invert {
							Mashina.Peep.HasCombatTarget
						},

						Mashina.Peep.SetState {
							state = "idle"
						}
					},

					Mashina.Sequence {
						Mashina.Peep.HasCombatTarget {
							[TARGET] = B.Output.target
						},

						Mashina.Invert {
							Mashina.Peep.IsCharacter {
								peep = TARGET,
								character = "VizierRockKnight"
							}
						},

						CommonLogic.Heal
					}
				}
			}
		}
	}
}

return Tree
