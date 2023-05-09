--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/SewerSpider.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local SewerSpider = ItsyScape.Resource.Peep "SewerSpider"

	ItsyScape.Resource.Peep "SewerSpider" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Arachnid.SewerSpider",
		Resource = SewerSpider
	}

	ItsyScape.Meta.ResourceName {
		Value = "Sewer spider",
		Language = "en-US",
		Resource = SewerSpider
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Lurks in damp sewers, waiting for a rat to wander too close.",
		Language = "en-US",
		Resource = SewerSpider
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/Arachnid/SewerSpider_IdleLogic.lua",
		IsDefault = 1,
		Resource = SewerSpider
	}
end

do
	local SewerSpiderMatriarch = ItsyScape.Resource.Peep "SewerSpiderMatriarch"

	ItsyScape.Resource.Peep "SewerSpiderMatriarch" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Arachnid.SewerSpiderMatriarch",
		Resource = SewerSpiderMatriarch
	}

	ItsyScape.Meta.ResourceName {
		Value = "Sewer spider matriarch",
		Language = "en-US",
		Resource = SewerSpiderMatriarch
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "An armored spider?!",
		Language = "en-US",
		Resource = SewerSpiderMatriarch
	}
end
