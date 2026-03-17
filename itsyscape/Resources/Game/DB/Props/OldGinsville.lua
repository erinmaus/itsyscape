--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/OldGinsville.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Pew = ItsyScape.Resource.Prop "Pew_OldGinsville1"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.FurnitureProp",
		Resource = Pew
	}

	ItsyScape.Meta.ResourceName {
		Value = "Pew",
		Language = "en-US",
		Resource = Pew
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Hasn't been used in a while, you know, given that everyone in Old Ginsville was slaughtered.",
		Language = "en-US",
		Resource = Pew
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 4.5,
		SizeY = 3,
		SizeZ = 1.5,
		MapObject = Pew
	}
end
