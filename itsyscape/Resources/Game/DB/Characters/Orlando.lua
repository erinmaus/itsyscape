--------------------------------------------------------------------------------
-- Resources/Game/DB/Characters/Orlando.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Character = ItsyScape.Resource.Character "Orlando"

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Ser Orlando",
	Resource = Character
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Knighted on the behest of his sister and Vizier-King Yohn's friend, Lady Isabelle. Ser Orlando is a hopeless romantic that never waivers from the ideals of knighthood.",
	Resource = Character
}

ItsyScape.Meta.CharacterTeam {
	Character = Character,
	Team = ItsyScape.Resource.Team "Humanity"
}

local Orlando = ItsyScape.Resource.Peep "Orlando" {
	ItsyScape.Action.InvisibleAttack()
}

ItsyScape.Meta.PeepCharacter {
	Peep = Orlando,
	Character = Character
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Orlando.Orlando",
	Resource = Orlando
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Ser Orlando",
	Resource = Orlando
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Hopeless romantic.",
	Resource = Orlando
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "IsabelliumGloves",
	Count = 1,
	Resource = Orlando
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "IsabelliumBoots",
	Count = 1,
	Resource = Orlando
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "IsabelliumPlatebody",
	Count = 1,
	Resource = Orlando
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "IsabelliumZweihander",
	Count = 1,
	Resource = Orlando
}

ItsyScape.Meta.PeepHealth {
	Hitpoints = 99,
	Resource = Orlando
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(60),
	Resource = Orlando
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(60),
	Resource = Orlando
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Archery",
	Value = ItsyScape.Utility.xpForLevel(60),
	Resource = Orlando
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Dexterity",
	Value = ItsyScape.Utility.xpForLevel(60),
	Resource = Orlando
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(60),
	Resource = Orlando
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Faith",
	Value = ItsyScape.Utility.xpForLevel(60),
	Resource = Orlando
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Magic",
	Value = ItsyScape.Utility.xpForLevel(60),
	Resource = Orlando
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Wisdom",
	Value = ItsyScape.Utility.xpForLevel(60),
	Resource = Orlando
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Fishing",
	Value = ItsyScape.Utility.xpForLevel(60),
	Resource = Orlando
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Cooking",
	Value = ItsyScape.Utility.xpForLevel(60),
	Resource = Orlando
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Woodcutting",
	Value = ItsyScape.Utility.xpForLevel(60),
	Resource = Orlando
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Firemaking",
	Value = ItsyScape.Utility.xpForLevel(60),
	Resource = Orlando
}

local AttackableOrlando = ItsyScape.Resource.Peep "Orlando_Attackable" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Ser Orlando",
	Resource = AttackableOrlando
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Hopeless romantic.",
	Resource = AttackableOrlando
}

ItsyScape.Meta.PeepCharacter {
	Peep = AttackableOrlando,
	Character = Character
}
