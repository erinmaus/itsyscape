--------------------------------------------------------------------------------
-- Resources/Game/Peeps/IsabelleIsland_Rosalind/FollowLogic.lua
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

local PLAYER = B.Reference("Rosalind", "PLAYER")
local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.Peep.GetPlayer {
			[PLAYER] = B.Output.player
		},

		Mashina.Try {
			Mashina.Sequence {
				Mashina.Try {
					Mashina.Player.IsNextQuestStep {
						player = PLAYER,
						quest = "PreTutorial",
						step = "PreTutorial_ChoppedTree"
					},

					Mashina.Player.IsNextQuestStep {
						player = PLAYER,
						quest = "PreTutorial",
						step = "PreTutorial_ChoppedTree"
					}
				},

				Mashina.Peep.Step {
					Mashina.Navigation.EnteredPassage {
						peep = PLAYER,
						passage = "Passage_ToFishingArea"
					},

					Mashina.Peep.Talk {
						message = "Hey, don't go too far yet!",
						duration = 4
					},

					Mashina.Player.Disable {
						player = PLAYER
					},

					Mashina.Player.Walk {
						player = PLAYER,
						target = "Anchor_FromFishingArea"
					},

					Mashina.Peep.Wait {
						peep = PLAYER
					},

					Mashina.Player.Enable {
						player = PLAYER,
					},

					Mashina.Player.Dialog {
						peep = PLAYER
					}
				}
			}
		},

		Mashina.Success {
			Mashina.Sequence {
				Mashina.Invert {
					Mashina.Navigation.TargetMoved {
						peep = PLAYER
					}
				},

				Mashina.Step {
					Mashina.Navigation.WalkToPeep {
						peep = PLAYER,
						distance = 2,
						as_close_as_possible = false
					},

					Mashina.Repeat {
						Mashina.Peep.Wait
					}
				}
			}
		}
	}
}

return Tree
