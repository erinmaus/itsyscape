--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Lyra/FollowLogic.lua
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
local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"

local PLAYER = B.Reference("Lyra", "PLAYER")
local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.Peep.GetPlayer {
			[PLAYER] = B.Output.player
		},

		Mashina.Success {
			Mashina.Sequence {
				Mashina.Check {
					condition = function(lyra, state)
						local player = state[PLAYER]
						if not player or player:getState():has("KeyItem", "SuperSupperSaboteur_MadeCandle") then
							lyra:removeBehavior(FollowerBehavior)

							return true
						end

						return false
					end
				},

				Mashina.Peep.SetState {
					state = false
				}
			}
		},

		Mashina.Success {
			Mashina.Sequence {
				Mashina.Navigation.TargetMoved {
					peep = PLAYER
				},

				Mashina.Navigation.WalkToPeep {
					peep = PLAYER,
					distance = 2,
					as_close_as_possible = false
				}
			}
		}
	}
}

return Tree
