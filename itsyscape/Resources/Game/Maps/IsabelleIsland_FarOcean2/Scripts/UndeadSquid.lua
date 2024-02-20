--------------------------------------------------------------------------------
-- Resources/Game/Maps/IsabelleIsland_FarOcean/Scripts/UndeadSquid.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local BTreeBuilder = require "B.TreeBuilder"
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local Mashina = require "ItsyScape.Mashina"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"

local TARGET = B.Reference("UndeadSquid", "TARGET")
local SAILOR = B.Reference("UndeadSquid", "SAILOR")
local OFFSET = B.Reference("UndeadSquid", "OFFSET")
local NUM_LEAKS = B.Reference("UndeadSquid", "NUM_LEAKS")

local DISTANCE = 2
local MAX_NUM_LEAKS = 2

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Peep.Talk {
			message = "Raaaaaaaa!",
			log = false
		},

		Mashina.Repeat {
			Mashina.Step {
				Mashina.Peep.TimeOut {
					min_duration = 2,
					max_duration = 4
				},

				Mashina.Success {
					Mashina.Step {
						Mashina.Peep.FindNearbyPeep {
							filters = {
								Probe.resource("Map", "Ship_IsabelleIsland_PortmasterJenkins")
							},

							[TARGET] = B.Output.result
						},

						Mashina.RandomTry {
							Mashina.Sailing.Swim {
								target = TARGET,
								offset = Ray(Vector(16, 0, -16), -Vector.UNIT_Z),
								distance = DISTANCE,
								face2D = true,
								face3D = true
							},

							Mashina.Sailing.Swim {
								target = TARGET,
								offset = Ray(Vector(-16, 0, -16), -Vector.UNIT_Z),
								distance = DISTANCE,
								face2D = true,
								face3D = true
							},

							Mashina.Sailing.Swim {
								target = TARGET,
								offset = Ray(Vector(16, 0, -32), -Vector.UNIT_Z),
								distance = DISTANCE,
								face2D = true,
								face3D = true
							},

							Mashina.Sailing.Swim {
								target = TARGET,
								offset = Ray(Vector(-16, 0, -32), -Vector.UNIT_Z),
								distance = DISTANCE,
								face2D = true,
								face3D = true
							}
						},

						Mashina.Peep.TimeOut {
							min_duration = 2,
							max_duration = 4
						},


						Mashina.RandomTry {
							Mashina.Sequence {
								Mashina.Try {
								Mashina.Invert {
									Mashina.Peep.FindNearbyPeep {
										filters = {
											Probe.resource("Prop", "IsabelleIsland_Port_WaterLeak")
										},

										[NUM_LEAKS] = B.Output.count
									}
								},

								Mashina.Compare.LessThan {
									left = NUM_LEAKS,
									right = MAX_NUM_LEAKS
								}
								},

								Mashina.RandomCheck {
									chance = 0.5,
								},

								Mashina.Peep.PokeSelf {
									event = "attackShip",
									poke = TARGET
								}
							},

							Mashina.Sequence {
								Mashina.RandomTry {
									Mashina.Peep.FindNearbyCombatTarget {
										filter = Probe.resource("Peep", "Sailor_Panicked"),
										include_npcs = true,
										same_layer = false,
										[SAILOR] = B.Output.result
									},

									Mashina.Peep.FindNearbyCombatTarget {
										filter = Probe.resource("Peep", "IsabelleIsland_Orlando"),
										include_npcs = true,
										same_layer = false,
										[SAILOR] = B.Output.result
									},

									Mashina.Peep.FindNearbyCombatTarget {
										filter = Probe.resource("Peep", "IsabelleIsland_Rosalind"),
										include_npcs = true,
										same_layer = false,
										[SAILOR] = B.Output.result
									},

									-- Player.
									Mashina.Peep.FindNearbyCombatTarget {
										same_layer = false,
										[SAILOR] = B.Output.result
									}
								},

								Mashina.Peep.PokeSelf {
									event = "ink",
									poke = function(_, state)
										return {
											target = state[SAILOR],
											min = 0,
											max = 0
										}
									end
								}
							}
						}
					}
				}
			}
		}
	}
}

return Tree
