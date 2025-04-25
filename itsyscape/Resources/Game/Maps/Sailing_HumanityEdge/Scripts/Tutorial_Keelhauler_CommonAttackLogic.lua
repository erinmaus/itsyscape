--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Keelhauler_CommonAttackLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local BTreeBuilder = require "B.TreeBuilder"
local Vector = require "ItsyScape.Common.Math.Vector"
local Weapon = require "ItsyScape.Game.Weapon"
local Mashina = require "ItsyScape.Mashina"
local CommonLogic = require "Resources.Game.Maps.Sailing_HumanityEdge.Scripts.Tutorial_CommonLogic"

local CURRENT_TARGET = B.Reference("Tutorial_Keelhauler_CommonAttackLogic", "CURRENT_TARGET")

local Roar = Mashina.Step {
	Mashina.Peep.PlayAnimation {
		animation = "Keelhauler_Roar"
	},

	Mashina.Repeat {
		Mashina.Success {
			Mashina.Peep.DisengageCombatTarget
		},

		Mashina.Failure {
			Mashina.Peep.TimeOut {
				duration = 2
			}
		}
	},

	Mashina.Check {
		condition = CURRENT_TARGET
	},

	Mashina.Peep.EngageCombatTarget {
		peep = CURRENT_TARGET
	}
}

local SwitchToWeakStyle = Mashina.Success {
	Mashina.Sequence {
		Mashina.Success {
			Mashina.Sequence {
				Mashina.Peep.HasCombatTarget,

				Mashina.Peep.HasCombatTarget {
					[CURRENT_TARGET] = B.Output.target
				}
			}
		},

		Mashina.Check {
			condition = CURRENT_TARGET
		},

		Mashina.ParallelTry {
			Mashina.Step {
				Mashina.Peep.IsCombatStyle {
					target = CURRENT_TARGET,
					style = Weapon.STYLE_MAGIC
				},

				Mashina.Invert {
					Mashina.Peep.IsCombatStyle {
						style = Weapon.STYLE_MELEE
					}
				},

				Mashina.Peep.EquipXWeapon {
					x_weapon = "Keelhauler_Bite"
				},

				Roar
			},

			Mashina.Step {
				Mashina.Peep.IsCombatStyle {
					target = CURRENT_TARGET,
					style = Weapon.STYLE_ARCHERY
				},

				Mashina.Invert {
					Mashina.Peep.IsCombatStyle {
						style = Weapon.STYLE_MAGIC
					}
				},

				Mashina.Peep.EquipXWeapon {
					x_weapon = "Keelhauler_FireBreathe"
				},

				Roar
			},

			Mashina.Step {
				Mashina.Peep.IsCombatStyle {
					target = CURRENT_TARGET,
					style = Weapon.STYLE_MELEE
				},

				Mashina.Invert {
					Mashina.Peep.IsCombatStyle {
						style = Weapon.STYLE_ARCHERY
					}
				},

				Mashina.Peep.EquipXWeapon {
					x_weapon = "Keelhauler_MudSplash"
				},

				Roar
			}
		}
	}
}

local SwitchToStrongStyle = Mashina.Success {
	Mashina.Sequence {
		Mashina.Success {
			Mashina.Sequence {
				Mashina.Peep.HasCombatTarget,

				Mashina.Peep.HasCombatTarget {
					[CURRENT_TARGET] = B.Output.target
				}
			}
		},

		Mashina.Check {
			condition = CURRENT_TARGET
		},

		Mashina.Try {
			Mashina.Step {
				Mashina.Peep.IsCombatStyle {
					target = CURRENT_TARGET,
					style = Weapon.STYLE_MAGIC
				},

				Mashina.Invert {
					Mashina.Peep.IsCombatStyle {
						style = Weapon.STYLE_ARCHERY
					}
				},

				Mashina.Peep.EquipXWeapon {
					x_weapon = "Keelhauler_MudSplash"
				},

				Roar
			},

			Mashina.Step {
				Mashina.Peep.IsCombatStyle {
					target = CURRENT_TARGET,
					style = Weapon.STYLE_ARCHERY
				},

				Mashina.Invert {
					Mashina.Peep.IsCombatStyle {
						style = Weapon.STYLE_MELEE
					}
				},

				Mashina.Peep.EquipXWeapon {
					x_weapon = "Keelhauler_Bite"
				},

				Roar
			},

			Mashina.Step {
				Mashina.Peep.IsCombatStyle {
					target = CURRENT_TARGET,
					style = Weapon.STYLE_MELEE
				},

				Mashina.Invert {
					Mashina.Peep.IsCombatStyle {
						style = Weapon.STYLE_MAGIC
					}
				},

				Mashina.Peep.EquipXWeapon {
					x_weapon = "Keelhauler_FireBreathe"
				},

				Roar
			}
		}
	}
}

local SwitchToPlayer = Mashina.Sequence {
	CommonLogic.GetPlayer,

	Mashina.Peep.EngageCombatTarget {
		peep = CommonLogic.PLAYER
	}
}

local SwitchToOrlando = Mashina.Sequence {
	CommonLogic.GetOrlando,

	Mashina.Peep.EngageCombatTarget {
		peep = CommonLogic.ORLANDO
	}
}

local WaitOnTarget = Mashina.Step {
	Mashina.Peep.DidAttack,
	Mashina.Peep.DidAttack,
	Mashina.Peep.DidAttack,

	Mashina.Peep.TimeOut {
		duration = 2
	}
}

local IS_DASHING = B.Reference("Tutorial_Keelhauler_CommonAttackLogic", "IS_DASHING")

local SwitchTargets = Mashina.Repeat {
	Mashina.ParallelTry {
		drop = false,

		Mashina.Check {
			condition = IS_DASHING
		},

		Mashina.Step {
			SwitchToOrlando,
			WaitOnTarget,

			SwitchToPlayer,
			WaitOnTarget
		}
	}
}

local ACCELERATION_MAGNITUDE = 24
local MAX_DISTANCE = 15

local CURRENT_DIRECTION = B.Reference("Tutorial_Keelhauler_CommonAttackLogic", "CURRENT_DIRECTION")
local CURRENT_ACCELERATION = B.Reference("Tutorial_Keelhauler_CommonAttackLogic", "CURRENT_ACCELERATION")

local CHARGE_DISTANCE_MOVED = B.Reference("Tutorial_Keelhauler_CommonAttackLogic", "CHARGE_DISTANCE_MOVED")
local CHARGE_HITS = B.Reference("Tutorial_Keelhauler_CommonAttackLogic", "CHARGE_HITS")
local CHARGE_HIT = B.Reference("Tutorial_Keelhauler_CommonAttackLogic", "CHARGE_HIT")

local CURRENT_POSITION = B.Reference("Tutorial_Keelhauler_CommonAttackLogic", "CURRENT_POSITION")
local PREVIOUS_POSITION = B.Reference("Tutorial_Keelhauler_CommonAttackLogic", "PREVIOUS_POSITION")

local BeginCharge = Mashina.Step {
	Mashina.Sequence {
		Mashina.Peep.HasCombatTarget,

		Mashina.Peep.HasCombatTarget {
			[CURRENT_TARGET] = B.Output.target
		}
	},

	Mashina.Set {
		value = true,
		[IS_DASHING] = B.Output.result,
	},

	Mashina.Set {
		value = Vector(math.huge),
		[PREVIOUS_POSITION] = B.Output.result
	},

	Mashina.Sequence {
		Mashina.Success {
			Mashina.Peep.DisengageCombatTarget,
		},

		Mashina.Step {
			Mashina.Navigation.Direction {
				target = CURRENT_TARGET,
				[CURRENT_DIRECTION] = B.Output.result
			},

			Mashina.Peep.PlayAnimation {
				animation = "Keelhauler_Charge",
				slot = "x-keelhauler-charge",
				priority = 500
			}
		}
	},

	Mashina.Peep.TimeOut {
		duration = 2
	}
}

local EndCharge = Mashina.Sequence {
	Mashina.Set {
		value = false,
		[IS_DASHING] = B.Output.result,
	},

	Mashina.Peep.PokeSelf {
		event = "dashEnd"
	},

	Mashina.Set {
		value = 0,
		[CHARGE_DISTANCE_MOVED] = B.Output.result
	},

	Mashina.Peep.StopAnimation {
		slot = "x-keelhauler-charge"
	},

	Mashina.Peep.StopAnimation {
		slot = "x-keelhauler-stun"
	},

	Mashina.Navigation.Move {
		acceleration = Vector.ZERO,
		velocity = Vector.ZERO
	}
}

local Stun = Mashina.Step {
	Mashina.Peep.PlayAnimation {
		animation = "Keelhauler_Stun",
		slot = "x-keelhauler-stun",
		priority = 500
	},

	Mashina.Peep.PokeSelf {
		event = "dashEnd"
	},

	Mashina.Repeat {
		Mashina.Navigation.Move {
			acceleration = Vector.ZERO,
			velocity = Vector.ZERO
		},

		Mashina.Success {
			Mashina.Peep.DisengageCombatTarget
		},

		Mashina.Invert {
			Mashina.Peep.TimeOut {
				duration = 4
			}
		}
	}
}

local Charge = Mashina.Step {
	Mashina.Peep.Event {
		peep = CURRENT_TARGET,
		event = "tutorialKeelhaulerCharge"
	},

	Mashina.Peep.TimeOut {
		duration = 2
	},

	Mashina.Peep.StopAnimation {
		slot = "x-keelhauler-charge"
	},

	Mashina.Peep.PokeSelf {
		event = "dashStart",
	},

	Mashina.Multiply {
		left = CURRENT_DIRECTION,
		right = ACCELERATION_MAGNITUDE,
		[CURRENT_ACCELERATION] = B.Output.result
	},

	Mashina.Repeat {
		Mashina.Navigation.Move {
			acceleration = CURRENT_ACCELERATION
		},

		Mashina.Success {
			Mashina.Peep.DisengageCombatTarget
		},

		Mashina.Navigation.DistanceMoved {
			[CHARGE_DISTANCE_MOVED] = B.Output.result
		},

		Mashina.Navigation.GetPosition {
			[CURRENT_POSITION] = B.Output.result,
		},

		Mashina.ParallelSequence {
			Mashina.Invert {
				Mashina.ParallelTry {
					Mashina.Sequence {
						Mashina.Compare.GreaterThanEqual {
							left = CHARGE_DISTANCE_MOVED,
							right = MAX_DISTANCE
						},

						Stun
					},

					Mashina.Step {
						Mashina.Compare.LessThan {
							left = CHARGE_DISTANCE_MOVED,
							right = MAX_DISTANCE
						},

						Mashina.Compare.Equal {
							left = CURRENT_POSITION,
							right = PREVIOUS_POSITION
						},

						Stun
					}
				}
			},

			Mashina.Step {
				Mashina.Peep.OnPoke {
					event = "dashHit",
					callback = function(_, _, _, _, peep)
						return peep
					end,
					[CHARGE_HITS] = B.Output.results
				},

				Mashina.Loop {
					items = CHARGE_HITS,

					Mashina.GetLoopResult {
						[CHARGE_HIT] = B.Output.result
					},

					Mashina.Peep.AttackWithXWeapon {
						target = CHARGE_HIT,
						x_weapon = "Keelhauler_Dash"
					}
				}
			},

			Mashina.Set {
				value = CURRENT_POSITION,
				[PREVIOUS_POSITION] = B.Output.result
			}
		}
	}
}

return {
	SwitchToWeakStyle = SwitchToWeakStyle,
	SwitchToStrongStyle = SwitchToStrongStyle,
	SwitchToOrlando = SwitchToOrlando,
	SwitchToPlayer = SwitchToPlayer,
	SwitchTargets = SwitchTargets,

	IS_DASHING = IS_DASHING,
	BeginCharge = BeginCharge,
	EndCharge = EndCharge,
	Charge = Charge
}
