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
local Weapon = require "ItsyScape.Game.Weapon"
local Mashina = require "ItsyScape.Mashina"
local CommonLogic = require "Resources.Game.Maps.Sailing_HumanityEdge.Scripts.Tutorial_CommonLogic"

local CURRENT_TARGET = B.Reference("Tutorial_Keelhauler_CommonAttackLogic", "CURRENT_TARGET")

local Roar = Mashina.Step {
	Mashina.Peep.PlayAnimation {
		animation = "Keelhauler_Summon" -- TODO ROAR
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
				Mashina.HasCombatTarget,

				Mashina.HasCombatTarget {
					[CURRENT_TARGET] = B.Output.result
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

local WaitOnTarget = Mashina.Repeat {
	Mashina.Step {
		Mashina.Peep.DidAttack,
		Mashina.Peep.DidAttack,

		Mashina.Invert {
			Mashina.RandomCheck {
				chance = 1 / 3
			}
		}
	}
}

local SwitchTargets = Mashina.Repeat {
	Mashina.Step {
		SwitchToOrlando,
		WaitOnTarget,

		SwitchToPlayer,
		WaitOnTarget
	}
}

return {
	SwitchToWeakStyle = SwitchToWeakStyle,
	SwitchToStrongStyle = SwitchToStrongStyle,
	SwitchTargets = SwitchTargets
}
