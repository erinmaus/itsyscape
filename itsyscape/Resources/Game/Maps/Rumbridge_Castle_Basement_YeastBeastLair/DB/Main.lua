local M = include "Resources/Game/Maps/Rumbridge_Castle_Basement_YeastBeastLair/DB/Default.lua"

ItsyScape.Meta.ResourceName {
	Value = "Rumbridge Castle, Basement, Yeast Beast Lair",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "That's one angry guy!",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Rumbridge_Castle_Basement_YeastBeastLair.Peep",
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
		ColorRed = 255,
		ColorGreen = 173,
		ColorBlue = 119,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.7,
		Resource = M["Light_Ambient"]
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

	ItsyScape.Meta.Fog {
		ColorRed = 20,
		ColorGreen = 20,
		ColorBlue = 20,
		NearDistance = 40,
		FarDistance = 80,
		FollowTarget = 1,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_FromBasement"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 5,
		PositionY = 0,
		PositionZ = 5,
		Name = "Anchor_FromBasement",
		Map = M._MAP,
		Resource = M["Anchor_FromBasement"]
	}
end

M["YeastBeast"] = ItsyScape.Resource.MapObject.Unique()
do
	local R = ItsyScape.Utility.Quaternion.IDENTITY:slerp(ItsyScape.Utility.Quaternion.Y_90, 0.5):getNormal()

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 36,
		PositionY = 2,
		PositionZ = 32,
		RotationX = R.x,
		RotationY = R.y,
		RotationZ = R.z,
		RotationW = R.w,
		Name = "YeastBeast",
		Map = M._MAP,
		Resource = M["YeastBeast"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "YeastBeast",
		MapObject = M["YeastBeast"]
	}
end

M["Ladder_ToUpperBasement"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 3,
		PositionY = 0,
		PositionZ = 5,
		Name = "Ladder_ToUpperBasement",
		Map = M._MAP,
		Resource = M["Ladder_ToUpperBasement"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromYeastBeastLair",
		Map = ItsyScape.Resource.Map "Rumbridge_Castle_Basement",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_ToUpperBasement"] {
		TravelAction
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["Ladder_ToUpperBasement"]
	}
end
