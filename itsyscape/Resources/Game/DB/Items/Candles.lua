--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Candles.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Wick = ItsyScape.Resource.Item "CottonCandleWick" {
		ItsyScape.Action.Craft() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "CottonCloth",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Item "CottonCandleWick",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForResource(12)
			}
		}
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Fiber",
		Value = "Cotton",
		Resource = Wick
	}

	ItsyScape.Meta.ResourceName {
		Value = "Cotton candle wick",
		Language = "en-US",
		Resource = Wick
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A candle wick made from cotton.",
		Language = "en-US",
		Resource = Wick
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(12),
		Weight = 0,
		Stackable = 1,
		Resource = Wick
	}
end

do
	local Blubber = ItsyScape.Resource.Item "YendorianWhaleBlubber"

	local CraftAction = ItsyScape.Action.OpenInventoryCraftWindow()

	ItsyScape.Meta.ActionVerb {
		Value = "Craft",
		XProgressive = "Crafting",
		Language = "en-US",
		Action = CraftAction
	}

	ItsyScape.Meta.DelegatedActionTarget {
		CategoryKey = "Fat",
		ActionType = "Craft",
		Action = CraftAction
	}

	Blubber {
		CraftAction
	}

	ItsyScape.Meta.ResourceName {
		Value = "Yendorian whale blubber",
		Language = "en-US",
		Resource = Blubber
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A block of whale blubber from from an undead whale. Useful in making kurses.",
		Language = "en-US",
		Resource = Blubber
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(10),
		Resource = Blubber
	}
end

do
	local UnlitKursedCandle = ItsyScape.Resource.Item "UnlitKursedCandle" {
		ItsyScape.Action.Craft() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Firemaking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "YendorianWhaleBlubber",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "CottonCandleWick",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Item "UnlitKursedCandle",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Firemaking",
				Count = ItsyScape.Utility.xpForResource(15)
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForResource(15)
			}
		}
	}

	local LitKursedCandle = ItsyScape.Resource.Item "LitKursedCandle"

	local LightAction = ItsyScape.Action.Burn() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Input {
			Resource = UnlitKursedCandle,
			Count = 1
		},

		Output {
			Resource = LitKursedCandle,
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForResource(10)
		}
	}

	UnlitKursedCandle {
		LightAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Light",
		XProgressive = "Lighting",
		Language = "en-US",
		Action = LightAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Fat",
		Value = "Candle",
		Resource = UnlitKursedCandle
	}

	ItsyScape.Meta.ResourceName {
		Value = "Unlit kursed candle",
		Language = "en-US",
		Resource = UnlitKursedCandle
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A candle that causes a deadly kurse. Needs to be lit to be effective.",
		Language = "en-US",
		Resource = UnlitKursedCandle
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(15),
		Resource = UnlitKursedCandle
	}

	ItsyScape.Meta.ResourceName {
		Value = "Lit kursed candle",
		Language = "en-US",
		Resource = LitKursedCandle
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A lit candle that causes a deadly kurse.",
		Language = "en-US",
		Resource = LitKursedCandle
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(16),
		Resource = LitKursedCandle
	}
end
