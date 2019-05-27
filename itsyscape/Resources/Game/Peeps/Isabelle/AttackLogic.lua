--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Isabelle/AttackLogic.lua
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
local Isabelle = require "Resources.Game.Peeps.Isabelle.IsabelleMean"

local HITS = B.Reference("Isabelle_AttackLogic", "HITS")
local STYLE = B.Reference("Isabelle_AttackLogic", "STYLE")

local THRESHOLD_SPECIAL_1 = 4
local THRESHOLD_SPECIAL_2 = 5
local THRESHOLD_SWITCH    = 7

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Set {
			value = Isabelle.STYLE_MELEE,
			[STYLE] = B.Output.result
		},

		Mashina.Peep.Talk {
			message = "Time to die!"
		},

		Mashina.Peep.PokeSelf {
			event = "boss"
		},

		Mashina.Peep.TimeOut {
			min_duration = 2,
			max_duration = 3
		},

		Mashina.Repeat {
			Mashina.Step {
				Mashina.Set {
					value = 0,
					[HITS] = B.Output.result
				},

				Mashina.Peep.Talk {
					message = "Protect me, minions!"
				},

				Mashina.Peep.PokeSelf {
					event = "rezzMinions"
				},

				Mashina.Repeat {
					Mashina.Invert {
						Mashina.Compare.GreaterThanEqual {
							left = HITS,
							right = THRESHOLD_SWITCH
						}
					},

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
						Mashina.Step {
							Mashina.Compare.Equal {
								left = HITS,
								right = THRESHOLD_SPECIAL_1
							},

							Mashina.Peep.Talk {
								message = "Prepare yourself for my next attack!"
							},

							Mashina.Try {
								Mashina.Sequence {
									Mashina.Compare.Equal {
										left = STYLE,
										right = Isabelle.STYLE_MELEE
									},

									Mashina.Peep.QueuePower {
										power = "Tornado",
										clear_cool_down = true
									}
								},

								Mashina.Sequence {
									Mashina.Compare.Equal {
										left = STYLE,
										right = Isabelle.STYLE_MAGIC
									},

									Mashina.Peep.QueuePower {
										power = "Corrupt",
										clear_cool_down = true
									}
								},

								Mashina.Sequence {
									Mashina.Compare.Equal {
										left = STYLE,
										right = Isabelle.STYLE_ARCHERY
									},

									Mashina.Peep.QueuePower {
										power = "Boom",
										clear_cool_down = true
									}
								}
							}
						},
					},

					Mashina.Success {
						Mashina.Step {
							Mashina.Compare.Equal {
								left = HITS,
								right = THRESHOLD_SPECIAL_2
							},

							Mashina.Try {
								Mashina.Sequence {
									Mashina.Compare.Equal {
										left = STYLE,
										right = Isabelle.STYLE_MELEE
									},

									Mashina.Peep.Talk {
										message = "Tornado!"
									}
								},

								Mashina.Sequence {
									Mashina.Compare.Equal {
										left = STYLE,
										right = Isabelle.STYLE_MAGIC
									},

									Mashina.Peep.Talk {
										message = "Feel the corruption!"
									}
								},

								Mashina.Sequence {
									Mashina.Compare.Equal {
										left = STYLE,
										right = Isabelle.STYLE_ARCHERY
									},

									Mashina.Peep.Talk {
										message = "BOOM!"
									}
								}
							}
						},
					}
				},

				Mashina.Compute {
					input = STYLE,
					func = function(s) return (s + 1) % 3 + 1 end,
					[STYLE] = B.Output.output
				},

				Mashina.Peep.PokeSelf {
					event = "switchStyle",
					poke = STYLE
				},

				Mashina.Peep.Talk {
					message = "Time to switch things up!",
				},

				Mashina.Peep.TimeOut {
					min_duration = 1,
					max_duration = 2
				}
			}
		}
	}
}

return Tree
