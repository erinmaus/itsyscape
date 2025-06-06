local M = include "Resources/Game/Maps/PreTutorial_MansionFloor2/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.PreTutorial_MansionFloor2.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Azathoth, Haunted Mansion, 2nd Floor",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "A mansion haunted by two children.",
	Language = "en-US",
	Resource = M._MAP
}

M["Portal_DownStairs"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 51,
		PositionY = 0,
		PositionZ = 45,
		Name = "Portal_DownStairs",
		Map = M._MAP,
		Resource = M["Portal_DownStairs"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 7,
		SizeY = 2,
		SizeZ = 2,
		MapObject = M["Portal_DownStairs"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_DownStairs"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Floor 1",
		Language = "en-US",
		Resource = M["Portal_DownStairs"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromUpstairs",
		Map = ItsyScape.Resource.Map "PreTutorial_MansionFloor1",
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
end

M["Anchor_FromDownstairs"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 47,
		PositionY = 0,
		PositionZ = 45,
		Name = "Anchor_FromDownstairs",
		Map = M._MAP,
		Resource = M["Anchor_FromDownstairs"]
	}
end

M["Hans"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43,
		PositionY = 0,
		PositionZ = 47,
		Name = "Hans",
		Map = M._MAP,
		Resource = M["Hans"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PreTutorial_ZombiButler",
		MapObject = M["Hans"]
	}
end

M["Powernomicon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 2,
		PositionZ = 29,
		Name = "Powernomicon",
		Map = M._MAP,
		Resource = M["Powernomicon"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Book_Powernomicon",
		MapObject = M["Powernomicon"]
	}

	local TalkAction = ItsyScape.Action.Talk() {
		Output {
			Resource = ItsyScape.Resource.KeyItem "PreTutorial_ReadPowernomicon",
			Count = 1
		}
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Prop "Book_Powernomicon",
		Name = "Powernomicon",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Peeps/PreTutorial/Powernomicon_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Read",
		XProgressive = "Reading",
		Language = "en-US",
		Action = TalkAction
	}

	M["Powernomicon"] {
		TalkAction
	}

	ItsyScape.Meta.KeyItemLocationHint {
		Map = M._MAP,
		MapObject = M["Powernomicon"],
		KeyItem = ItsyScape.Resource.KeyItem "PreTutorial_LearnedToMakeGhostspeakAmulet"
	}
end
