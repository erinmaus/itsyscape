--------------------------------------------------------------------------------
-- Resources/Game/DB/Quest/Tutorial/Dummies.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Dummy = ItsyScape.Resource.Peep "TutorialDummy_Wizard" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "ItsyScape.Peep.Peeps.Player",
		Resource = Dummy
	}

	ItsyScape.Meta.ResourceName {
		Value = "Dummy wizard",
		Language = "en-US",
		Resource = Dummy
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Orlando's convenient dummy that can cast spells.",
		Language = "en-US",
		Resource = Dummy
	}

	ItsyScape.Meta.Dummy {
		Tier = 50,
		CombatStyle = ItsyScape.Utility.Weapon.STYLE_MAGIC,
		Hitpoints = 50,

		ChaseDistance = math.huge,

		Weapon = "IsabelliumStaff",

		Resource = Dummy
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Magic",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = Dummy
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Wisdom",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = Dummy
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = Dummy
	}
end

do
	local Dummy = ItsyScape.Resource.Peep "TutorialDummy_Warrior" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "ItsyScape.Peep.Peeps.Player",
		Resource = Dummy
	}

	ItsyScape.Meta.ResourceName {
		Value = "Dummy warrior",
		Language = "en-US",
		Resource = Dummy
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Orlando's convenient dummy that can slash a sword.",
		Language = "en-US",
		Resource = Dummy
	}

	ItsyScape.Meta.Dummy {
		Tier = 50,
		CombatStyle = ItsyScape.Utility.Weapon.STYLE_MELEE,
		Hitpoints = 50,

		ChaseDistance = math.huge,

		Weapon = "IsabelliumZweihander",

		Resource = Dummy
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = Dummy
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = Dummy
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = Dummy
	}
end

do
	local Dummy = ItsyScape.Resource.Peep "TutorialDummy_Archer" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "ItsyScape.Peep.Peeps.Player",
		Resource = Dummy
	}

	ItsyScape.Meta.ResourceName {
		Value = "Dummy archer",
		Language = "en-US",
		Resource = Dummy
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Orlando's convenient dummy that can shoot arrows.",
		Language = "en-US",
		Resource = Dummy
	}

	ItsyScape.Meta.Dummy {
		Tier = 50,
		CombatStyle = ItsyScape.Utility.Weapon.STYLE_ARCHERY,
		Hitpoints = 50,

		ChaseDistance = math.huge,

		Weapon = "IsabelliumLongbow",

		Resource = Dummy
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Archery",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = Dummy
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = Dummy
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = Dummy
	}
end

local DUMMIES = {
	"TutorialDummy_Wizard",
	"TutorialDummy_Warrior",
	"TutorialDummy_Archer"
}

local STATES = {
	{ name = "tutorial-yield", filename = "Tutorial_Dummy_YieldLogic" },
	{ name = "tutorial-eat", filename = "Tutorial_Dummy_EatLogic" },
	{ name = "tutorial-rites", filename = "Tutorial_Dummy_RiteLogic" },
	{ name = "tutorial-deflect", filename = "Tutorial_Dummy_DeflectLogic" },
}

for _, dummy in ipairs(DUMMIES) do
	ItsyScape.Meta.PeepCharacter {
		Peep = ItsyScape.Resource.Peep(dummy),
		Character = ItsyScape.Resource.Character "Dummy"
	}

	for _, state in ipairs(STATES) do
		ItsyScape.Meta.PeepMashinaState {
			State = state.name,
			Tree = string.format("Resources/Game/Maps/Sailing_HumanityEdge/Scripts/%s.lua", state.filename),
			Resource = ItsyScape.Resource.Peep(dummy)
		}
	end
end
