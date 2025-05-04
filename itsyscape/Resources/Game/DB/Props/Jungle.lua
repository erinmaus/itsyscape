--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Jungle.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	ItsyScape.Resource.Prop "JungleFern1" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.PassableProp",
		Resource = ItsyScape.Resource.Prop "JungleFern1"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Jungle fern",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "JungleFern1"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A healthy fern of the jugnle",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "JungleFern1"
	}
end
