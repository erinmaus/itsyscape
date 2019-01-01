--------------------------------------------------------------------------------
-- Resources/Game/DB/KeyItems.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.KeyItem "Message_GuardianDoorLocked" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Guardian Door (locked)",
	Language = "en-US",
	Resource = ItsyScape.Resource.KeyItem "Message_GuardianDoorLocked"
}

ItsyScape.Meta.ResourceDescription {
	Value = "All creeps in the room must be slain before the door will open.",
	Language = "en-US",
	Resource = ItsyScape.Resource.KeyItem "Message_GuardianDoorLocked"
}
