local M = include "Resources/Game/Maps/Rumbridge_Farm2/DB/Default.lua"

ItsyScape.Meta.ResourceName {
	Value = "North Farm, Rumbridge",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Not a petting zoo.",
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
		ColorRed = 33,
		ColorGreen = 162,
		ColorBlue = 234,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.6,
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
		DirectionY = 5,
		DirectionZ = 4,
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

	ItsyScape.Meta.Fog {
		ColorRed = 33,
		ColorGreen = 162,
		ColorBlue = 234,
		NearDistance = 50,
		FarDistance = 200,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_FromFarm1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 30,
		PositionY = 4,
		PositionZ = 58,
		Name = "Anchor_FromFarm1",
		Map = M._MAP,
		Resource = M["Anchor_FromFarm1"]
	}
end

M["Portal_RumbridgeFarmNorth"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 28,
		PositionY = 4,
		PositionZ = 1,
		Name = "Portal_RumbridgeFarmNorth",
		Map = M._MAP,
		Resource = M["Portal_RumbridgeFarmNorth"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 4,
		SizeY = 2,
		SizeZ = 4,
		MapObject = M["Portal_RumbridgeFarmNorth"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_RumbridgeFarmNorth"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rumbridge Farm, North",
		Language = "en-US",
		Resource = M["Portal_RumbridgeFarmNorth"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromFarm2",
		Map = ItsyScape.Resource.Map "Rumbridge_Farm1",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Enter",
		XProgressive = "Entering",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_RumbridgeFarmNorth"] {
		TravelAction
	}
end

M["Cow1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 53,
		PositionY = 4,
		PositionZ = 33,
		Name = "Cow1",
		Map = M._MAP,
		Resource = M["Cow1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Cow_Base",
		MapObject = M["Cow1"]
	}
end

M["Cow2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 4,
		PositionZ = 33,
		Name = "Cow2",
		Map = M._MAP,
		Resource = M["Cow2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Cow_Base",
		MapObject = M["Cow2"]
	}
end

M["Cow3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 49,
		PositionY = 4,
		PositionZ = 41,
		Name = "Cow3",
		Map = M._MAP,
		Resource = M["Cow3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Cow_Base",
		MapObject = M["Cow3"]
	}
end

M["Cow4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 4,
		PositionZ = 41,
		Name = "Cow4",
		Map = M._MAP,
		Resource = M["Cow4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Cow_Base",
		MapObject = M["Cow4"]
	}
end

M["Pig1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 53,
		PositionY = 4,
		PositionZ = 11,
		ScaleX = 0.25,
		ScaleY = 0.25,
		ScaleZ = 0.25,
		Name = "Pig1",
		Map = M._MAP,
		Resource = M["Pig1"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Tonton",
		Language = "en-US",
		Resource = M["Pig1"]
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Ooooooooink!",
		Language = "en-US",
		Resource = M["Pig1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Pig_Base",
		MapObject = M["Pig1"]
	}
end

M["Pig2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 45,
		PositionY = 4,
		PositionZ = 15,
		Name = "Pig2",
		Map = M._MAP,
		Resource = M["Pig2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Pig_Base",
		MapObject = M["Pig2"]
	}
end

M["Pig3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39,
		PositionY = 4,
		PositionZ = 9,
		Name = "Pig3",
		Map = M._MAP,
		Resource = M["Pig3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Pig_Base",
		MapObject = M["Pig3"]
	}
end

M["Cheep1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 4,
		PositionZ = 15,
		Name = "Cheep1",
		Map = M._MAP,
		Resource = M["Cheep1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Cheep_Base",
		MapObject = M["Cheep1"]
	}
end

M["Cheep2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 7,
		PositionY = 4,
		PositionZ = 27,
		Name = "Cheep2",
		Map = M._MAP,
		Resource = M["Cheep2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Cheep_Base",
		MapObject = M["Cheep2"]
	}
end

M["Cheep3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 4,
		PositionZ = 29,
		Name = "Cheep3",
		Map = M._MAP,
		Resource = M["Cheep3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Cheep_Base",
		MapObject = M["Cheep3"]
	}
end

M["Cheep4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 17,
		PositionY = 4,
		PositionZ = 57,
		Name = "Cheep4",
		Map = M._MAP,
		Resource = M["Cheep4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Cheep_Base",
		MapObject = M["Cheep4"]
	}
end

M["Chicken1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 45,
		PositionY = 4,
		PositionZ = 33,
		Name = "Chicken1",
		Map = M._MAP,
		Resource = M["Chicken1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Chicken_Base",
		MapObject = M["Chicken1"]
	}
end

M["Chicken2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 5,
		PositionY = 4,
		PositionZ = 27,
		Name = "Chicken2",
		Map = M._MAP,
		Resource = M["Chicken2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Chicken_Base",
		MapObject = M["Chicken2"]
	}
end

M["Chicken3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 53,
		PositionY = 4,
		PositionZ = 59,
		Name = "Chicken3",
		Map = M._MAP,
		Resource = M["Chicken3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Chicken_Base",
		MapObject = M["Chicken3"]
	}
end

M["Chicken4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 4,
		PositionZ = 9,
		Name = "Chicken4",
		Map = M._MAP,
		Resource = M["Chicken4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Chicken_Base",
		MapObject = M["Chicken4"]
	}
end
