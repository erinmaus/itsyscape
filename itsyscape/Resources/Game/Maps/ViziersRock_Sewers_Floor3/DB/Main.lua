local M = include "Resources/Game/Maps/ViziersRock_Sewers_Floor3/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.ViziersRock_Sewers_Floor3.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Vizier's Rock Sewers, Floor 3",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "The ancient karadon was supposed to be extinct...",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.RaidGroup {
	Raid = ItsyScape.Resource.Raid "ViziersRockSewers",
	Map = M._MAP
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

M["CourtyardGate"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 0,
		PositionZ = 9.625,
		RotationX = 0,
		RotationY = 1,
		RotationZ = 0,
		RotationW = 0,
		Name = "CourtyardGate",
		Map = M._MAP,
		Resource = M["CourtyardGate"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_IronGate_Guardian",
		MapObject = M["CourtyardGate"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "AncientKaradon",
		Map = M._MAP,
		MapObject = M["CourtyardGate"]
	}

	M["CourtyardGate"] {
		ItsyScape.Action.Open()
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

M["Anchor_FromFloor2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 3,
		PositionY = 0,
		PositionZ = 59,
		Name = "Anchor_FromFloor2",
		Map = M._MAP,
		Resource = M["Anchor_FromFloor2"]
	}
end

M["Anchor_FromCourtyard"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 0,
		PositionZ = 5,
		Name = "Anchor_FromCourtyard",
		Map = M._MAP,
		Resource = M["Anchor_FromCourtyard"]
	}
end

M["Ladder_FromFloor2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 3,
		PositionY = 0,
		PositionZ = 61,
		Name = "Ladder_FromFloor2",
		Map = M._MAP,
		Resource = M["Ladder_FromFloor2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "MetalLadder_Default",
		MapObject = M["Ladder_FromFloor2"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromKaradon",
		Map = ItsyScape.Resource.Map "ViziersRock_Sewers_Floor2",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_FromFloor2"] {
		TravelAction
	}
end

M["Ladder_ToCourtyard"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 0,
		PositionZ = 3,
		Name = "Ladder_ToCourtyard",
		Map = M._MAP,
		Resource = M["Ladder_ToCourtyard"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "MetalLadder_Default",
		MapObject = M["Ladder_ToCourtyard"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromKaradon",
		Map = ItsyScape.Resource.Map "ViziersRock_Sewers_Courtyard",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_ToCourtyard"] {
		TravelAction
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

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "AncientKaradon",
		Map = M._MAP,
		MapObject = M["AncientKaradon"]
	}
end

M["Anchor_AncientKaradon_Swim_Top"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 0,
		PositionZ = 21,
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

M["Anchor_AncientKaradon_Swim_Right"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 47,
		PositionY = 0,
		PositionZ = 31,
		Name = "Anchor_AncientKaradon_Swim_Right",
		Map = M._MAP,
		Resource = M["Anchor_AncientKaradon_Swim_Right"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "AncientKaradon_Spawns",
		Map = M._MAP,
		MapObject = M["Anchor_AncientKaradon_Swim_Right"]
	}
end

M["Anchor_AncientKaradon_Swim_Left"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 17,
		PositionY = 0,
		PositionZ = 31,
		Name = "Anchor_AncientKaradon_Swim_Left",
		Map = M._MAP,
		Resource = M["Anchor_AncientKaradon_Swim_Left"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "AncientKaradon_Spawns",
		Map = M._MAP,
		MapObject = M["Anchor_AncientKaradon_Swim_Left"]
	}
end

M["Anchor_AncientKaradon_Swim_Bottom"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 0,
		PositionZ = 43,
		Name = "Anchor_AncientKaradon_Swim_Bottom",
		Map = M._MAP,
		Resource = M["Anchor_AncientKaradon_Swim_Bottom"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "AncientKaradon_Spawns",
		Map = M._MAP,
		MapObject = M["Anchor_AncientKaradon_Swim_Bottom"]
	}
end

M["TrashHeap1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 7,
		PositionY = 0,
		PositionZ = 33,
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
		PositionX = 59,
		PositionY = 0,
		PositionZ = 33,
		Name = "TrashHeap2",
		Map = M._MAP,
		Resource = M["TrashHeap2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "TrashHeap",
		MapObject = M["TrashHeap2"]
	}
end

M["TrashHeap3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 0,
		PositionZ = 13,
		Name = "TrashHeap3",
		Map = M._MAP,
		Resource = M["TrashHeap3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "TrashHeap",
		MapObject = M["TrashHeap3"]
	}
end
