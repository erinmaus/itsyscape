--------------------------------------------------------------------------------
-- Resources/Game/Peeps/RatKing/RatKing_HungryLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local BTreeBuilder = require "B.TreeBuilder"
local Mashina = require "ItsyScape.Mashina"
local Probe = require "ItsyScape.Peep.Probe"

local TARGET = B.Reference("RatKing_HungryLogic", "TARGET")
local ATTACK_POKE = B.Reference("RatKing_HungryLogic", "ATTACK_POKE")
local ATTACK_POKE_DAMAGE = B.Reference("RatKing_HungryLogic", "ATTACK_POKE_DAMAGE")

local function ratRobe(p)
	local resource = Utility.Peep.getResource(p)
	if not resource then
		return false
	end

	local tag = self:getDirector():getGameDB():getRecord({
		Value = "Rat",
		Resource = resource
	})

	return tag ~= nil
end

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Success {
			Mashina.Step {
				Mashina.Repeat {
					Mashina.Try {
						Mashina.Peep.FindNearbyCombatTarget {
							filter = ratProbe,
							distance = 10,
							include_npcs = true,
							[TARGET] = B.Output.result
						},

						-- This one should eventually fail to fall back to
						-- the first try sequence above.
						Mashina.Failure {
							Mashina.Step {
								Mashina.Peep.PokeSelf {
									event = "summon"
								},

								Mashina.Peep.Talk {
									message = "You think you've outsmarted me by slaying my court...?"
								},

								Mashina.Peep.Timeout {
									duration = 1
								}
							}
						}
					}
				},

				Mashina.Repeat {
					Mashina.Try {
						Mashina.Sequence {
							Mashina.Peep.IsCombatTarget {
								target = TARGET
							},

							Mashina.Peep.EngageCombatTarget {
								peep = TARGET
							}
						},

						Mashina.Sequence {
							Mashina.Peep.IsCombatTarget {
								target = TARGET
							},

							Mashina.Invert {
								Mashina.Peep.IsDead
							}
						}
					}
				},

				Mashina.Peep.Talk {
					message = "Yum!"
				},

				Mashina.Peep.PokeSelf {
					event = "eat",
					poke = function(_, state)
						return {
							target = state[TARGET]
						}
					end
				}
			}
		},

		Mashina.Peep.FindNearbyCombatTarget {
			[TARGET] = B.Output.result
		},

		Mashina.Peep.EngageCombatTarget {
			peep = TARGET
		},

		Mashina.Peep.SetState {
			state = "attack"
		}
	}
}

return Tree
