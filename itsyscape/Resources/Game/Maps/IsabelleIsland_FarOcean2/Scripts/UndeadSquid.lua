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
								offset = Ray(Vector(24, 0, -16), -Vector.UNIT_Z),
								distance = DISTANCE,
								face2D = true,
								face3D = true
							},

							Mashina.Sailing.Swim {
								target = TARGET,
								offset = Ray(Vector(-24, 0, -16), -Vector.UNIT_Z),
								distance = DISTANCE,
								face2D = true,
								face3D = true
							},

							Mashina.Sailing.Swim {
								target = TARGET,
								offset = Ray(Vector(24, 0, -32), -Vector.UNIT_Z),
								distance = DISTANCE,
								face2D = true,
								face3D = true
							},

							Mashina.Sailing.Swim {
								target = TARGET,
								offset = Ray(Vector(-24, 0, -32), -Vector.UNIT_Z),
								distance = DISTANCE,
								face2D = true,
								face3D = true
							}
						},

						Mashina.Peep.TimeOut {
							min_duration = 2,
							max_duration = 4
						},


						Mashina.Success {
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

								Mashina.Peep.PokeSelf {
									event = "attackShip",
									poke = TARGET
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
