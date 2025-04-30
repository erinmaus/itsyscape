--------------------------------------------------------------------------------
-- Resources/Game/DB/Characters/Rosalind.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Character = ItsyScape.Resource.Character "Rosalind"

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Rosalind",
	Resource = Character
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "A talented young witch, specializing in shapeshifting. Her faith in The Empty King is strong. She has a strong moral compass.",
	Resource = Character
}

ItsyScape.Meta.CharacterTeam {
	Character = Character,
	Team = ItsyScape.Resource.Team "Humanity"
}

ItsyScape.Meta.CharacterTeam {
	Character = Character,
	Team = ItsyScape.Resource.Team "Heroes"
}

local Rosalind = ItsyScape.Resource.Peep "Rosalind" {
	ItsyScape.Action.InvisibleAttack()
}

ItsyScape.Meta.PeepCharacter {
	Peep = Rosalind,
	Character = Character
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Rosalind.Rosalind",
	Resource = Rosalind
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Rosalind",
	Resource = Rosalind
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "A talented young witch with a knack for shapeshifting.",
	Resource = Rosalind
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "IsabelliumStaff",
	Count = 1,
	Resource = Rosalind
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "LitBullseyeLantern",
	Count = 1,
	Resource = Rosalind
}

ItsyScape.Meta.PeepHealth {
	Hitpoints = 99,
	Resource = Rosalind
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = Rosalind
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = Rosalind
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Faith",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = Rosalind
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Magic",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = Rosalind
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Wisdom",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = Rosalind
}
