local M = include "Resources/Game/Maps/Test_Ship/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Maps.ShipMapPeep2",
	Resource = M._MAP
}

ItsyScape.Meta.MapShip {
	SizeClass = "Galleon",
	Map = M._MAP
}

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 30,
		PositionY = 0,
		PositionZ = 8,
		Layer = 1,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Anchor_BelowDeck"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 30,
		PositionY = 0,
		PositionZ = 8,
		Layer = 3,
		Name = "Anchor_BelowDeck",
		Map = M._MAP,
		Resource = M["Anchor_BelowDeck"]
	}
end

M["Hotspot_Capstan"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 0,
		PositionZ = 8,
		Name = "Hotspot_Capstan",
		Map = M._MAP,
		Resource = M["Hotspot_Capstan"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "Capstan",
		ItemGroup = "Capstan",
		MapObject = M["Hotspot_Capstan"],
		Map = M._MAP
	}
end

M["Hotspot_Figurehead"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = -1,
		PositionY = -1.5,
		PositionZ = 8,
		Name = "Hotspot_Figurehead",
		Map = M._MAP,
		Resource = M["Hotspot_Figurehead"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "Figurehead",
		ItemGroup = "Figurehead",
		MapObject = M["Hotspot_Figurehead"],
		Map = M._MAP
	}
end

M["Hotspot_Helm"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 3,
		PositionY = 0,
		PositionZ = 8,
		RotationX = 0.000000,
		RotationY = 0.707107,
		RotationZ = 0.000000,
		RotationW = -0.707107,
		Layer = 2,
		Name = "Hotspot_Helm",
		Map = M._MAP,
		Resource = M["Hotspot_Helm"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "Helm",
		ItemGroup = "Helm",
		MapObject = M["Hotspot_Helm"],
		Map = M._MAP
	}
end

M["Hotspot_Hull"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 30,
		PositionY = 0,
		PositionZ = 8,
		Name = "Hotspot_Hull",
		Map = M._MAP,
		Resource = M["Hotspot_Hull"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "Hull",
		ItemGroup = "Hull",
		MapObject = M["Hotspot_Hull"],
		Map = M._MAP
	}
end

M["Hotspot_ForeMast"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 10.5,
		PositionY = 0,
		PositionZ = 8,
		RotationX = 0.000000,
		RotationY = 0.707107,
		RotationZ = 0.000000,
		RotationW = -0.707107,
		Name = "Hotspot_ForeMast",
		Map = M._MAP,
		Resource = M["Hotspot_ForeMast"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "ForeMast",
		ItemGroup = "Mast",
		MapObject = M["Hotspot_ForeMast"],
		Map = M._MAP
	}
end

M["Hotspot_MainMast"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 30.5,
		PositionY = 0,
		PositionZ = 8,
		RotationX = 0.000000,
		RotationY = 0.707107,
		RotationZ = 0.000000,
		RotationW = -0.707107,
		Name = "Hotspot_MainMast",
		Map = M._MAP,
		Resource = M["Hotspot_MainMast"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "MainMast",
		ItemGroup = "Mast",
		MapObject = M["Hotspot_MainMast"],
		Map = M._MAP
	}
end

M["Hotspot_RearMast"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 10.5,
		PositionY = 0,
		PositionZ = 8,
		RotationX = 0.000000,
		RotationY = 0.707107,
		RotationZ = 0.000000,
		RotationW = -0.707107,
		Layer = 2,
		Name = "Hotspot_RearMast",
		Map = M._MAP,
		Resource = M["Hotspot_RearMast"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "RearMast",
		ItemGroup = "Mast",
		MapObject = M["Hotspot_RearMast"],
		Map = M._MAP
	}
end

M["Hotspot_Rail"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 30,
		PositionY = 0,
		PositionZ = 8,
		Name = "Hotspot_Rail",
		Map = M._MAP,
		Resource = M["Hotspot_Rail"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "Rail",
		ItemGroup = "Rail",
		MapObject = M["Hotspot_Rail"],
		Map = M._MAP
	}
end

M["Hotspot_Sail_ForeMast"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 12,
		PositionY = 0,
		PositionZ = 8,
		RotationX = 0.000000,
		RotationY = 0.707107,
		RotationZ = 0.000000,
		RotationW = -0.707107,
		Name = "Hotspot_Sail_ForeMast",
		Map = M._MAP,
		Resource = M["Hotspot_Sail_ForeMast"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "Sail_ForeMast",
		ItemGroup = "Sail",
		MapObject = M["Hotspot_Sail_ForeMast"],
		Map = M._MAP
	}
end

M["Hotspot_Sail_MainMast"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 32,
		PositionY = 0,
		PositionZ = 8,
		RotationX = 0.000000,
		RotationY = 0.707107,
		RotationZ = 0.000000,
		RotationW = -0.707107,
		Name = "Hotspot_Sail_MainMast",
		Map = M._MAP,
		Resource = M["Hotspot_Sail_MainMast"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "Sail_MainMast",
		ItemGroup = "Sail",
		MapObject = M["Hotspot_Sail_MainMast"],
		Map = M._MAP
	}
end

M["Hotspot_Sail_RearMast"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 12,
		PositionY = 0,
		PositionZ = 8,
		Layer = 2,
		RotationX = 0.000000,
		RotationY = 0.707107,
		RotationZ = 0.000000,
		RotationW = -0.707107,
		Name = "Hotspot_Sail_RearMast",
		Map = M._MAP,
		Resource = M["Hotspot_Sail_RearMast"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "Sail_RearMast",
		ItemGroup = "Sail",
		MapObject = M["Hotspot_Sail_RearMast"],
		Map = M._MAP
	}
end


M["Hotspot_Window"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 30,
		PositionY = 0,
		PositionZ = 8,
		Name = "Hotspot_Window",
		Map = M._MAP,
		Resource = M["Hotspot_Window"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "Window",
		ItemGroup = "Window",
		MapObject = M["Hotspot_Window"],
		Map = M._MAP
	}
end

M["Anchor_FromBelowDeck"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 0,
		PositionZ = 5,
		Name = "Anchor_FromBelowDeck",
		Map = M._MAP,
		Resource = M["Anchor_FromBelowDeck"]
	}
end

M["Anchor_Starboard_Cannon1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 0,
		PositionZ = 3,
		Layer = 1,
		Name = "Anchor_Starboard_Cannon1",
		Map = M._MAP,
		Resource = M["Anchor_Starboard_Cannon1"]
	}
end

M["Hotspot_Starboard_Cannon1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 0,
		PositionZ = 1,
		RotationX = -0.000000,
		RotationY = -1.000000,
		RotationZ = 0.000000,
		RotationW = 0.000000,
		Name = "Hotspot_Starboard_Cannon1",
		Map = M._MAP,
		Resource = M["Hotspot_Starboard_Cannon1"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "Cannon",
		ItemGroup = "Cannon",
		Index = 1,
		MapObject = M["Hotspot_Starboard_Cannon1"],
		Map = M._MAP
	}
end

M["Anchor_Starboard_Cannon2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 0,
		PositionZ = 3,
		Layer = 1,
		Name = "Anchor_Starboard_Cannon2",
		Map = M._MAP,
		Resource = M["Anchor_Starboard_Cannon2"]
	}
end

M["Hotspot_Starboard_Cannon2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 0,
		PositionZ = 1,
		RotationX = -0.000000,
		RotationY = -1.000000,
		RotationZ = 0.000000,
		RotationW = 0.000000,
		Name = "Hotspot_Starboard_Cannon2",
		Map = M._MAP,
		Resource = M["Hotspot_Starboard_Cannon2"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "Cannon",
		ItemGroup = "Cannon",
		Index = 2,
		MapObject = M["Hotspot_Starboard_Cannon2"],
		Map = M._MAP
	}
end

M["Anchor_Port_Cannon1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 0,
		PositionZ = 13,
		Layer = 1,
		Name = "Anchor_Port_Cannon1",
		Map = M._MAP,
		Resource = M["Anchor_Port_Cannon1"]
	}
end

M["Hotspot_Port_Cannon1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 0,
		PositionZ = 15,
		Name = "Hotspot_Port_Cannon1",
		Map = M._MAP,
		Resource = M["Hotspot_Port_Cannon1"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "Cannon",
		ItemGroup = "Cannon",
		Index = 3,
		MapObject = M["Hotspot_Port_Cannon1"],
		Map = M._MAP
	}
end

M["Anchor_Port_Cannon2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 0,
		PositionZ = 13,
		Layer = 1,
		Name = "Anchor_Port_Cannon2",
		Map = M._MAP,
		Resource = M["Anchor_Port_Cannon2"]
	}
end

M["Hotspot_Port_Cannon2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 0,
		PositionZ = 15,
		Name = "Hotspot_Port_Cannon2",
		Map = M._MAP,
		Resource = M["Hotspot_Port_Cannon2"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "Cannon",
		ItemGroup = "Cannon",
		Index = 4,
		MapObject = M["Hotspot_Port_Cannon2"],
		Map = M._MAP
	}
end

M["Anchor_FromBelowDeck"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 0,
		PositionZ = 5,
		Layer = 1,
		Name = "Anchor_FromBelowDeck",
		Map = M._MAP,
		Resource = M["Anchor_FromBelowDeck"]
	}
end

M["Anchor_ToBelowDeck"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 0,
		PositionZ = 5,
		Layer = 3,
		Name = "Anchor_ToBelowDeck",
		Map = M._MAP,
		Resource = M["Anchor_ToBelowDeck"]
	}
end

M["Anchor_Captain"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 5,
		PositionY = 0,
		PositionZ = 8,
		Layer = 2,
		Name = "Anchor_Captain",
		Map = M._MAP,
		Resource = M["Anchor_Captain"]
	}
end

M["TrapDoor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39,
		PositionY = 0,
		PositionZ = 5,
		RotationX = 0.000000,
		RotationY = 0.707107,
		RotationZ = 0.000000,
		RotationW = -0.707107,
		Name = "TrapDoor",
		Map = M._MAP,
		Resource = M["TrapDoor"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "TrapDoor_Default",
		MapObject = M["TrapDoor"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.LocalTravelDestination {
		Map = M._MAP,
		Anchor = "Anchor_ToBelowDeck",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-down",
		XProgressive = "Climbing-down",
		Language = "en-US",
		Action = TravelAction
	}

	M["TrapDoor"] {
		TravelAction
	}
end

M["WoodenLadder_BelowDeck"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39,
		PositionY = 0,
		PositionZ = 5,
		RotationX = 0.000000,
		RotationY = -0.707107,
		RotationZ = 0.000000,
		RotationW = 0.707107,
		Layer = 3,
		Name = "WoodenLadder_BelowDeck",
		Map = M._MAP,
		Resource = M["WoodenLadder_BelowDeck"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["WoodenLadder_BelowDeck"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.LocalTravelDestination {
		Map = M._MAP,
		Anchor = "Anchor_FromBelowDeck",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["WoodenLadder_BelowDeck"] {
		TravelAction
	}
end

M["Anchor_ToStern_Starboard"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 3,
		PositionY = 0,
		PositionZ = 1,
		Layer = 2,
		Name = "Anchor_ToStern_Starboard",
		Map = M._MAP,
		Resource = M["Anchor_ToStern_Starboard"]
	}
end

M["Anchor_FromStern_Starboard"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 0,
		PositionZ = 1,
		Name = "Anchor_FromStern_Starboard",
		Map = M._MAP,
		Resource = M["Anchor_FromStern_Starboard"]
	}
end

M["Anchor_ToStern_Port"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 3,
		PositionY = 0,
		PositionZ = 15,
		Layer = 2,
		Name = "Anchor_ToStern_Port",
		Map = M._MAP,
		Resource = M["Anchor_ToStern_Port"]
	}
end

M["Anchor_FromStern_Port"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 0,
		PositionZ = 15,
		Name = "Anchor_FromStern_Port",
		Map = M._MAP,
		Resource = M["Anchor_FromStern_Port"]
	}
end

M["Portal_ToStern_Starboard"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 0,
		PositionZ = 1,
		Name = "Portal_ToStern_Starboard",
		Map = M._MAP,
		Resource = M["Portal_ToStern_Starboard"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 2,
		SizeY = 2,
		SizeZ = 2,
		MapObject = M["Portal_ToStern_Starboard"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_ToStern_Starboard"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Starboard stairs",
		Language = "en-US",
		Resource = M["Portal_ToStern_Starboard"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.LocalTravelDestination {
		Map = M._MAP,
		Anchor = "Anchor_ToStern_Starboard",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Walk-up",
		XProgressive = "Walking-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_ToStern_Starboard"] {
		TravelAction
	}
end

M["Portal_FromStern_Starboard"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 1,
		PositionY = 0,
		PositionZ = 1,
		Layer = 2,
		Name = "Portal_FromStern_Starboard",
		Map = M._MAP,
		Resource = M["Portal_FromStern_Starboard"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 2,
		SizeY = 2,
		SizeZ = 2,
		MapObject = M["Portal_FromStern_Starboard"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_FromStern_Starboard"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Starboard stairs",
		Language = "en-US",
		Resource = M["Portal_FromStern_Starboard"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.LocalTravelDestination {
		Map = M._MAP,
		Anchor = "Anchor_FromStern_Starboard",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Walk-down",
		XProgressive = "Walking-down",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_FromStern_Starboard"] {
		TravelAction
	}
end

M["Portal_ToStern_Port"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 0,
		PositionZ = 15,
		Name = "Portal_ToStern_Port",
		Map = M._MAP,
		Resource = M["Portal_ToStern_Port"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 2,
		SizeY = 2,
		SizeZ = 2,
		MapObject = M["Portal_ToStern_Port"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_ToStern_Port"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Port stairs",
		Language = "en-US",
		Resource = M["Portal_ToStern_Port"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.LocalTravelDestination {
		Map = M._MAP,
		Anchor = "Anchor_ToStern_Port",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Walk-up",
		XProgressive = "Walking-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_ToStern_Port"] {
		TravelAction
	}
end

M["Portal_FromStern_Port"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 1,
		PositionY = 0,
		PositionZ = 15,
		Layer = 2,
		Name = "Portal_FromStern_Port",
		Map = M._MAP,
		Resource = M["Portal_FromStern_Port"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 2,
		SizeY = 2,
		SizeZ = 2,
		MapObject = M["Portal_FromStern_Port"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_FromStern_Port"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Port stairs",
		Language = "en-US",
		Resource = M["Portal_FromStern_Port"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.LocalTravelDestination {
		Map = M._MAP,
		Anchor = "Anchor_FromStern_Port",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Walk-down",
		XProgressive = "Walking-down",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_FromStern_Port"] {
		TravelAction
	}
end
