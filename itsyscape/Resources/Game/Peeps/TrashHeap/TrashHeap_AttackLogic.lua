--------------------------------------------------------------------------------
-- Resources/Game/Peeps/TrashHeap/TrashHeap_AttackLogic.lua
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

local HITS = B.Reference("TrashHeap_AttackLogic", "HITS")

local THRESHOLD_SPECIAL = 3

local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.Step {
			Mashina.Set {
				value = 0,
				[HITS] = B.Output.result
			},

			Mashina.Repeat {
				Mashina.Success {
					Mashina.Sequence {
						Mashina.Peep.DidAttack,

						Mashina.Add {
							left = HITS,
							right = 1,
							[HITS] = B.Output.result
						}
					}
				},

				Mashina.Success {
					Mashina.Sequence {
						Mashina.Compare.GreaterThanEqual {
							left = HITS,
							right = THRESHOLD_SPECIAL
						},

						Mashina.Success {
							Mashina.Try {
								Mashina.Peep.QueuePower {
									power = "Snipe",
									require_no_cooldown = true
								},

								Mashina.Peep.QueuePower {
									power = "TrickShot",
									require_no_cooldown = true
								},

								Mashina.Peep.QueuePower {
									power = "HeadShot",
									require_no_cooldown = true
								}
							}
						},

						Mashina.Set {
							value = 0,
							[HITS] = B.Output.result
						}
					}
				}
			}
		}
	}
}

return Tree
