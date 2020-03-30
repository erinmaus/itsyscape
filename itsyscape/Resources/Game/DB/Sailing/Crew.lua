--------------------------------------------------------------------------------
-- Resources/Game/DB/Sailing/Crew.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local GENERAL_HUMAN_NAMES = {
	["male"] = {
		"Aiden",
		"Alexander",
		"Andrew",
		"Anthony",
		"Asher",
		"Benjamin",
		"Caleb",
		"Carter",
		"Christopher",
		"Daniel",
		"David",
		"Dylan",
		"Elijah",
		"Ethan",
		"Gabriel",
		"Grayson",
		"Henry",
		"Isaac",
		"Jack",
		"Jackson",
		"Jacob",
		"James",
		"Jaxon",
		"Jayden",
		"John",
		"Joseph",
		"Joshua",
		"Julian",
		"Leo",
		"Levi",
		"Liam",
		"Lincoln",
		"Logan",
		"Lucas",
		"Luke",
		"Mason",
		"Mateo",
		"Matthew",
		"Michael",
		"Nathan",
		"Noah",
		"Oliver",
		"Owen",
		"Ryan",
		"Samuel",
		"Sebastian",
		"Theodore",
		"Thomas",
		"William",
		"Wyatt",
	},

	["female"] = {
		"Abigail",
		"Addison",
		"Amelia",
		"Aria",
		"Aubrey",
		"Audrey",
		"Aurora",
		"Ava",
		"Avery",
		"Bella",
		"Brooklyn",
		"Camila",
		"Charlotte",
		"Chloe",
		"Claire",
		"Eleanor",
		"Elizabeth",
		"Ella",
		"Ellie",
		"Emily",
		"Emma",
		"Evelyn",
		"Grace",
		"Hannah",
		"Harper",
		"Hazel",
		"Isabella",
		"Layla",
		"Leah",
		"Lillian",
		"Lily",
		"Luna",
		"Madison",
		"Mia",
		"Mila",
		"Natalie",
		"Nora",
		"Olivia",
		"Penelope",
		"Riley",
		"Sarah",
		"Savannah",
		"Scarlett",
		"Skylar",
		"Sofia",
		"Sophia",
		"Stella",
		"Victoria",
		"Violet",
		"Zoe",
		"Zoey",
	},

	["x"] = {
		"Addison",
		"Adrian",
		"Aiden",
		"Alex",
		"Alys",
		"Bryn",
		"Erin",
		"Grey",
		"Jackie",
		"Jude",
		"Morgan",
		"Ozzy",
		"Potato",
		"Robin",
		"Rock",
		"Skye",
		"Tea",
		"Theo",
		"Wren",
		"X",
		"Y",
		"Z",
		"Zoo",
	}
}

local function nameSailor(list, resource)
	for gender, names in pairs(list) do
		for i = 1, #names do
			local name = names[i]

			ItsyScape.Meta.SailingCrewName {
				Value = name,
				Gender = gender,
				Resource = resource
			}
		end
	end
end

do
	local Landlubber = ItsyScape.Resource.SailingCrew "Landlubber" {
		ItsyScape.Action.SailingBuy() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Coins",
				Count = 1000
			}
		}
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Peeps/Sailors/Landlubber_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	Landlubber {
		TalkAction
	}

	ItsyScape.Meta.ResourceName {
		Value = "Landlubber",
		Language = "en-US",
		Resource = Landlubber
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Doesn't know port from starboard.",
		Language = "en-US",
		Resource = Landlubber
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Species",
		Value = "Human",
		Resource = Landlubber
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "SailingRole",
		Value = "Crew",
		Resource = Landlubber
	}

	ItsyScape.Meta.PeepBody {
		Type = "ItsyScape.Game.Body",
		Filename = "Resources/Game/Bodies/Human.lskel",
		Resource = Landlubber
	}

	ItsyScape.Meta.SailingCrewClass {
		Value = ItsyScape.Utility.Weapon.STYLE_NONE,
		Resource = Landlubber
	}

	-- Names
	do
		nameSailor(GENERAL_HUMAN_NAMES, Landlubber)
	end

	-- Head
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Head/Light.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Head/Medium.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Head/Dark.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Head/Minifig.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Landlubber
		}
	end

	-- Hair
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Afro.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Bald.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Emo.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Enby.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Fade.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/ForwardSpike.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/ForwardSwirl.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/LongCurve.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Pixie.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/SlickPokey.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Landlubber
		}
	end

	-- Eyes
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes.lua",
			Priority = math.huge,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Black.lua",
			Priority = math.huge,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Brown.lua",
			Priority = math.huge,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Grey.lua",
			Priority = math.huge,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Landlubber
		}
	end

	-- Body
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shirts/Blue.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shirts/Green.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shirts/Red.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shirts/Yellow.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
			Resource = Landlubber
		}
	end

	-- Feet
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots1.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots1_Black.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots2.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots3.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots3_Red.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/LongBoots1.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Landlubber
		}
	end

	-- Hands
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/BlackGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/BlueGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/GoldGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/GreenGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/RedGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Landlubber
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/SailorBlueGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Landlubber
		}
	end
end

do
	local Navigator = ItsyScape.Resource.SailingCrew "Navigator" {
		ItsyScape.Action.SailingBuy() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Coins",
				Count = 25000
			}
		}
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Peeps/Sailors/Navigator_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	Navigator {
		TalkAction
	}

	ItsyScape.Meta.ResourceName {
		Value = "Navigator",
		Language = "en-US",
		Resource = Navigator
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Uses navigation magics to plot courses and kick asses.",
		Language = "en-US",
		Resource = Navigator
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Species",
		Value = "Human",
		Resource = Navigator
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "SailingRole",
		Value = "Crew",
		Resource = Navigator
	}

	ItsyScape.Meta.PeepBody {
		Type = "ItsyScape.Game.Body",
		Filename = "Resources/Game/Bodies/Human.lskel",
		Resource = Navigator
	}

	ItsyScape.Meta.SailingCrewClass {
		Value = ItsyScape.Utility.Weapon.STYLE_MAGIC,
		Resource = Navigator
	}

	-- Names
	do
		nameSailor(GENERAL_HUMAN_NAMES, Navigator)
	end

	-- Head
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Head/Medium.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Navigator
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Head/Dark.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Navigator
		}
	end

	-- Hair
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Afro.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Navigator
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Emo.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Navigator
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Enby.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Navigator
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Fade.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Navigator
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/ForwardSpike.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Navigator
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/ForwardSwirl.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Navigator
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Pixie.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Navigator
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/SlickPokey.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Navigator
		}
	end

	-- Eyes
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Black.lua",
			Priority = math.huge,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Navigator
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Brown.lua",
			Priority = math.huge,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Navigator
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Grey.lua",
			Priority = math.huge,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Navigator
		}
	end

	-- Body
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shirts/Navigator_Blue.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
			Resource = Navigator
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shirts/Navigator_Green.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
			Resource = Navigator
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shirts/Navigator_Red.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
			Resource = Navigator
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shirts/Navigator_Purple.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
			Resource = Navigator
		}
	end

	-- Feet
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots1.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Navigator
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots1_Black.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Navigator
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots2.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Navigator
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots3.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Navigator
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots3_Red.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Navigator
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/LongBoots1.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Navigator
		}
	end

	-- Hands
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/BlackGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Navigator
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/BlueGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Navigator
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/GoldGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Navigator
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/GreenGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Navigator
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/RedGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Navigator
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/PurpleGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Navigator
		}
	end
end

do
	local Cannoneer = ItsyScape.Resource.SailingCrew "Cannoneer" {
		ItsyScape.Action.SailingBuy() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Coins",
				Count = 25000
			}
		}
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Peeps/Sailors/Cannoneer_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	Cannoneer {
		TalkAction
	}

	ItsyScape.Meta.ResourceName {
		Value = "Cannoneer",
		Language = "en-US",
		Resource = Cannoneer
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Can use a cannon or blunderbuss with incredible skill.",
		Language = "en-US",
		Resource = Cannoneer
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Species",
		Value = "Human",
		Resource = Cannoneer
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "SailingRole",
		Value = "Crew",
		Resource = Cannoneer
	}

	ItsyScape.Meta.PeepBody {
		Type = "ItsyScape.Game.Body",
		Filename = "Resources/Game/Bodies/Human.lskel",
		Resource = Cannoneer
	}

	ItsyScape.Meta.SailingCrewClass {
		Value = ItsyScape.Utility.Weapon.STYLE_ARCHERY,
		Resource = Cannoneer
	}

	-- Names
	do
		nameSailor(GENERAL_HUMAN_NAMES, Cannoneer)
	end

	-- Head
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Head/Light.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Head/Medium.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Head/Dark.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Head/Minifig.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Cannoneer
		}
	end

	-- Hair
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Afro.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Emo.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Enby.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Fade.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/ForwardSpike.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/ForwardSwirl.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Pixie.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/SlickPokey.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Cannoneer
		}
	end

	-- Eyes
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Black.lua",
			Priority = math.huge,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Brown.lua",
			Priority = math.huge,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Grey.lua",
			Priority = math.huge,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Red.lua",
			Priority = math.huge,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Cannoneer
		}
	end

	-- Body
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shirts/Cannoneer_Blue.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shirts/Cannoneer_Green.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shirts/Cannoneer_Orange.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shirts/Cannoneer_Purple.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
			Resource = Cannoneer
		}
	end

	-- Feet
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots1.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots1_Black.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots2.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots3.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots3_Red.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/LongBoots1.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Cannoneer
		}
	end

	-- Hands
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/BlackGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/BlueGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/GoldGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/GreenGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/RedGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Cannoneer
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/PurpleGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Cannoneer
		}
	end
end


do
	local Scallywag = ItsyScape.Resource.SailingCrew "Scallywag" {
		ItsyScape.Action.SailingBuy() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Coins",
				Count = 25000
			}
		}
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Peeps/Sailors/Scallywag_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	Scallywag {
		TalkAction
	}

	ItsyScape.Meta.ResourceName {
		Value = "Scallywag",
		Language = "en-US",
		Resource = Scallywag
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Brawls like no one's business. Also might have a drinking problem...",
		Language = "en-US",
		Resource = Scallywag
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Species",
		Value = "Human",
		Resource = Scallywag
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "SailingRole",
		Value = "Crew",
		Resource = Scallywag
	}

	ItsyScape.Meta.PeepBody {
		Type = "ItsyScape.Game.Body",
		Filename = "Resources/Game/Bodies/Human.lskel",
		Resource = Scallywag
	}

	ItsyScape.Meta.SailingCrewClass {
		Value = ItsyScape.Utility.Weapon.STYLE_ARCHERY,
		Resource = Scallywag
	}

	-- Names
	do
		nameSailor(GENERAL_HUMAN_NAMES, Scallywag)
	end

	-- Head
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Head/Minifig.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Scallywag
		}
	end

	-- Hair
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Afro.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Scallywag
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Emo.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Scallywag
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Enby.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Scallywag
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/ForwardSpike.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Scallywag
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Pixie.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Scallywag
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/SlickPokey.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Scallywag
		}
	end

	-- Eyes
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Grey.lua",
			Priority = math.huge,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Scallywag
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes.lua",
			Priority = math.huge,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Scallywag
		}
	end

	-- Body
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shirts/Scallywag_Blue.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
			Resource = Scallywag
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shirts/Scallywag_Yellow.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
			Resource = Scallywag
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shirts/Scallywag_Pink.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
			Resource = Scallywag
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shirts/Scallywag_Purple.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
			Resource = Scallywag
		}
	end

	-- Feet
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots1.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Scallywag
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots1_Black.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Scallywag
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots2.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Scallywag
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots3.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Scallywag
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots3_Red.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Scallywag
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/LongBoots1.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Scallywag
		}
	end

	-- Hands
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/BlackGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Scallywag
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/Minifig.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Scallywag
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/BlueGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Scallywag
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/GoldGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Scallywag
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/GreenGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Scallywag
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/RedGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Scallywag
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/PurpleGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Scallywag
		}
	end
end

do
	local Pirate = ItsyScape.Resource.SailingCrew "Pirate" {
		ItsyScape.Action.SailingBuy() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = ItsyScape.Utility.xpForLevel(15)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Coins",
				Count = 50000
			}
		}
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Peeps/Sailors/Pirate_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	Pirate {
		TalkAction
	}

	ItsyScape.Meta.ResourceName {
		Value = "Pirate",
		Language = "en-US",
		Resource = Pirate
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Swashbucklin' without regard to morals.",
		Language = "en-US",
		Resource = Pirate
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Species",
		Value = "Human",
		Resource = Pirate
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "SailingRole",
		Value = "Crew",
		Resource = Pirate
	}

	ItsyScape.Meta.PeepBody {
		Type = "ItsyScape.Game.Body",
		Filename = "Resources/Game/Bodies/Human.lskel",
		Resource = Pirate
	}

	ItsyScape.Meta.SailingCrewClass {
		Value = ItsyScape.Utility.Weapon.STYLE_ARCHERY,
		Resource = Pirate
	}

	ItsyScape.Meta.SailingCrewClass {
		Value = ItsyScape.Utility.Weapon.STYLE_MELEE,
		Resource = Pirate
	}

	-- Names
	do
		nameSailor(GENERAL_HUMAN_NAMES, Pirate)
	end

	-- Head
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Head/Medium.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Pirate
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Head/Dark.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Pirate
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Head/Zombi.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Pirate
		}
	end

	-- Hair
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Afro.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Pirate
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Bald.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Pirate
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Emo.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Pirate
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Enby.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Pirate
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Fade.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Pirate
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/ForwardSwirl.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Pirate
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hair/Pixie.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Pirate
		}
	end

	-- Eyes
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes.lua",
			Priority = math.huge,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Pirate
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Black.lua",
			Priority = math.huge,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Pirate
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Brown.lua",
			Priority = math.huge,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Pirate
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Grey.lua",
			Priority = math.huge,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Pirate
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Eyes/WhiteEyes_Green.lua",
			Priority = math.huge,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			Resource = Pirate
		}
	end

	-- Body
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shirts/PirateVest.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
			Resource = Pirate
		}
	end

	-- Feet
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots1.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Pirate
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots1_Black.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Pirate
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots2.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Pirate
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots3.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Pirate
		}

		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Shoes/LongBoots1.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			Resource = Pirate
		}
	end

	-- Hands
	do
		ItsyScape.Meta.PeepSkin {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = "Resources/Game/Skins/PlayerKit1/Hands/BlackGloves.lua",
			Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			Resource = Pirate
		}
	end
end