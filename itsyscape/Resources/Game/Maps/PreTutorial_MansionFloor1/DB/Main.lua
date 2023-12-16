local M = include "Resources/Game/Maps/PreTutorial_MansionFloor1/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.PreTutorial_MansionFloor1.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Azathoth, Haunted Mansion, 1st Floor",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "A mansion haunted by two children.",
	Language = "en-US",
	Resource = M._MAP
}

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 42,
		PositionY = 4,
		PositionZ = 57,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Light_Ambient"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Ambient",
		Map = M._MAP,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "AmbientLight_Default",
		MapObject = M["Light_Ambient"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 101,
		ColorGreen = 139,
		ColorBlue = 131,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.9,
		Resource = M["Light_Ambient"]
	}
end

M["Light_Fog1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Fog1",
		Map = M._MAP,
		Resource = M["Light_Fog1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Fog_Default",
		MapObject = M["Light_Fog1"]
	}

	ItsyScape.Meta.Fog {
		ColorRed = 91,
		ColorGreen = 119,
		ColorBlue = 111,
		NearDistance = 30,
		FarDistance = 60,
		Resource = M["Light_Fog1"]
	}
end

M["Light_Fog2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Fog2",
		Map = M._MAP,
		Resource = M["Light_Fog2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Fog_Default",
		MapObject = M["Light_Fog2"]
	}

	ItsyScape.Meta.Fog {
		ColorRed = 178,
		ColorGreen = 70,
		ColorBlue = 49,
		NearDistance = 50,
		FarDistance = 100,
		Resource = M["Light_Fog2"]
	}
end

M["Light_Lightning"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Lightning",
		Map = M._MAP,
		Resource = M["Light_Lightning"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "AmbientLight_Default",
		MapObject = M["Light_Lightning"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 178,
		ColorGreen = 70,
		ColorBlue = 49,
		Resource = M["Light_Lightning"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.0,
		Resource = M["Light_Lightning"]
	}
end

M["Portal_UpStairs"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 49,
		PositionY = 4,
		PositionZ = 45,
		Name = "Portal_UpStairs",
		Map = M._MAP,
		Resource = M["Portal_UpStairs"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 5.5,
		SizeY = 4,
		SizeZ = 9.5,
		MapObject = M["Portal_UpStairs"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_UpStairs"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Floor 1",
		Language = "en-US",
		Resource = M["Portal_UpStairs"]
	}

	local TravelAction = ItsyScape.Action.Travel() {
		Requirement {
			Resource = ItsyScape.Resource.KeyItem "PreTutorial_TalkedToButler1",
			Count = 1
		}
	}

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromDownstairs",
		Map = ItsyScape.Resource.Map "PreTutorial_MansionFloor2",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Walk-up",
		XProgressive = "Walk-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_UpStairs"] {
		TravelAction
	}

	ItsyScape.Meta.KeyItemLocationHint {
		Map = M._MAP,
		MapObject = M["Portal_UpStairs"],
		KeyItem = ItsyScape.Resource.KeyItem "PreTutorial_ReadPowernomicon"
	}
end

M["Portal_DownStairs"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 4,
		PositionZ = 45,
		Name = "Portal_DownStairs",
		Map = M._MAP,
		Resource = M["Portal_DownStairs"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 5.5,
		SizeY = 2,
		SizeZ = 2.5,
		MapObject = M["Portal_DownStairs"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_DownStairs"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Basement",
		Language = "en-US",
		Resource = M["Portal_DownStairs"]
	}

	local TravelAction = ItsyScape.Action.Travel() {
		Requirement {
			Resource = ItsyScape.Resource.KeyItem "PreTutorial_TalkedToButler1",
			Count = 1
		},

		Requirement {
			Resource = ItsyScape.Resource.KeyItem "PreTutorial_ReadPowernomicon",
			Count = 1
		}
	}

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromUpstairs",
		Map = ItsyScape.Resource.Map "PreTutorial_MansionBasement",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Walk-down",
		XProgressive = "Walking-down",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_DownStairs"] {
		TravelAction
	}

	ItsyScape.Meta.KeyItemLocationHint {
		Map = M._MAP,
		MapObject = M["Portal_DownStairs"],
		KeyItem = ItsyScape.Resource.KeyItem "PreTutorial_MineCopper"
	}
end

M["Anchor_FromUpstairs"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 45,
		PositionY = 4,
		PositionZ = 43,
		Name = "Anchor_FromUpstairs",
		Map = M._MAP,
		Resource = M["Anchor_FromUpstairs"]
	}
end

M["Anchor_FromBasement"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39,
		PositionY = 4,
		PositionZ = 45,
		Name = "Anchor_FromBasement",
		Map = M._MAP,
		Resource = M["Anchor_FromBasement"]
	}
end

M["FrontDoor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 42,
		PositionY = 4,
		PositionZ = 53.75,
		Name = "FrontDoor",
		Map = M._MAP,
		Resource = M["FrontDoor"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_PreTutorialAzathothFrontDoor",
		MapObject = M["FrontDoor"],
		IsMultiLayer = 1
	}
end

M["Hans"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43,
		PositionY = 4,
		PositionZ = 45,
		Name = "Hans",
		Map = M._MAP,
		Resource = M["Hans"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PreTutorial_ZombiButler",
		MapObject = M["Hans"]
	}
end

M["Edward"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 4,
		PositionZ = 29,
		Name = "Edward",
		Map = M._MAP,
		Resource = M["Edward"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PreTutorial_Edward",
		MapObject = M["Edward"]
	}

	ItsyScape.Meta.KeyItemLocationHint {
		Map = M._MAP,
		MapObject = M["Edward"],
		KeyItem = ItsyScape.Resource.KeyItem "PreTutorial_TalkedToGhostBoy"
	}
end

M["Elizabeth"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 13,
		PositionY = 4,
		PositionZ = 45,
		Name = "Elizabeth",
		Map = M._MAP,
		Resource = M["Elizabeth"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PreTutorial_Elizabeth",
		MapObject = M["Elizabeth"]
	}

	ItsyScape.Meta.KeyItemLocationHint {
		Map = M._MAP,
		MapObject = M["Elizabeth"],
		KeyItem = ItsyScape.Resource.KeyItem "PreTutorial_TalkedToGhostGirl"
	}
end

M["SearchableCrate"] = ItsyScape.Resource.MapObject.Unique()
do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.ActionVerb {
		Value = "Search",
		XProgressive = "Searching",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 61,
		PositionY = 4,
		PositionZ = 29,
		Name = "SearchableCrate",
		Map = M._MAP,
		Resource = M["SearchableCrate"]
	}

	ItsyScape.Meta.PropAnchor {
		OffsetI = -1,
		OffsetJ = 0,
		Resource = M["SearchableCrate"]
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Peeps/PreTutorial/Crate_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["SearchableCrate"]
	}

	M["SearchableCrate"] {
		TalkAction
	}

	ItsyScape.Meta.KeyItemLocationHint {
		Map = M._MAP,
		MapObject = M["SearchableCrate"],
		KeyItem = ItsyScape.Resource.KeyItem "PreTutorial_SearchedCrate"
	}
end

M["Maggot"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Maggot",
		Map = M._MAP,
		Resource = M["Maggot"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PreTutorial_Maggot",
		MapObject = M["Maggot"]
	}
end

M["Anchor_Maggot"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27.0,
		PositionY = 4.0,
		PositionZ = 31.0,
		Direction = -1,
		Name = "Anchor_Maggot",
		Map = M._MAP,
		Resource = M["Anchor_Maggot"]
	}
end

M["ShadowTree"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 4,
		PositionZ = 35,
		Name = "ShadowTree",
		Map = M._MAP,
		Resource = M["ShadowTree"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ShadowTree_Default",
		MapObject = M["ShadowTree"]
	}
end

M["CookingRange"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 4,
		PositionZ = 7,
		Name = "CookingRange",
		Map = M._MAP,
		Resource = M["CookingRange"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "CookingRange_Default",
		MapObject = M["CookingRange"]
	}
end

M["Larry"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 47,
		PositionY = 3.5,
		PositionZ = 30,
		Name = "Larry",
		Map = M._MAP,
		Resource = M["Larry"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Larry_Default",
		MapObject = M["Larry"]
	}
end

do
	ItsyScape.Meta.KeyItemLocationHint {
		Map = M._MAP,
		MapObject = M["Anvil"],
		KeyItem = ItsyScape.Resource.KeyItem "PreTutorial_SmithCopperAmulet"
	}

	ItsyScape.Meta.KeyItemLocationHint {
		Map = M._MAP,
		MapObject = M["Furnace"],
		KeyItem = ItsyScape.Resource.KeyItem "PreTutorial_SmeltCopperBar"
	}

	ItsyScape.Meta.KeyItemLocationHint {
		Map = M._MAP,
		MapObject = M["ShadowTree"],
		KeyItem = ItsyScape.Resource.KeyItem "PreTutorial_CraftedToyWeapon"
	}

	ItsyScape.Meta.KeyItemLocationHint {
		Map = M._MAP,
		MapObject = M["Larry"],
		KeyItem = ItsyScape.Resource.KeyItem "PreTutorial_FishedLarry"
	}

	ItsyScape.Meta.KeyItemLocationHint {
		Map = M._MAP,
		MapObject = M["CookingRange"],
		KeyItem = ItsyScape.Resource.KeyItem "PreTutorial_CookedLarry"
	}
end
