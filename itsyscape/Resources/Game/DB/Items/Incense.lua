--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Incense.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

-- Common incenses
do
	local CommonLogs = ItsyScape.Resource.Item "CommonLogs"

	CommonLogs {
		ItsyScape.Action.Craft() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Firemaking",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Input {
				Resource = ItsyScape.Resource.Item "WeakGum",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "FalteringFrankincense",
				Count = 5
			},

			Input {
				Resource = ItsyScape.Resource.Item "CommonLogs",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Firemaking",
				Count = ItsyScape.Utility.xpForResource(1) / 10
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForResource(1)
			},

			--Output {
			--	Resource = ItsyScape.Resource.Item "FalteringHolyIncense",
			--  Count = 1
			--}

			Output {
				Resource = ItsyScape.Resource.Item "CommonLogs",
				Count = 1
			}
		}
	}

	CommonLogs {
		ItsyScape.Action.Craft() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForLevel(5)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Firemaking",
				Count = ItsyScape.Utility.xpForLevel(5)
			},

			Input {
				Resource = ItsyScape.Resource.Item "WeakGum",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "FaintEasternBalsam",
				Count = 5
			},

			Input {
				Resource = ItsyScape.Resource.Item "CommonLogs",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Firemaking",
				Count = ItsyScape.Utility.xpForResource(5) / 10
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForResource(5)
			},

			--Output {
			--	Resource = ItsyScape.Resource.Item "FaintMelodicIncense",
			--  Count = 1
			--}

			Output {
				Resource = ItsyScape.Resource.Item "CommonLogs",
				Count = 1
			}
		}
	}

	CommonLogs {
		ItsyScape.Action.Craft() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Firemaking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "WeakGum",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "EldritchMyrrh",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "CommonLogs",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Firemaking",
				Count = ItsyScape.Utility.xpForResource(10) / 10
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForResource(10)
			},

			--Output {
			--	Resource = ItsyScape.Resource.Item "DreadfulIncense",
			--  Count = 1
			--}

			Output {
				Resource = ItsyScape.Resource.Item "CommonLogs",
				Count = 1
			}
		}
	}
end