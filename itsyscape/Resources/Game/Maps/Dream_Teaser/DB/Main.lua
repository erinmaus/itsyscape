local M = include "Resources/Game/Maps/Dream_Teaser/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Dream_Teaser.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Dream Sequence",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "This dream is just a teaser playground.",
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
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.8,
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
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
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
		ColorRed = 0,
		ColorGreen = 0,
		ColorBlue = 0,
		NearDistance = 100,
		FarDistance = 100,
		FollowTarget = 1,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 1,
		PositionZ = 61,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Gammon"] = ItsyScape.Resource.MapObject.Unique()
do
	local ROTATION = ItsyScape.Utility.Quaternion.fromAxisAngle(
		ItsyScape.Utility.Vector.UNIT_Y,
		math.pi / 4)

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 1.5,
		PositionZ = 33,
		RotationX = ROTATION.x,
		RotationY = ROTATION.y,
		RotationZ = ROTATION.z,
		RotationW = ROTATION.w,
		Name = "Gammon",
		Map = M._MAP,
		Resource = M["Gammon"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Gammon_Base",
		MapObject = M["Gammon"]
	}
end

M["TheEmptyKing"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 1,
		PositionZ = 33,
		Name = "TheEmptyKing",
		Map = M._MAP,
		Resource = M["TheEmptyKing"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "TheEmptyKing_FullyRealized_Cutscene",
		MapObject = M["TheEmptyKing"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "begin-attack",
		Tree = "Resources/Game/Maps/Dream_Teaser/Scripts/TheEmptyKing_BeginAttackLogic.lua",
		Resource = M["TheEmptyKing"]
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "Dream_Teaser_TheEmptyKing"

	ItsyScape.Meta.CutsceneMapObject {
		Name = "TheEmptyKing",
		Cutscene = Cutscene,
		Resource = M["TheEmptyKing"]
	}
end
