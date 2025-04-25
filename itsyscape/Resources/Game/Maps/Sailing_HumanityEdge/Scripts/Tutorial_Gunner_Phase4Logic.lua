--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Gunner_Phase3Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local BTreeBuilder = require "B.TreeBuilder"
local Class = require "ItsyScape.Common.Class"
local Mashina = require "ItsyScape.Mashina"
local Probe = require "ItsyScape.Peep.Probe"
local ICannon = require "ItsyScape.Game.Skills.ICannon"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"
local CommonLogic = require "Resources.Game.Maps.Sailing_HumanityEdge.Scripts.Tutorial_CommonLogic"

local TARGET = B.Reference("Tutorial_Gunner_Phase3Logic", "TARGET")
local CANNON = B.Reference("Tutorial_Gunner_Phase3Logic", "CANNON")

local Intro = Mashina.Step {
	CommonLogic.GetOrlando,

	Mashina.Peep.FindNearbyPeep {
		filter = function(p)
			return Class.hasInterface(p, ICannon)
		end,

		[CANNON] = B.Output.result
	},

	Mashina.Sailing.AimCannon {
		target = CommonLogic.ORLANDO,
		cannon = CANNON
	},

	Mashina.Repeat {
		Mashina.Sailing.AimCannon {
			target = TARGET,
			cannon = CANNON,
			steady = true
		},

		Mashina.Invert {
			Mashina.Peep.TimeOut {
				duration = 2
			}
		}
	},

	Mashina.Player.Disable {
		player = CommonLogic.PLAYER,
	},
	
	Mashina.Sequence {
		CommonLogic.GetPlayer,

		Mashina.Success {
			Mashina.Sailing.AimCannon {
				target = TARGET,
				cannon = CANNON,
				steady = true
			}
		},

		Mashina.Try {
			Mashina.Step {
				Mashina.Player.IsInterfaceOpen {
					interface = "DialogBox",
					player = CommonLogic.PLAYER
				},

				Mashina.Repeat {
					Mashina.Player.IsInterfaceOpen {
						interface = "DialogBox",
						player = CommonLogic.PLAYER
					}
				}
			},

			Mashina.Player.Dialog {
				peep = CommonLogic.ORLANDO,
				player = CommonLogic.PLAYER,
				main = "quest_tutorial_fight_keelhauler.dodge_cannon"
			}
		}
	},

	Mashina.Player.Enable {
		player = CommonLogic.PLAYER,
	},

	Mashina.Peep.Event {
		peep = CommonLogic.ORLANDO,
		event = "tutorialGunnerAimCannon"
	},

	Mashina.Peep.TimeOut {
		duration = 1,
	},

	Mashina.Sailing.FireCannon {
		cannon = CANNON
	}
}

local GetTarget = Mashina.RandomTry {
	Mashina.Sequence {
		CommonLogic.GetOrlando,

		Mashina.Set {
			value = CommonLogic.ORLANDO,
			[TARGET] = B.Output.result
		}
	},

	Mashina.Sequence {
		CommonLogic.GetPlayer,

		Mashina.Set {
			value = CommonLogic.PLAYER,
			[TARGET] = B.Output.result
		}
	}
}

local FireCannon = Mashina.Step {
	GetTarget,

	Mashina.Peep.FindNearbyPeep {
		filter = function(p)
			return Class.hasInterface(p, ICannon)
		end,

		[CANNON] = B.Output.result
	},

	Mashina.Drop {
		Mashina.Step {
			Mashina.Sailing.AimCannon {
				target = TARGET,
				cannon = CANNON
			},

			Mashina.Repeat {
				Mashina.Sailing.AimCannon {
					target = TARGET,
					cannon = CANNON,
					steady = true
				},

				Mashina.Invert {
					Mashina.Peep.TimeOut {
						duration = 2
					}
				}
			},

			Mashina.Peep.Event {
				peep = TARGET,
				event = "tutorialGunnerAimCannon"
			},

			Mashina.Sailing.FireCannon {
				cannon = CANNON
			},

			Mashina.Peep.TimeOut {
				duration = 3,
			}
		}
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Drop {
			Intro
		},

		Mashina.Peep.TimeOut {
			min_duration = 15,
			max_duration = 20
		},

		Mashina.Repeat {
			Mashina.Step {
				Mashina.Success {
					FireCannon
				},

				Mashina.Peep.TimeOut {
					min_duration = 15,
					max_duration = 20
				}
			}
		}
	}
}

return Tree
