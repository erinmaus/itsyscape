--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Ectoplasm.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Ectoplasm = ItsyScape.Resource.Item "Ectoplasm" {
		ItsyScape.Action.Bury() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Faith",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Ectoplasm",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Faith",
				Count = ItsyScape.Utility.xpForResource(6)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Ectoplasm",
		Language = "en-US",
		Resource = Ectoplasm
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The gooey signs of a ghost interacting with the physical world.",
		Language = "en-US",
		Resource = Ectoplasm
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(5),
		Weight = 5,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "Ectoplasm"
	}
end
