local M = include "Resources/Game/Maps/IsabelleIsland_FarOcean_Cutscene/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.IsabelleIsland_FarOcean_Cutscene.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Port Isabelle, Far Ocean (Underwater)",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Cthulhu stirs...",
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
		ColorGreen = 33,
		ColorBlue = 255,
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
		ColorRed = 66,
		ColorGreen = 66,
		ColorBlue = 132,
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
		ColorGreen = 33,
		ColorBlue = 66,
		NearDistance = 30,
		FarDistance = 60,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_Ship_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 16,
		PositionY = 16,
		PositionZ = 4,
		Name = "Anchor_Ship_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Ship_Spawn"]
	}
end

M["Anchor_Ship_Target"] = ItsyScape.Resource.MapObject.Unique()
do
	local rotation1 = ItsyScape.Utility.Quaternion.fromAxisAngle(
		ItsyScape.Utility.Vector.UNIT_X,
		math.pi / 4)
	local rotation2 = ItsyScape.Utility.Quaternion.fromAxisAngle(
		ItsyScape.Utility.Vector.UNIT_Z,
		math.pi / 4)
	local rotation = rotation1 * rotation2

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = -4,
		PositionZ = 4,
		RotationX = rotation.x,
		RotationY = rotation.y,
		RotationZ = rotation.z,
		RotationW = rotation.w,
		Name = "Anchor_Ship_Target",
		Map = M._MAP,
		Resource = M["Anchor_Ship_Target"]
	}
end

M["Coelacanth1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 28,
		PositionY = 10,
		PositionZ = 28,
		Name = "Coelacanth1",
		Map = M._MAP,
		Resource = M["Coelacanth1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Coelacanth_Default",
		MapObject = M["Coelacanth1"]
	}
end

M["Anchor_Coelacanth1_Target"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 10,
		PositionY = 8,
		PositionZ = 32,
		Name = "Anchor_Coelacanth1_Target",
		Map = M._MAP,
		Resource = M["Anchor_Coelacanth1_Target"]
	}
end

M["Coelacanth2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 24,
		PositionY = 12,
		PositionZ = 28,
		Name = "Coelacanth2",
		Map = M._MAP,
		Resource = M["Coelacanth2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Coelacanth_Default",
		MapObject = M["Coelacanth2"]
	}
end

M["Anchor_Coelacanth2_Target"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 42,
		PositionY = 8,
		PositionZ = 26,
		Name = "Anchor_Coelacanth2_Target",
		Map = M._MAP,
		Resource = M["Anchor_Coelacanth2_Target"]
	}
end

M["Wizard"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 28,
		PositionY = 26,
		PositionZ = 28,
		Name = "Wizard",
		Map = M._MAP,
		Resource = M["Wizard"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Wizard",
		MapObject = M["Wizard"]
	}
end

M["Anchor_Wizard_Target"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 28,
		PositionY = 1,
		PositionZ = 28,
		Name = "Anchor_Wizard_Target",
		Map = M._MAP,
		Resource = M["Anchor_Wizard_Target"]
	}
end

M["Archer"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 36,
		PositionY = 22,
		PositionZ = 34,
		Name = "Archer",
		Map = M._MAP,
		Resource = M["Archer"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Archer",
		MapObject = M["Archer"]
	}
end

M["Anchor_Archer_Target"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 36,
		PositionY = 1,
		PositionZ = 34,
		Name = "Anchor_Archer_Target",
		Map = M._MAP,
		Resource = M["Anchor_Archer_Target"]
	}
end

M["Cthulhu"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 32,
		PositionY = 0,
		PositionZ = 10,
		Name = "Cthulhu",
		Map = M._MAP,
		Resource = M["Cthulhu"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Cthulhu",
		MapObject = M["Cthulhu"]
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 32,
		PositionY = 24,
		PositionZ = 32,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Anchor_Player_Target"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 32,
		PositionY = 4,
		PositionZ = 32,
		Name = "Anchor_Player_Target",
		Map = M._MAP,
		Resource = M["Anchor_Player_Target"]
	}
end

M["Anchor_Portal_Target"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		ScaleX = 2,
		ScaleY = 2,
		ScaleZ = 2,
		Name = "Anchor_Portal_Target",
		Map = M._MAP,
		Resource = M["Anchor_Portal_Target"]
	}
end

M["Anchor_Portal"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 30,
		PositionY = 0,
		PositionZ = 32,
		ScaleX = 0.01,
		ScaleY = 0.01,
		ScaleZ = 0.01,
		Name = "Anchor_Portal",
		Map = M._MAP,
		Resource = M["Anchor_Portal"]
	}
end

M["AzathothPortal"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "AzathothPortal",
		Map = M._MAP,
		Resource = M["AzathothPortal"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Portal_Chasm",
		MapObject = M["AzathothPortal"]
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "IsabelleIsland_FarOcean_Sink"

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Wizard",
		Cutscene = Cutscene,
		Resource = M["Wizard"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Archer",
		Cutscene = Cutscene,
		Resource = M["Archer"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Coelacanth1",
		Cutscene = Cutscene,
		Resource = M["Coelacanth1"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Coelacanth2",
		Cutscene = Cutscene,
		Resource = M["Coelacanth2"]
	}

	ItsyScape.Meta.CutsceneMap {
		Name = "CapnRavensShip",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Map "Ship_IsabelleIsland_Pirate"
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "IsabelleIsland_FarOcean_Portal"

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Portal",
		Cutscene = Cutscene,
		Resource = M["AzathothPortal"]
	}
end
