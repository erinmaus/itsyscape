local M = include "Resources/Game/Maps/Sailing_HumanityEdge/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Sailing_HumanityEdge.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Humanity's Edge",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "The edge between humanity and the corpse islands of Yendor's sprawling necropolis archipelago.",
	Language = "en-US",
	Resource = M._MAP
}

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
		ColorRed = 231,
		ColorGreen = 168,
		ColorBlue = 194,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.4,
		Resource = M["Light_Ambient"]
	}
end

M["Light_Sun"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Sun",
		Map = M._MAP,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "DirectionalLight_Default",
		MapObject = M["Light_Sun"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 234,
		ColorGreen = 162,
		ColorBlue = 33,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 4,
		DirectionY = 3,
		DirectionZ = 4,
		CastsShadows = 1,
		Resource = M["Light_Sun"]
	}
end

M["Light_Fog"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Fog",
		Map = M._MAP,
		Resource = M["Light_Fog"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Fog_Default",
		MapObject = M["Light_Fog"]
	}
end

M["Water"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Water",
		Map = M._MAP,
		Resource = M["Water"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "EndlessWater",
		MapObject = M["Water"]
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 141,
		PositionY = 3,
		PositionZ = 173,
		Direction = -1,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Tutorial_DroppedItemsAnchor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_DroppedItems",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["Tutorial_DroppedItemsAnchor"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 141,
		PositionY = 3,
		PositionZ = 173,
		Name = "Tutorial_DroppedItemsAnchor",
		Map = M._MAP,
		Resource = M["Tutorial_DroppedItemsAnchor"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Peep "Anchor_Default",
		MapObject = M["Tutorial_DroppedItemsAnchor"]
	}

	ItsyScape.Meta.KeyItemLocationHint {
		Map = M._MAP,
		MapObject = M["Tutorial_DroppedItemsAnchor"],
		KeyItem = ItsyScape.Resource.KeyItem "Tutorial_GatheredItems"
	}
end

M["Orlando"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_Team",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["Orlando"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 139,
		PositionY = 3,
		PositionZ = 173,
		Direction = 1,
		Name = "Orlando",
		Map = M._MAP,
		Resource = M["Orlando"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Orlando",
		MapObject = M["Orlando"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkCharacter {
		Character = ItsyScape.Resource.Character "Orlando",
		Main = "quest_tutorial_main",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Orlando"],
		Name = "Orlando",
		Action = TalkAction
	}

	ItsyScape.Meta.NamedPeepAction {
		Name = "Talk",
		Action = TalkAction,
		Peep = M["Orlando"]
	}

	M["Orlando"] {
		TalkAction
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "tutorial-look-away-from-player",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Orlando_LookAwayLogic.lua",
		Resource = M["Orlando"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "tutorial-follow-player",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Orlando_FollowLogic.lua",
		Resource = M["Orlando"]
	}
end

M["YendorianScout"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_YendorianScout",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["YendorianScout"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 3,
		PositionZ = 163,
		Direction = 1,
		Name = "YendorianScout",
		Map = M._MAP,
		Resource = M["YendorianScout"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yendorian_Scout",
		MapObject = M["YendorianScout"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}
end

M["Passage_Scout"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_Scout",
		Map = M._MAP,
		Resource = M["Passage_Scout"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 40,
		Z1 = 164,
		X2 = 50,
		Z2 = 187,
		Map = M._MAP,
		Resource = M["Passage_Scout"]
	}
end
