--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/MagmaJellyfish.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "MagmaJellyfish" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Jellyfish.MagmaJellyfish",
	Resource = ItsyScape.Resource.Peep "MagmaJellyfish"
}

ItsyScape.Meta.ResourceName {
	Value = "Magma jellyfish",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "MagmaJellyfish"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A fierce, tentacled horror... Don't step under it!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "MagmaJellyfish"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Magic",
	Value = ItsyScape.Utility.xpForLevel(200),
	Resource = ItsyScape.Resource.Peep "MagmaJellyfish"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Wisdom",
	Value = ItsyScape.Utility.xpForLevel(200),
	Resource = ItsyScape.Resource.Peep "MagmaJellyfish"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(20),
	Resource = ItsyScape.Resource.Peep "MagmaJellyfish"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(1000),
	Resource = ItsyScape.Resource.Peep "MagmaJellyfish"
}

ItsyScape.Meta.Equipment {
	AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(60, 1),
	StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(150),
	Resource = ItsyScape.Resource.Peep "MagmaJellyfish"
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/Jellyfish/MagmaJellyfish_IdleLogic.lua",
	IsDefault = 1,
	Resource = ItsyScape.Resource.Peep "MagmaJellyfish"
}

ItsyScape.Resource.Prop "MagmaJellyfishRock" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Jellyfish.MagmaJellyfishRock",
	Resource = ItsyScape.Resource.Prop "MagmaJellyfishRock"
}
