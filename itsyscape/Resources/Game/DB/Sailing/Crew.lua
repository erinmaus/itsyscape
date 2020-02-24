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
		Resource = Meta.TYPE_TEXT
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
