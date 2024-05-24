--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/ViziersRock/Palace.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "Bench_ViziersRock" {
	-- Nothing
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "Bench_ViziersRock"
}

ItsyScape.Meta.ResourceName {
	Value = "Bench",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Bench_ViziersRock"
}

ItsyScape.Meta.ResourceDescription {
	Value = "What's the difference between a bench and a pew...?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Bench_ViziersRock"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 3.5,
	SizeY = 3,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Bench_ViziersRock"
}

ItsyScape.Resource.Prop "Door_Curtain_ViziersRock" {
	ItsyScape.Action.Open(),
	ItsyScape.Action.Close()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicDoor",
	Resource = ItsyScape.Resource.Prop "Door_Curtain_ViziersRock"
}

ItsyScape.Meta.ResourceName {
	Value = "Curtain",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_Curtain_ViziersRock"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 3.5,
	SizeY = 4,
	SizeZ = 0.5,
	MapObject = ItsyScape.Resource.Prop "Door_Curtain_ViziersRock"
}

ItsyScape.Meta.ResourceDescription {
	Value = "The man behind the curtain...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_Curtain_ViziersRock"
}

ItsyScape.Resource.Prop "GrandStaircase_ViziersRock" {
	-- Nothing
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.PassableProp",
	Resource = ItsyScape.Resource.Prop "GrandStaircase_ViziersRock"
}

ItsyScape.Meta.ResourceName {
	Value = "Grand staircase",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "GrandStaircase_ViziersRock"
}

ItsyScape.Meta.ResourceDescription {
	Value = "One fancy staircase!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "GrandStaircase_ViziersRock"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 11.5,
	SizeY = 6.5,
	SizeZ = 5.5,
	MapObject = ItsyScape.Resource.Prop "GrandStaircase_ViziersRock"
}

ItsyScape.Resource.Prop "Column_ViziersRock" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "Column_ViziersRock"
}

ItsyScape.Meta.ResourceName {
	Value = "Column",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Column_ViziersRock"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Better a column than a row!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Column_ViziersRock"
}

ItsyScape.Resource.Prop "ComfyThrone_ViziersRock" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.FurnitureProp",
	Resource = ItsyScape.Resource.Prop "ComfyThrone_ViziersRock"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 2.5,
	SizeY = 3.5,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "ComfyThrone_ViziersRock"
}

ItsyScape.Meta.ResourceName {
	Value = "Vizier-King Yohn's throne",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "ComfyThrone_ViziersRock"
}

ItsyScape.Meta.ResourceDescription {
	Value = "I don't think I'll ever be able to sit on that!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "ComfyThrone_ViziersRock"
}

ItsyScape.Resource.Prop "DiningTable_Fancy_ViziersRock" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicTableProp",
	Resource = ItsyScape.Resource.Prop "DiningTable_Fancy_ViziersRock"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 3.5,
	SizeY = 4,
	SizeZ = 9.5,
	MapObject = ItsyScape.Resource.Prop "DiningTable_Fancy_ViziersRock"
}

ItsyScape.Meta.ResourceName {
	Value = "Fancy dining table",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "DiningTable_Fancy_ViziersRock"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Look at all that fancy food on the fancy table!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "DiningTable_Fancy_ViziersRock"
}

ItsyScape.Resource.Prop "DiningTableChair_Fancy_ViziersRock" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.FurnitureProp",
	Resource = ItsyScape.Resource.Prop "DiningTableChair_Fancy_ViziersRock"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 4,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "DiningTableChair_Fancy_ViziersRock"
}

ItsyScape.Meta.ResourceName {
	Value = "Fancy dining chair",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "DiningTableChair_Fancy_ViziersRock"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Makes eating all the fancier!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "DiningTableChair_Fancy_ViziersRock"
}

do
	local Yohn = ItsyScape.Resource.Peep "VizierKingYohn"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Human.BaseHuman",
		Resource = Yohn
	}

	ItsyScape.Utility.skins(Yohn, {
		{	
			filename = "PlayerKit2/Head/Humanlike.lua",
			slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			colors = {
				"SKIN_LIGHT"
			}
		},
		{
			filename = "PlayerKit2/Hair/MiddleAgeMessy.lua",
			slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			colors = {
				"6c5353"
			}
		},
		{
			filename = "PlayerKit2/Eyes/Eyes.lua",
			slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			priority = math.huge,
			colors = {
				"6c5353",
				"EYE_WHITE",
				"EYE_BLACK"
			}
		},
		{
			filename = "PlayerKit2/Shirts/RoyalRobe.lua",
			slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
			priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			colors = {
				"3771c8",
				"87aade",
				"PRIMARY_YELLOW"
			}
		},
		{
			filename = "PlayerKit2/Hands/StripedGloves.lua",
			slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			colors = {
				"3771c8",
				"PRIMARY_YELLOW"
			}
		}
	})

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BluePartyHat",
		Count = 1,
		Resource = Yohn
	}

	ItsyScape.Meta.ResourceName {
		Value = "Vizier-King Yohn",
		Language = "en-US",
		Resource = Yohn
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Elected vizier and born king, he rules the Realm with a hint of zealotry to Bastiel.",
		Language = "en-US",
		Resource = Yohn
	}
end

do
	local Key = ItsyScape.Resource.Item "ViziersRock_Palace_MineKey"

	ItsyScape.Meta.Item {
		Value = 1,
		Resource = Key
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Vizier's Rock palace dungeon key",
		Resource = Key
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Opens the gate to the caesium mine in the Vizier's Rock palace dungeon.",
		Resource = Key
	}
end
