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

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Shirts/RoyalBlueRobes.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = Yohn
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes_GreyBrown.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Priority = math.huge,
		Resource = Yohn
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Hands/RoyalBlueGloves.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = Yohn
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Head/Light.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = Yohn
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Hair/MiddleAgeMessy.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
		Resource = Yohn
	}

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
