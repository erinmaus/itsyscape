local M = include "Resources/Game/Maps/EmptyRuins_Downtown/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.EmptyRuins_Downtown.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Downtown, Empty Ruins",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Only the strongest of wills resist the temptation of death in this horrible place.",
	Language = "en-US",
	Resource = M._MAP
}

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 45,
		PositionY = 5,
		PositionZ = 9,
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
		ColorRed = 113,
		ColorGreen = 55,
		ColorBlue = 200,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.3,
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
		ColorRed = 50,
		ColorGreen = 50,
		ColorBlue = 50,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 4,
		DirectionY = 3,
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
		ColorRed = 113,
		ColorGreen = 55,
		ColorBlue = 200,
		NearDistance = 40,
		FarDistance = 150,
		FollowTarget = 1,
		Resource = M["Light_Fog"]
	}
end

M["EmptyRuinsSkeletonWall"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "EmptyRuinsSkeletonWall",
		Map = M._MAP,
		Resource = M["EmptyRuinsSkeletonWall"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "EmptyRuinsSkeletonWall",
		MapObject = M["EmptyRuinsSkeletonWall"]
	}
end

M["EmptyRuinsWallDecoration"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "EmptyRuinsWallDecoration",
		Map = M._MAP,
		Resource = M["EmptyRuinsWallDecoration"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "EmptyRuinsWallDecoration",
		MapObject = M["EmptyRuinsWallDecoration"]
	}
end

M["Yendorian_Ballista"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Yendorian_Ballista",
		Map = M._MAP,
		Resource = M["Yendorian_Ballista"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yendorian_Ballista",
		MapObject = M["Yendorian_Ballista"]
	}
end

M["Anchor_SkirmishBallista"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 51,
		PositionY = 2,
		PositionZ = 41,
		Name = "Anchor_SkirmishBallista",
		Map = M._MAP,
		Resource = M["Anchor_SkirmishBallista"]
	}
end

M["Yendorian_Mast"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Yendorian_Mast",
		Map = M._MAP,
		Resource = M["Yendorian_Mast"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yendorian_Mast",
		MapObject = M["Yendorian_Mast"]
	}
end

M["Anchor_SkirmishMast"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 77,
		PositionY = 2,
		PositionZ = 61,
		Name = "Anchor_SkirmishMast",
		Map = M._MAP,
		Resource = M["Anchor_SkirmishMast"]
	}
end

M["Yendorian_Swordfish"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Yendorian_Swordfish",
		Map = M._MAP,
		Resource = M["Yendorian_Swordfish"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yendorian_Swordfish",
		MapObject = M["Yendorian_Swordfish"]
	}
end

M["Anchor_SkirmishSwordfish"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 21,
		PositionY = 4,
		PositionZ = 43,
		Name = "Anchor_SkirmishSwordfish",
		Map = M._MAP,
		Resource = M["Anchor_SkirmishSwordfish"]
	}
end

M["Tinkerer"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Tinkerer",
		Map = M._MAP,
		Resource = M["Tinkerer"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Tinkerer",
		MapObject = M["Tinkerer"]
	}
end

M["PrestigiousAncientSkeleton"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "PrestigiousAncientSkeleton",
		Map = M._MAP,
		Resource = M["PrestigiousAncientSkeleton"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PrestigiousAncientSkeleton",
		MapObject = M["PrestigiousAncientSkeleton"]
	}
end

M["PrestigiousMummy"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "PrestigiousMummy",
		Map = M._MAP,
		Resource = M["PrestigiousMummy"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PrestigiousMummy",
		MapObject = M["PrestigiousMummy"]
	}
end

M["GoryMass"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "GoryMass",
		Map = M._MAP,
		Resource = M["GoryMass"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "GoryMass",
		MapObject = M["GoryMass"]
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "EmptyRuins_Downtown_Intro"

	ItsyScape.Meta.CutsceneMapObject {
		Name = "YendorianBallista",
		Cutscene = Cutscene,
		Resource = M["Yendorian_Ballista"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "YendorianSwordfish",
		Cutscene = Cutscene,
		Resource = M["Yendorian_Swordfish"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "YendorianMast",
		Cutscene = Cutscene,
		Resource = M["Yendorian_Mast"]
	}
end
