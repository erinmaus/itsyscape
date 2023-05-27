--------------------------------------------------------------------------------
-- Resources/Game/Peeps/UndeadSquid/SewerSpiderMatriarch_AttackLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Probe = require "ItsyScape.Peep.Probe"
local BTreeBuilder = require "B.TreeBuilder"
local Mashina = require "ItsyScape.Mashina"

local PREVIOUS_HEALTH = B.Reference("SewerSpiderMatriarch_AttackLogic", "PREVIOUS_HEALTH")
local CURRENT_HEALTH = B.Reference("SewerSpiderMatriarch_AttackLogic", "CURRENT_HEALTH")

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Get {
			value = function(mashina, state)
				local status = mashina:getBehavior("CombatStatus")
				return (status and status.currentHitpoints) or 1
			end,

			[CURRENT_HEALTH] = B.Output.result
		},

		Mashina.Peep.ActivatePrayer {
			prayer = "MetalSkin"
		},

		Mashina.Peep.ActivatePrayer {
			prayer = "TimeErosion"
		},

		Mashina.Peep.ActivatePrayer {
			prayer = "PathOfLight"
		},

		Mashina.Repeat {
			Mashina.Sequence {
				Mashina.Try {
					Mashina.Peep.WasAttacked,
					Mashina.Peep.WasHealed,
				},

				Mashina.Set {
					value = CURRENT_HEALTH,
					[PREVIOUS_HEALTH] = B.Output.result
				},

				Mashina.Get {
					value = function(mashina, state)
						local status = mashina:getBehavior("CombatStatus")
						return (status and status.currentHitpoints) or 1
					end,

					[CURRENT_HEALTH] = B.Output.result
				},

				Mashina.Success {
					Mashina.Try {
						Mashina.Step {
							Mashina.Check {
								condition = function(mashina, state)
									local status = mashina:getBehavior("CombatStatus")
									local currentHealth = state[CURRENT_HEALTH]
									local previousHealth = state[PREVIOUS_HEALTH]

									if status then
										local halfMaximumHitPoints = status.maximumHitpoints / 2
										if currentHealth < halfMaximumHitPoints and previousHealth > halfMaximumHitPoints then
											return true
										end
									end

									return false
								end
							},

							Mashina.Peep.QueuePower {
								power = "IronSkin"
							}
						},

						Mashina.Step {
							Mashina.Check {
								condition = function(mashina, state)
									local status = mashina:getBehavior("CombatStatus")
									local currentHealth = state[CURRENT_HEALTH]
									local previousHealth = state[PREVIOUS_HEALTH]

									if status then
										local quarterMaximumHitPoints = status.maximumHitpoints / 4
										if currentHealth < quarterMaximumHitPoints and previousHealth > quarterMaximumHitPoints then
											return true
										end
									end

									return false
								end
							},

							Mashina.Peep.QueuePower {
								power = "Absorb"
							}
						}
					}
				}
			},
		}
	}
}

return Tree
