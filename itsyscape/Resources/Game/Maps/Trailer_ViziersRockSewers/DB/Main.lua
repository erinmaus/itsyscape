local M = include "Resources/Game/Maps/Trailer_ViziersRockSewers/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Trailer_ViziersRockSewers.Peep",
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
		ColorRed = 55,
		ColorGreen = 55,
		ColorBlue = 200,
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
		ColorRed = 111,
		ColorGreen = 124,
		ColorBlue = 145,
		CastsShadows = 1,
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
		ColorRed = 89,
		ColorGreen = 89,
		ColorBlue = 120,
		NearDistance = 30,
		FarDistance = 55,
		FollowTarget = 1,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 0,
		PositionZ = 13,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Anchor_AncientKaradon_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = -1000,
		PositionY = 0,
		PositionZ = -1000,
		Name = "Anchor_AncientKaradon_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_AncientKaradon_Spawn"]
	}
end

M["Anchor_AncientKaradon_DummyFishingSpot"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = -1000,
		PositionY = 0,
		PositionZ = -1000,
		Name = "Anchor_AncientKaradon_DummyFishingSpot",
		Map = M._MAP,
		Resource = M["Anchor_AncientKaradon_DummyFishingSpot"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "AncientKaradonFishingSpotProxy",
		MapObject = M["Anchor_AncientKaradon_DummyFishingSpot"]
	}
end

M["AncientKaradon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "AncientKaradon",
		Map = M._MAP,
		Resource = M["AncientKaradon"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "AncientKaradon",
		MapObject = M["AncientKaradon"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}
end

M["Anchor_AncientKaradon_Swim_Top"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = -4,
		PositionZ = 25,
		Name = "Anchor_AncientKaradon_Swim_Top",
		Map = M._MAP,
		Resource = M["Anchor_AncientKaradon_Swim_Top"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "AncientKaradon_Spawns",
		Map = M._MAP,
		MapObject = M["Anchor_AncientKaradon_Swim_Top"]
	}
end

-- M["Anchor_AncientKaradon_Swim_Right"] = ItsyScape.Resource.MapObject.Unique()
-- do
-- 	ItsyScape.Meta.MapObjectLocation {
-- 		PositionX = 39,
-- 		PositionY = -4,
-- 		PositionZ = 31,
-- 		Name = "Anchor_AncientKaradon_Swim_Right",
-- 		Map = M._MAP,
-- 		Resource = M["Anchor_AncientKaradon_Swim_Right"]
-- 	}

-- 	ItsyScape.Meta.MapObjectGroup {
-- 		MapObjectGroup = "AncientKaradon_Spawns",
-- 		Map = M._MAP,
-- 		MapObject = M["Anchor_AncientKaradon_Swim_Right"]
-- 	}
-- end

-- M["Anchor_AncientKaradon_Swim_Left"] = ItsyScape.Resource.MapObject.Unique()
-- do
-- 	ItsyScape.Meta.MapObjectLocation {
-- 		PositionX = 23,
-- 		PositionY = -4,
-- 		PositionZ = 31,
-- 		Name = "Anchor_AncientKaradon_Swim_Left",
-- 		Map = M._MAP,
-- 		Resource = M["Anchor_AncientKaradon_Swim_Left"]
-- 	}

-- 	ItsyScape.Meta.MapObjectGroup {
-- 		MapObjectGroup = "AncientKaradon_Spawns",
-- 		Map = M._MAP,
-- 		MapObject = M["Anchor_AncientKaradon_Swim_Left"]
-- 	}
-- end

-- M["Anchor_AncientKaradon_Swim_Bottom"] = ItsyScape.Resource.MapObject.Unique()
-- do
-- 	ItsyScape.Meta.MapObjectLocation {
-- 		PositionX = 31,
-- 		PositionY = -4,
-- 		PositionZ = 39,
-- 		Name = "Anchor_AncientKaradon_Swim_Bottom",
-- 		Map = M._MAP,
-- 		Resource = M["Anchor_AncientKaradon_Swim_Bottom"]
-- 	}

-- 	ItsyScape.Meta.MapObjectGroup {
-- 		MapObjectGroup = "AncientKaradon_Spawns",
-- 		Map = M._MAP,
-- 		MapObject = M["Anchor_AncientKaradon_Swim_Bottom"]
-- 	}
-- end

M["TrashHeap1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 0,
		PositionZ = 15,
		Name = "TrashHeap1",
		Map = M._MAP,
		Resource = M["TrashHeap1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "TrashHeap",
		MapObject = M["TrashHeap1"]
	}
end

M["TrashHeap2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 47,
		PositionY = 0,
		PositionZ = 15,
		Name = "TrashHeap2",
		Map = M._MAP,
		Resource = M["TrashHeap2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "TrashHeap",
		MapObject = M["TrashHeap2"]
	}
end

M["Rat1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 3,
		PositionY = 0,
		PositionZ = 3,
		Name = "Rat1",
		Map = M._MAP,
		Resource = M["Rat1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Rat",
		MapObject = M["Rat1"]
	}
end

M["Rat2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 3,
		PositionY = 0,
		PositionZ = 63,
		Name = "Rat2",
		Map = M._MAP,
		Resource = M["Rat2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Rat",
		MapObject = M["Rat2"]
	}
end

M["Rat3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 0,
		PositionZ = 55,
		Name = "Rat3",
		Map = M._MAP,
		Resource = M["Rat3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Rat",
		MapObject = M["Rat3"]
	}
end

M["Rat3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 7,
		PositionY = 0,
		PositionZ = 57,
		Name = "Rat3",
		Map = M._MAP,
		Resource = M["Rat3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Rat",
		MapObject = M["Rat3"]
	}
end
