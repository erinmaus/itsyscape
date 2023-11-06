--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Rumbridge.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

include "Resources/Game/DB/Maps/Rumbridge/IsabelleIsland_AbandonedMine.lua"
include "Resources/Game/DB/Maps/Rumbridge/IsabelleIsland_FarOcean.lua"
include "Resources/Game/DB/Maps/Rumbridge/IsabelleIsland_FoggyForest.lua"
include "Resources/Game/DB/Maps/Rumbridge/IsabelleIsland_Port.lua"
include "Resources/Game/DB/Maps/Rumbridge/IsabelleIsland_Tower.lua"
include "Resources/Game/DB/Maps/Rumbridge/HighChambersYendor.lua"
include "Resources/Game/DB/Maps/Rumbridge/Rumbridge_Port.lua"
include "Resources/Game/DB/Maps/Rumbridge/Rumbridge_Labs.lua"
include "Resources/Game/DB/Maps/Rumbridge/Rumbridge_Town.lua"
include "Resources/Game/DB/Maps/Rumbridge/Rumbridge_Castle.lua"
include "Resources/Game/DB/Maps/Rumbridge/Rumbridge_Monastery.lua"
include "Resources/Game/DB/Maps/Rumbridge/Rumbridge_Farm.lua"

ItsyScape.Resource.Prop "Door_RumbridgeDungeon"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicDoor",
	Resource = ItsyScape.Resource.Prop "Door_RumbridgeDungeon"
}

ItsyScape.Meta.ResourceName {
	Value = "Dungeon door",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_RumbridgeDungeon"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Quaint, yet somehow ominous.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_RumbridgeDungeon"
}

ItsyScape.Resource.Prop "Door_RumbridgeStone"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicDoor",
	Resource = ItsyScape.Resource.Prop "Door_RumbridgeStone"
}

ItsyScape.Meta.ResourceName {
	Value = "Door",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_RumbridgeStone"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 2,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Door_RumbridgeStone"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Knock, knock.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_RumbridgeStone"
}

ItsyScape.Resource.Prop "Door_RumbridgeMansion" {
	ItsyScape.Action.Open(),
	ItsyScape.Action.Close()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicDoor",
	Resource = ItsyScape.Resource.Prop "Door_RumbridgeMansion"
}

ItsyScape.Meta.ResourceName {
	Value = "Front door",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_RumbridgeMansion"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 3.5,
	SizeY = 2,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Door_RumbridgeMansion"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Such a fancy, big door!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_RumbridgeMansion"
}

ItsyScape.Resource.Prop "Door_RumbridgeCastle" {
	ItsyScape.Action.Open(),
	ItsyScape.Action.Close()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicDoor",
	Resource = ItsyScape.Resource.Prop "Door_RumbridgeCastle"
}

ItsyScape.Meta.ResourceName {
	Value = "Big door",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_RumbridgeCastle"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 3.5,
	SizeY = 4,
	SizeZ = 0.5,
	MapObject = ItsyScape.Resource.Prop "Door_RumbridgeCastle"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A door for giants.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_RumbridgeCastle"
}

ItsyScape.Resource.Prop "Bed_Rumbridge" {
	ItsyScape.Action.Sleep()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "Bed_Rumbridge"
}

ItsyScape.Meta.ResourceName {
	Value = "Comfy bed",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Bed_Rumbridge"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Got you to think 'comfy'!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Bed_Rumbridge"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 1.5,
	SizeZ = 3.5,
	MapObject = ItsyScape.Resource.Prop "Bed_Rumbridge"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 4,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Throne_Rumbridge"
}

ItsyScape.Meta.ResourceName {
	Value = "Earl's Throne",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Throne_Rumbridge"
}

ItsyScape.Meta.ResourceDescription {
	Value = "An example of form over function.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Throne_Rumbridge"
}

ItsyScape.Resource.Prop "Banner_Rumbridge" {
	-- Nothing
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BlockingProp",
	Resource = ItsyScape.Resource.Prop "Banner_Rumbridge"
}

ItsyScape.Meta.ResourceName {
	Value = "Rumbridge banner",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Banner_Rumbridge"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 2,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Banner_Rumbridge"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Rumbridge's banner, representing the three pillars of Bastiel, Divine Arbiter's dogma, Arbitrationism.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Banner_Rumbridge"
}
