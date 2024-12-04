local M = include "Resources/Game/Maps/Test_Ship/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Maps.ShipMapPeep2",
	Resource = M._MAP
}

M["Hotspot_Capstan"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 0,
		PositionZ = 0,
		Name = "Hotspot_Capstan",
		Map = M._MAP,
		Resource = M["Hotspot_Capstan"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "Capstan",
		ItemGroup = "Capstan",
		MapObject = M["Hotspot_Capstan"]
	}
end

M["Hotspot_Figurehead"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = -1,
		PositionY = -1.5,
		PositionZ = 0,
		Name = "Hotspot_Figurehead",
		Map = M._MAP,
		Resource = M["Hotspot_Figurehead"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "Figurehead",
		ItemGroup = "Figurehead",
		MapObject = M["Hotspot_Capstan"]
	}
end

M["Hotspot_Helm"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 3,
		PositionY = 0,
		PositionZ = 0,
		Layer = 2,
		Name = "Hotspot_Helm",
		Map = M._MAP,
		Resource = M["Hotspot_Helm"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "Helm",
		ItemGroup = "Helm",
		MapObject = M["Hotspot_Helm"]
	}
end

M["Hotspot_Hull"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.5,
		PositionY = 0,
		PositionZ = 8,
		Name = "Hotspot_Hull",
		Map = M._MAP,
		Resource = M["Hotspot_Hull"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "Hull",
		ItemGroup = "Hull",
		MapObject = M["Hotspot_Hull"]
	}
end

M["Hotspot_ForeMast"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 12,
		PositionY = 0,
		PositionZ = 0,
		Name = "Hotspot_ForeMast",
		Map = M._MAP,
		Resource = M["Hotspot_ForeMast"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "ForeMast",
		ItemGroup = "Mast",
		MapObject = M["Hotspot_ForeMast"]
	}
end

M["Hotspot_MainMast"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 32,
		PositionY = 0,
		PositionZ = 0,
		Name = "Hotspot_MainMast",
		Map = M._MAP,
		Resource = M["Hotspot_MainMast"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "MainMast",
		ItemGroup = "Mast",
		MapObject = M["Hotspot_MainMast"]
	}
end

M["Hotspot_RearMast"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 12,
		PositionY = 0,
		PositionZ = 0,
		Layer = 2,
		Name = "Hotspot_RearMast",
		Map = M._MAP,
		Resource = M["Hotspot_RearMast"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "RearMast",
		ItemGroup = "Mast",
		MapObject = M["Hotspot_RearMast"]
	}
end

M["Hotspot_Rail"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.5,
		PositionY = 0,
		PositionZ = 8,
		Name = "Hotspot_Rail",
		Map = M._MAP,
		Resource = M["Hotspot_Rail"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "Rail",
		ItemGroup = "Rail",
		MapObject = M["Hotspot_Rail"]
	}
end



M["Hotspot_Sail_ForeMast"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 12,
		PositionY = 0,
		PositionZ = 0,
		Name = "Hotspot_Sail_ForeMast",
		Map = M._MAP,
		Resource = M["Hotspot_Sail_ForeMast"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "Sail_ForeMast",
		ItemGroup = "Sail",
		MapObject = M["Hotspot_Sail_ForeMast"]
	}
end

M["Hotspot_Sail_MainMast"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 32,
		PositionY = 0,
		PositionZ = 0,
		Name = "Hotspot_Sail_MainMast",
		Map = M._MAP,
		Resource = M["Hotspot_Sail_MainMast"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "Sail_MainMast",
		ItemGroup = "Sail",
		MapObject = M["Hotspot_Sail_MainMast"]
	}
end

M["Hotspot_Sail_RearMast"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 12,
		PositionY = 0,
		PositionZ = 0,
		Layer = 2,
		Name = "Hotspot_Sail_RearMast",
		Map = M._MAP,
		Resource = M["Hotspot_Sail_RearMast"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "Sail_RearMast",
		ItemGroup = "Sail",
		MapObject = M["Hotspot_Sail_RearMast"]
	}
end


M["Hotspot_Window"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.5,
		PositionY = 0,
		PositionZ = 8,
		Name = "Hotspot_Window",
		Map = M._MAP,
		Resource = M["Hotspot_Window"]
	}

	ItsyScape.Meta.ShipSailingItemMapObjectHotspot {
		Slot = "Window",
		ItemGroup = "Window",
		MapObject = M["Hotspot_Window"]
	}
end
