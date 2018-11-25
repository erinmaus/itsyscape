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

			Output {
				Resource = ItsyScape.Resource.Item "FalteringHolyIncense",
			  Count = 1
			}
		}
	}

	local FalteringHolyIncenseBurnAction = ItsyScape.Action.Burn()
	FalteringHolyIncenseBurnAction {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForLevel(1),
		},

		Input {
			Resource = ItsyScape.Resource.Item "FalteringHolyIncense",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForResource(6)
		}
	}

	ItsyScape.Resource.Item "FalteringHolyIncense" {
		FalteringHolyIncenseBurnAction
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(6),
		Weight = 0,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "FalteringHolyIncense"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Faltering holy incense",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "FalteringHolyIncense"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Makes your heart swell with just a tiny bit of piety.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "FalteringHolyIncense"
	}

	ItsyScape.Meta.Enchantment {
		Effect = ItsyScape.Resource.Effect "WeakPrayerRestorationEffect",
		Action = FalteringHolyIncenseBurnAction
	}

	ItsyScape.Meta.ResourceName {
		Value = "Wispy Holy Smoke",
		Language = "en-US",
		Resource = ItsyScape.Resource.Effect "WeakPrayerRestorationEffect"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Restores 1% of prayer points every second.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Effect "WeakPrayerRestorationEffect"
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

			Output {
				Resource = ItsyScape.Resource.Item "FaintMelodicIncense",
			  Count = 1
			}
		}
	}

	ItsyScape.Resource.Item "FaintMelodicIncense" {
		-- Nothing.
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(8),
		Weight = 0,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "FaintMelodicIncense"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Faint melodic incense",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "FaintMelodicIncense"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Crackles to a beat when lit.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "FaintMelodicIncense"
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

			Output {
				Resource = ItsyScape.Resource.Item "DreadfulIncense",
			  Count = 1
			}
		}
	}

	local DreadfulIncenseBurnAction = ItsyScape.Action.Burn()
	DreadfulIncenseBurnAction {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForLevel(10),
		},

		Input {
			Resource = ItsyScape.Resource.Item "DreadfulIncense",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForResource(15)
		}
	}

	ItsyScape.Resource.Item "DreadfulIncense" {
		DreadfulIncenseBurnAction
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(15),
		Weight = 0,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "DreadfulIncense"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Dreadful incense",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "DreadfulIncense"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Smells like lavender. And evil.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "DreadfulIncense"
	}

	ItsyScape.Meta.Enchantment {
		Effect = ItsyScape.Resource.Effect "DreadfulIncenseAccuracyEffect",
		Action = DreadfulIncenseBurnAction
	}

	ItsyScape.Meta.ResourceName {
		Value = "Creeping Dread of the Eldritch",
		Language = "en-US",
		Resource = ItsyScape.Resource.Effect "DreadfulIncenseAccuracyEffect"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Increases self accuracy roll by 50% of target's defense roll and vice versa.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Effect "DreadfulIncenseAccuracyEffect"
	}
end
