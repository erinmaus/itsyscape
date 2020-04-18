--------------------------------------------------------------------------------
-- Resources/Game/DB/Sailing/Crew.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.KeyItem "Message_Sailing_LastDestinationNotPort" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Sailing message",
	Language = "en-US",
	Resource = ItsyScape.Resource.KeyItem "Message_Sailing_LastDestinationNotPort"
}

ItsyScape.Meta.ResourceDescription {
	Value = "The last destination must be a port.",
	Language = "en-US",
	Resource = ItsyScape.Resource.KeyItem "Message_Sailing_LastDestinationNotPort"
}

ItsyScape.Resource.KeyItem "Message_Sailing_IsDone" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Sailing message",
	Language = "en-US",
	Resource = ItsyScape.Resource.KeyItem "Message_Sailing_IsDone"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Since the last destination is a port, no more destinations can be added.",
	Language = "en-US",
	Resource = ItsyScape.Resource.KeyItem "Message_Sailing_IsDone"
}

ItsyScape.Resource.KeyItem "Message_Sailing_SameDestination" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Sailing message",
	Language = "en-US",
	Resource = ItsyScape.Resource.KeyItem "Message_Sailing_SameDestination"
}

ItsyScape.Meta.ResourceDescription {
	Value = "You're already sailing to that destination.",
	Language = "en-US",
	Resource = ItsyScape.Resource.KeyItem "Message_Sailing_SameDestination"
}

ItsyScape.Resource.KeyItem "Message_Sailing_DistanceTooFar" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Sailing message",
	Language = "en-US",
	Resource = ItsyScape.Resource.KeyItem "Message_Sailing_DistanceTooFar"
}

ItsyScape.Meta.ResourceDescription {
	Value = "The distance between destinations is too far.",
	Language = "en-US",
	Resource = ItsyScape.Resource.KeyItem "Message_Sailing_DistanceTooFar"
}
