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
local Probe = require "ItsyScape.Peep.Probe"
local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"

local PLAYER = B.Reference("Rosalind", "PLAYER")
local TARGET = B.Reference("Rosalind", "TARGET")
local CURRENT_PASSAGE = B.Reference("Rosalind", "CURRENT_PASSAGE")
local ENTERED_PASSAGE = B.Reference("Rosalind", "ENTERED_PASSAGE")
local TALKED_ABOUT_FISH = B.Reference("Rosalind", "TALKED_ABOUT_FISH")
local TALKED_ABOUT_TREES = B.Reference("Rosalind", "TALKED_ABOUT_TREES")
local TALKED_ABOUT_STANCES = B.Reference("Rosalind", "TALKED_ABOUT_STANCES")

local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.Peep.GetPlayer {
			[PLAYER] = B.Output.player
		},

		Mashina.Success {
			Mashina.Try {
				Mashina.Sequence {
					Mashina.Navigation.EnteredPassage {
						peep = PLAYER,
						[CURRENT_PASSAGE] = B.Output.passage
					},

					Mashina.Set {
						value = true,
						[ENTERED_PASSAGE] = B.Output.result
					}
				},

				Mashina.Set {
					value = false,
					[ENTERED_PASSAGE] = B.Output.result
				}
			}
		},

		Mashina.Try {
			Mashina.Sequence {
				Mashina.Try {
					Mashina.Player.IsNextQuestStep {
						player = PLAYER,
						quest = "PreTutorial",
						step = "PreTutorial_FoundTrees"
					}
				},

				Mashina.Step {
					Mashina.Compare.Equal {
						left = CURRENT_PASSAGE,
						right = "Passage_Trees"
					},

					Mashina.Check {
						condition = ENTERED_PASSAGE,
					},

					Mashina.Invert {
						Mashina.Check {
							condition = TALKED_ABOUT_TREES,
						}
					},

					Mashina.Set {
						value = true,
						[TALKED_ABOUT_TREES] = B.Output.result
					},

					Mashina.Peep.Talk {
						message = "Look, some trees!",
						duration = 4
					},

					Mashina.Player.Disable {
						player = PLAYER
					},

					Mashina.ParallelSequence {
						Mashina.Step {
							Mashina.Player.Walk {
								player = PLAYER,
								distance = 2,
								as_close_as_possible = false,
								target = "Anchor_ToTrees"
							},

							Mashina.Peep.Wait {
								peep = PLAYER
							}
						},

						Mashina.Step {
							Mashina.Peep.Walk {
								target = "Anchor_ToTrees",
								distance = 0,
								as_close_as_possible = true,
							},

							Mashina.Peep.Wait
						}
					},

					Mashina.Player.Enable {
						player = PLAYER,
					},

					Mashina.Player.Dialog {
						named_action = "TalkAboutTrees",
						player = PLAYER
					}
				}
			},

			Mashina.Sequence {
				Mashina.Try {
					Mashina.Player.IsNextQuestStep {
						player = PLAYER,
						quest = "PreTutorial",
						step = "PreTutorial_FoundTrees"
					},

					Mashina.Player.IsNextQuestStep {
						player = PLAYER,
						quest = "PreTutorial",
						step = "PreTutorial_ChoppedTree"
					}
				},

				Mashina.Step {
					Mashina.Compare.Equal {
						left = CURRENT_PASSAGE,
						right = "Passage_ToFishingArea"
					},

					Mashina.Check {
						condition = ENTERED_PASSAGE,
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
						named_action = "TalkAboutTrees",
						player = PLAYER
					}
				}
			},

			Mashina.Sequence {
				Mashina.Try {
					Mashina.Player.IsNextQuestStep {
						player = PLAYER,
						quest = "PreTutorial",
						step = "PreTutorial_FoundFish"
					},

					Mashina.Player.IsNextQuestStep {
						player = PLAYER,
						quest = "PreTutorial",
						step = "PreTutorial_KilledMaggot"
					},
				},

				Mashina.Invert {
					Mashina.Check {
						condition = TALKED_ABOUT_FISH,
					}
				},

				Mashina.Step {
					Mashina.Compare.Equal {
						left = CURRENT_PASSAGE,
						right = "Passage_FishingArea"
					},

					Mashina.Check {
						condition = ENTERED_PASSAGE,
					},

					Mashina.Player.Dialog {
						named_action = "TalkAboutFish",
						player = PLAYER
					},

					Mashina.Set {
						value = true,
						[TALKED_ABOUT_FISH] = B.Output.result
					}
				}
			},

			Mashina.Sequence {
				Mashina.Try {
					Mashina.Player.IsNextQuestStep {
						player = PLAYER,
						quest = "PreTutorial",
						step = "PreTutorial_FoundFish"
					},

					Mashina.Player.IsNextQuestStep {
						player = PLAYER,
						quest = "PreTutorial",
						step = "PreTutorial_KilledMaggot"
					},

					Mashina.Player.IsNextQuestStep {
						player = PLAYER,
						quest = "PreTutorial",
						step = "PreTutorial_Fished"
					},

					Mashina.Player.IsNextQuestStep {
						player = PLAYER,
						quest = "PreTutorial",
						step = "PreTutorial_CookedFish"
					}
				},

				Mashina.Step {
					Mashina.Compare.Equal {
						left = CURRENT_PASSAGE,
						right = "Passage_BeforeTrapdoor"
					},

					Mashina.Check {
						condition = ENTERED_PASSAGE,
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
						target = "Anchor_FromTrapdoor"
					},

					Mashina.Peep.Wait {
						peep = PLAYER
					},

					Mashina.Player.Enable {
						player = PLAYER,
					},

					Mashina.Player.Dialog {
						named_action = "TalkAboutDungeon",
						player = PLAYER
					}
				}
			},

			Mashina.Sequence {
				Mashina.Invert {
					Mashina.Player.HasKeyItem {
						player = PLAYER,
						key_item = "PreTutorial_SleptAtBed"
					}
				},

				Mashina.Step {
					Mashina.Compare.Equal {
						left = CURRENT_PASSAGE,
						right = "Passage_BeforeTrapdoor"
					},

					Mashina.Check {
						condition = ENTERED_PASSAGE,
					},

					Mashina.Peep.Talk {
						message = "Hey, before we go further, follow me!",
						duration = 4
					},

					Mashina.Player.Disable {
						player = PLAYER
					},

					Mashina.ParallelSequence {
						Mashina.Step {
							Mashina.Player.Walk {
								player = PLAYER,
								distance = 2,
								as_close_as_possible = false,
								target = "Anchor_ToBed"
							},

							Mashina.Peep.Wait {
								peep = PLAYER
							}
						},

						Mashina.Step {
							Mashina.Peep.Walk {
								target = "Anchor_ToBed",
								distance = 0,
								as_close_as_possible = true,
							},

							Mashina.Peep.Wait
						}
					},

					Mashina.Player.Enable {
						player = PLAYER,
					},

					Mashina.Player.Dialog {
						named_action = "TalkAboutDungeon",
						player = PLAYER
					}
				}
			},

			Mashina.Sequence {
				Mashina.Player.IsNextQuestStep {
					player = PLAYER,
					quest = "PreTutorial",
					step = "PreTutorial_SlayedYenderling"
				},

				Mashina.Invert {
					Mashina.Check {
						condition = TALKED_ABOUT_STANCES,
					}
				},

				Mashina.Invert {
					Mashina.Player.HasKeyItem {
						player = PLAYER,
						key_item = "PreTutorial_LearnedAboutStances"
					}
				},

				Mashina.Step {
					Mashina.Peep.HasCombatTarget {
						peep = PLAYER
					},

					Mashina.Peep.DidAttack,
					Mashina.Peep.DidAttack,
					Mashina.Peep.DidAttack,

					Mashina.Player.Disable {
						player = PLAYER,
					},

					Mashina.Player.Dialog {
						named_action = "TalkAboutDungeon",
						player = PLAYER
					},

					Mashina.Player.Enable {
						player = PLAYER,
					},

					Mashina.Set {
						value = true,
						[TALKED_ABOUT_STANCES] = B.Output.result
					}
				}
			},

			Mashina.Step {
				Mashina.Player.IsNextQuestStep {
					player = PLAYER,
					quest = "PreTutorial",
					step = "PreTutorial_CollectedAzatiteShards"
				},

				Mashina.Compare.Equal {
					left = CURRENT_PASSAGE,
					right = "Passage_ToMine"
				},

				Mashina.Check {
					condition = ENTERED_PASSAGE,
				},

				Mashina.Player.Disable {
					player = PLAYER
				},

				Mashina.Player.Dialog {
					named_action = "TalkAboutDungeon",
					player = PLAYER
				},

				Mashina.Try {
					-- If the player somehow has azatite shards
					-- but does not have the key item saying they
					-- collected the shards, the dialog will set it.
					-- We don't want to continue if that happened.
					Mashina.Player.IsNextQuestStep {
						player = PLAYER,
						quest = "PreTutorial",
						step = "PreTutorial_CollectedAzatiteShards"
					},

					Mashina.Failure {
						Mashina.Player.Enable {
							player = PLAYER
						}
					}
				},

				Mashina.ParallelSequence {
					Mashina.Step {
						Mashina.Player.Walk {
							player = PLAYER,
							target = "Yenderling",
							distance = 0,
							as_close_as_possible = true
						},

						Mashina.Peep.Wait {
							peep = PLAYER
						}
					},

					Mashina.Step {
						Mashina.Peep.Walk {
							target = "Yenderling",
							distance = 2,
							as_close_as_possible = false
						},

						Mashina.Peep.Wait
					}
				},

				Mashina.Player.Enable {
					player = PLAYER
				}
			},

			Mashina.Step {
				Mashina.Player.IsNextQuestStep {
					player = PLAYER,
					quest = "PreTutorial",
					step = "PreTutorial_MinedCopper"
				},

				Mashina.Invert {
					Mashina.Player.HasKeyItem {
						player = PLAYER,
						key_item = "PreTutorial_TalkedAboutMine"
					}
				},

				Mashina.Compare.Equal {
					left = CURRENT_PASSAGE,
					right = "Passage_ToMine"
				},

				Mashina.Check {
					condition = ENTERED_PASSAGE,
				},

				Mashina.Player.Disable {
					player = PLAYER
				},

				Mashina.Player.Dialog {
					named_action = "TalkAboutDungeon",
					player = PLAYER
				},

				Mashina.ParallelSequence {
					Mashina.Step {
						Mashina.Player.Walk {
							player = PLAYER,
							target = "Anchor_ToMine",
							distance = 0,
							as_close_as_possible = true
						},

						Mashina.Peep.Wait {
							peep = PLAYER
						}
					},

					Mashina.Step {
						Mashina.Peep.TimeOut {
							duration = 2
						},

						Mashina.Peep.Walk {
							target = "Anchor_ToMine",
							distance = 2,
							as_close_as_possible = false
						},

						Mashina.Peep.Wait {
							peep = PLAYER
						}
					}
				},

				Mashina.Player.Dialog {
					named_action = "TalkAboutDungeon",
					player = PLAYER
				},

				Mashina.Player.Enable {
					player = PLAYER
				}
			},

			Mashina.Sequence {
				Mashina.Invert {
					Mashina.Player.HasKeyItem {
						player = PLAYER,
						key_item = "PreTutorial_SmithedUpAndComingHeroArmor"
					}
				},

				Mashina.Step {
					Mashina.Compare.Equal {
						left = CURRENT_PASSAGE,
						right = "Passage_ToBossDoor"
					},

					Mashina.Check {
						condition = ENTERED_PASSAGE,
					},

					Mashina.Player.Disable {
						player = PLAYER
					},

					Mashina.Player.Dialog {
						named_action = "TalkAboutDungeon",
						player = PLAYER
					},

					Mashina.ParallelSequence {
						Mashina.Step {
							Mashina.Player.Walk {
								player = PLAYER,
								target = "Anchor_ToSmithy",
								distance = 0,
								as_close_as_possible = true
							},

							Mashina.Peep.Wait {
								peep = PLAYER
							}
						},

						Mashina.Step {
							Mashina.Peep.Walk {
								target = "Anchor_ToSmithy",
								distance = 2,
								as_close_as_possible = false
							},

							Mashina.Peep.Wait {
								peep = PLAYER
							}
						}
					},

					Mashina.Player.Enable {
						player = PLAYER
					}
				}
			},

			Mashina.Sequence {
				Mashina.Invert {
					Mashina.Player.HasKeyItem {
						player = PLAYER,
						key_item = "PreTutorial_SmithedUpAndComingHeroArmor"
					},
				},

				Mashina.Invert {
					Mashina.Player.HasKeyItem {
						player = PLAYER,
						key_item = "PreTutorial_GetMoreAzatiteShards"
					},
				},

				Mashina.Invert {
					Mashina.Try {
						Mashina.Peep.HasInventoryItem {
							peep = PLAYER,
							item = "AzatiteShard"
						},

						Mashina.Peep.HasInventoryItem {
							peep = PLAYER,
							item = "WeirdAlloyBar"
						}
					}
				},

				Mashina.Invert {
					Mashina.Sequence {
						Mashina.Player.HasKeyItem {
							player = PLAYER,
							key_item = "PreTutorial_SmithedUpAndComingHeroHelmet"
						},

						Mashina.Player.HasKeyItem {
							player = PLAYER,
							key_item = "PreTutorial_SmithedUpAndComingHeroGloves"
						},

						Mashina.Player.HasKeyItem {
							player = PLAYER,
							key_item = "PreTutorial_SmithedUpAndComingHeroPlatebody"
						},

						Mashina.Player.HasKeyItem {
							player = PLAYER,
							key_item = "PreTutorial_SmithedUpAndComingHeroBoots"
						},

					}
				},

				Mashina.Step {
					Mashina.Compare.Equal {
						left = CURRENT_PASSAGE,
						right = "Passage_ToBossDoor"
					},

					Mashina.Check {
						condition = ENTERED_PASSAGE,
					},

					Mashina.Player.Dialog {
						named_action = "TalkAboutDungeon",
						player = PLAYER
					}
				}
			},

			Mashina.Success {
				Mashina.Try {
					Mashina.Sequence {
						Mashina.Invert {
							Mashina.Player.HasKeyItem {
								player = PLAYER,
								key_item = "PreTutorial_SlayedYenderling"
							}
						},

						Mashina.Peep.FindNearbyCombatTarget {
							include_npcs = true,
							filters = {
								Probe.resource("Peep", "PreTutorial_Yenderling")
							},

							[TARGET] = B.Output.result
						},

						Mashina.Step {
							Mashina.Peep.Walk {
								target = "Anchor_BeforeYenderling",
							},

							Mashina.Peep.Wait,

							Mashina.Peep.EngageCombatTarget {
								peep = TARGET
							},

							Mashina.Repeat {
								Mashina.Peep.IsAlive {
									peep = TARGET
								}
							}
						}
					},

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
	}
}

return Tree
