--------------------------------------------------------------------------------
-- Resources/Game/Maps/IsabelleIsland_AbandonedMine/Scripts/Orlando_FollowLogic.lua
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

local PLAYER = B.Reference("Orlando", "PLAYER")
local AGGRESSOR = B.Reference("Orlando", "AGGRESSOR")

local DAMAGE_TAKEN = B.Reference("Orlando", "DAMAGE_TAKEN")
local TOTAL_DAMAGE_TAKEN = B.Reference("Orlando", "TOTAL_DAMAGE_TAKEN")

local CURRENT_PASSAGE = B.Reference("Orlando", "CURRENT_PASSAGE")
local CURRENT_PASSAGE_TARGET_NPC = B.Reference("Orlando", "CURRENT_PASSAGE_TARGET_NPC")

local DAMAGE_THRESHOLD = 10
local FUNNY_HEAL_MIN = 100
local FUNNY_HEAL_MAX = 200

local TALK_DURATION = 2.5

local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.Peep.GetPlayer {
			[PLAYER] = B.Output.player
		},

		Mashina.Success {
			Mashina.Sequence {
				Mashina.Check {
					condition = function(_, state) return state[AGGRESSOR] end
				},

				Mashina.Peep.IsDead {
					peep = AGGRESSOR
				},

				Mashina.Set {
					value = false,
					[AGGRESSOR] = B.Output.result
				},

				Mashina.Check {
					condition = function(_, state) return true end
				},
			}
		},

		Mashina.ParallelSequence {
			Mashina.Success {
				Mashina.Step {
					Mashina.Peep.WasAttacked {
						took_damage = true,
						[DAMAGE_TAKEN] = B.Output.damage_received
					},

					Mashina.Add {
						left = DAMAGE_TAKEN,
						right = TOTAL_DAMAGE_TAKEN,
						[TOTAL_DAMAGE_TAKEN] = B.Output.result
					},

					Mashina.Compare.GreaterThan {
						left = TOTAL_DAMAGE_TAKEN,
						right = DAMAGE_THRESHOLD
					},

					Mashina.Set {
						value = 0,
						[TOTAL_DAMAGE_TAKEN] = B.Output.result
					},

					Mashina.Peep.TimeOut {
						DURATION = 2
					},

					Mashina.Peep.PokeSelf {
						event = "heal",
						poke = function(mashina, state)
							return {
								hitPoints = math.random(FUNNY_HEAL_MIN, FUNNY_HEAL_MAX),
								zealous = true
							}
						end
					},

					Mashina.Peep.Talk {
						message = "Not gonna die today!"
					}
				}
			},

			Mashina.Step {
				Mashina.Peep.WasAttacked {
					target = PLAYER,
					took_damage = false,
					[AGGRESSOR] = B.Output.aggressor
				},

				Mashina.Peep.EngageCombatTarget {
					peep = AGGRESSOR
				},

				Mashina.Peep.QueuePower {
					power = "Taunt",
					clear_cool_down = true
				},

				Mashina.Repeat {
					Mashina.Invert {
						Mashina.Peep.IsDead {
							peep = AGGRESSOR
						}
					}
				}
			},

			Mashina.Success {
				Mashina.Sequence {
					Mashina.Check {
						condition = function(_, state) return not state[AGGRESSOR] end
					},

					Mashina.Navigation.TargetMoved {
						peep = PLAYER
					},

					Mashina.Navigation.WalkToPeep {
						peep = PLAYER,
						distance = 2
					}
				}
			},

			Mashina.Success {
				Mashina.Step {
					Mashina.Navigation.EnteredPassage {
						[CURRENT_PASSAGE] = B.Output.passage
					},

					Mashina.Try {
						Mashina.Sequence {
							Mashina.Compare.Equal {
								left = CURRENT_PASSAGE,
								right = "Passage_BossChamber"
							},

							Mashina.Try {
								Mashina.Sequence {
									Mashina.Peep.GetMapObject {
										name = "GhostlyMinerForeman",
										[CURRENT_PASSAGE_TARGET_NPC] = B.Output.peep
									},

									Mashina.Peep.IsDead {
										peep = CURRENT_PASSAGE_TARGET_NPC
									},

									Mashina.Peep.Talk {
										message = "We make a great team!",
										duration = TALK_DURATION
									}
								},

								Mashina.Peep.Talk {
									message = "Mine the pillars! I'll focus on the spooky foreman!",
									duration = TALK_DURATION
								}
							}
						},

						Mashina.Sequence {
							Mashina.Compare.Equal {
								left = CURRENT_PASSAGE,
								right = "Passage_FirstChamber"
							},

							Mashina.Peep.Talk {
								message = "I'll take out the goons, feel free to mine some ore!",
								duration = TALK_DURATION
							}
						},

						Mashina.Sequence {
							Mashina.Compare.Equal {
								left = CURRENT_PASSAGE,
								right = "Passage_CraftingRoom"
							},

							Mashina.Peep.Talk {
								message = "Looks like a handy place to make armor and weapons!",
								duration = TALK_DURATION
							}
						},

						Mashina.Step {
							Mashina.Compare.Equal {
								left = CURRENT_PASSAGE,
								right = "Passage_JoeArea"
							},

							Mashina.Peep.GetMapObject {
								name = "SkeletonMinerJoe",
								[CURRENT_PASSAGE_TARGET_NPC] = B.Output.peep
							},

							Mashina.Peep.Talk {
								message = "Hey, Joe, how's it goin'!",
								duration = TALK_DURATION
							},

							Mashina.Peep.TimeOut {
								duration = TALK_DURATION
							},

							Mashina.Peep.Talk {
								peep = CURRENT_PASSAGE_TARGET_NPC,
								message = "Pretty ore-some... He he he...",
								duration = TALK_DURATION
							},

							Mashina.Peep.TimeOut {
								duration = TALK_DURATION
							},

							Mashina.Peep.Talk {
								message = "Ha! Still got your funny bone, Joe!",
								duration = TALK_DURATION
							},
						}
					}
				}
			}
		}
	}
}

return Tree
