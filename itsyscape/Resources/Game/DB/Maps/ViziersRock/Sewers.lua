--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/ViziersRock/ViziersRock.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Raid = ItsyScape.Resource.Raid "ViziersRockSewers"

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Sewers of Vizier's Rock",
		Resource = ItsyScape.Resource.Raid "ViziersRockSewers"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "The sewers of the capital are crawling with pests! Exterminate them once and for all.",
		Resource = ItsyScape.Resource.Raid "ViziersRockSewers"
	}

	ItsyScape.Meta.RaidDestination {
		Raid = Raid,
		Map = ItsyScape.Resource.Map "ViziersRock_Sewers_Floor1",
		Anchor = "Anchor_FromCityCenter"
	}
end

do
	local RotateRightAction = ItsyScape.Action.Rotate()
	ItsyScape.Meta.RotateActionDirection {
		RotationX = -ItsyScape.Utility.Quaternion.Y_90.x,
		RotationY = -ItsyScape.Utility.Quaternion.Y_90.y,
		RotationZ = -ItsyScape.Utility.Quaternion.Y_90.z,
		RotationW = ItsyScape.Utility.Quaternion.Y_90.w,
		Action = RotateRightAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Rotate-right",
		XProgressive = "Rotating-right",
		Language = "en-US",
		Action = RotateRightAction
	}

	local RotateLeftAction = ItsyScape.Action.Rotate()
	ItsyScape.Meta.RotateActionDirection {
		RotationX = ItsyScape.Utility.Quaternion.Y_90.x,
		RotationY = ItsyScape.Utility.Quaternion.Y_90.y,
		RotationZ = ItsyScape.Utility.Quaternion.Y_90.z,
		RotationW = ItsyScape.Utility.Quaternion.Y_90.w,
		Action = RotateLeftAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Rotate-left",
		XProgressive = "Rotating-left",
		Language = "en-US",
		Action = RotateLeftAction
	}

	local Valve = ItsyScape.Resource.Prop "ViziersRock_Sewers_Valve" {
		RotateRightAction,
		RotateLeftAction
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.ViziersRock.SewerValve",
		Resource = Valve
	}

	ItsyScape.Meta.ResourceName {
		Value = "Sewer valve",
		Language = "en-US",
		Resource = Valve
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Controls water flow in the sewers.",
		Language = "en-US",
		Resource = Valve
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 1.5,
		SizeY = 1.5,
		SizeZ = 1.5,
		MapObject = Valve
	}
end

do
	local TriangleMark = ItsyScape.Resource.Prop "ViziersRock_Sewers_TriangleMark"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BlockingProp",
		Resource = TriangleMark
	}

	ItsyScape.Meta.ResourceName {
		Value = "Green triangle mark",
		Language = "en-US",
		Resource = TriangleMark
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A valve somewhere might match this mark.",
		Language = "en-US",
		Resource = TriangleMark
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 1.5,
		SizeY = 1.5,
		SizeZ = 1.5,
		MapObject = TriangleMark
	}
end

do
	local CircleMark = ItsyScape.Resource.Prop "ViziersRock_Sewers_CircleMark"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BlockingProp",
		Resource = CircleMark
	}

	ItsyScape.Meta.ResourceName {
		Value = "Blue circle mark",
		Language = "en-US",
		Resource = CircleMark
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A valve somewhere might match this mark.",
		Language = "en-US",
		Resource = CircleMark
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 1.5,
		SizeY = 1.5,
		SizeZ = 1.5,
		MapObject = CircleMark
	}
end

do
	local SquareMark = ItsyScape.Resource.Prop "ViziersRock_Sewers_SquareMark"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BlockingProp",
		Resource = SquareMark
	}

	ItsyScape.Meta.ResourceName {
		Value = "Red square mark",
		Language = "en-US",
		Resource = SquareMark
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A valve somewhere might match this mark.",
		Language = "en-US",
		Resource = SquareMark
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 1.5,
		SizeY = 1.5,
		SizeZ = 1.5,
		MapObject = SquareMark
	}
end

do
	local Door = ItsyScape.Resource.Prop "ViziersRock_Sewers_WaterDoor" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Water surge",
		Resource = Door
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Looks like there's no getting past that.",
		Resource = Door
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicDoor",
		Resource = Door
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 5.5,
		SizeY = 8,
		SizeZ = 5.5,
		MapObject = Door
	}
end

do
	local Pipe = ItsyScape.Resource.Prop "ViziersRock_Sewers_Pipe" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Pipe",
		Resource = Pipe
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Wonder where that leads... Wait, this isn't that kind of game!",
		Resource = Pipe
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.PassableProp",
		Resource = Pipe
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 2.5,
		SizeY = 2.5,
		SizeZ = 2.5,
		OffsetY = 0.5,
		MapObject = Pipe
	}
end
